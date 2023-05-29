using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public partial class CameraRender
{
    ScriptableRenderContext context;
    Camera camera;
    CullingResults cullingResults;

    static string buffername = "Render Buffer";

    CommandBuffer buffer = new CommandBuffer
    {
        name = buffername
    };

    static ShaderTagId unlitShaderTagId = new ShaderTagId("SRPDefaultUnlit");
    //static ShaderTagId[] legacyShaderTagIds = {
    //    new ShaderTagId("Always"),
    //    new ShaderTagId("ForwardBase"),
    //    new ShaderTagId("PrepassBase"),
    //    new ShaderTagId("Vertex"),
    //    new ShaderTagId("VertexLMRGBM"),
    //    new ShaderTagId("VertexLM")
    //};

    //static Material errorMaterial;
    public void Render(ScriptableRenderContext context,Camera camera)
    {
        this.context = context;
        this.camera = camera;

        if (!Cull())
        {
            return;
        }

        Setup();
        DrawVisibleGeometry();
        DrawUnsupportedShaders();
        Submit();
    }

    void DrawVisibleGeometry()
    {
        var sortingSettings = new SortingSettings(camera) 
        { 
            //强制修改渲染顺序
            criteria = SortingCriteria.CommonOpaque 
        };

        // 使用一个指定的着色器通道，新建渲染设置
        var drawingSettings = new DrawingSettings(unlitShaderTagId, sortingSettings);
        //允许哪些渲染队列
        var filteringSetting = new FilteringSettings(RenderQueueRange.opaque);

        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSetting);
        context.DrawSkybox(camera);

        //在绘制天空盒之后绘制透明对象
        sortingSettings.criteria = SortingCriteria.CommonTransparent;
        drawingSettings.sortingSettings = sortingSettings;
        filteringSetting.renderQueueRange = RenderQueueRange.transparent;
        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSetting);

    }

    //void DrawUnsupportedShaders()
    //{
    //    //标准出错Shader显示材质（洋红色）
    //    if (errorMaterial == null) errorMaterial = new Material(Shader.Find("Hidden/InternalErrorShader"));
    //    var drawingSettings = new DrawingSettings(legacyShaderTagIds[0], new SortingSettings(camera)) { /*overrideMaterial = errorMaterial */};
    //    for (int i = 1; i < legacyShaderTagIds.Length; i++)
    //    {
    //        drawingSettings.SetShaderPassName(i, legacyShaderTagIds[i]);
    //    }
    //    var filteringSettings = FilteringSettings.defaultValue;
    //    context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings);
    //}

    void Setup()
    {
        //设置渲染相机
        context.SetupCameraProperties(camera);
        buffer.ClearRenderTarget(true, true, Color.clear);
        //加上一个标记 (开始和结束的名称相同)
        buffer.BeginSample(buffername);
        ExcuteBuffer();
    }
    void Submit()
    {
        buffer.EndSample(buffername);
        ExcuteBuffer();
        context.Submit();
    }

    void ExcuteBuffer()
    {
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }


    bool Cull()
    {
        // 填充来自摄像机的剔除参数
        if (camera.TryGetCullingParameters(out ScriptableCullingParameters p))
        {
            // 执行剔除操作，并存储剔除结果
            cullingResults = context.Cull(ref p);
            return true;
        }
        return false;
    }
}