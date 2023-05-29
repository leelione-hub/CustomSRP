using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

partial class CameraRender 
{
    public ScriptableRenderContext context;
    public Camera camera;
    const string bufferName="Render Camera Buffer";

    bool enableDynamicBatching,enableInstancing;

    CommandBuffer buffer = new CommandBuffer{
        name=bufferName
    };

        static ShaderTagId[] urpShaderTagIds={
        new ShaderTagId("UniversalForward"),
        new ShaderTagId("UniversalGBuffer"),
        new ShaderTagId("UniversalForwardOnly"),
        new ShaderTagId("DepthNormalsOnly"),
        new ShaderTagId("Universal2D"),
        new ShaderTagId("ShadowCaster"),
        new ShaderTagId("DepthOnly"),
        new ShaderTagId("Meta"),
        new ShaderTagId("SRPDefaultUnlit")
    };

    CullingResults cullingResults;

    const int maxVisibleLights=4;
    static int visibleLightColorsId = 
        Shader.PropertyToID("_VisibleLightColors");
    static int visibleLightDirectionsId = 
        Shader.PropertyToID("_VisibleLightDirections");
    
    Vector4[] visibleLightColors = new Vector4[maxVisibleLights];
    Vector4[] visibleLightDirections = new Vector4[maxVisibleLights];


    //static ShaderTagId unlitShaderTagId = new ShaderTagId("UniversalForward");
    //static ShaderTagId unlitShaderTagId = new ShaderTagId("SRPDefaultUnlit");

    public CameraRender(bool enableDynamicBatching,bool enableInstancing)
    {
        this.enableDynamicBatching=enableDynamicBatching;
        this.enableInstancing=enableInstancing;
    }

    public void Render(ScriptableRenderContext context,Camera camera)
    {
        this.context=context;
        this.camera=camera;
        PrepareBuffer();
        PrepareForSceneWindow();

        if(!Cull())
        {
            return;
        }

        Setup();
        DrawVisibleGeometry();
        DrawUnsupportedShaders();
        DrawGizmos();
        Submit();
    }

    void DrawVisibleGeometry()
    {
        #region  绘制不透明几何
        //画几何
        var sortingSettings = new SortingSettings(camera){
            criteria = SortingCriteria.CommonOpaque
        };
        //ShaderTagId unlitShaderTagId = new ShaderTagId("UniversalForward");
        var drawingSetting = new DrawingSettings(
            urpShaderTagIds[0],sortingSettings
        );
        for(int i=1;i<urpShaderTagIds.Length;i++)
        {
            drawingSetting.SetShaderPassName(i,urpShaderTagIds[i]);
        }
        drawingSetting.enableDynamicBatching=enableDynamicBatching;
        drawingSetting.enableInstancing=enableInstancing;
        //drawingSetting.SetShaderPassName(1,urpShaderTagIds[8]);
        var filteringSettings = new FilteringSettings(RenderQueueRange.opaque);
        context.DrawRenderers(
            cullingResults,ref drawingSetting,ref filteringSettings
        );
        #endregion

        context.DrawSkybox(camera);

        DrawTransparent(ref sortingSettings,ref drawingSetting,ref filteringSettings);
    }

    void DrawTransparent(ref SortingSettings sortingSettings,
        ref DrawingSettings drawingSettings, ref FilteringSettings filteringSettings)
    {
        sortingSettings.criteria=SortingCriteria.CommonTransparent;
        drawingSettings.sortingSettings=sortingSettings;
        filteringSettings.renderQueueRange=RenderQueueRange.transparent;
        context.DrawRenderers(
            cullingResults,ref drawingSettings,ref filteringSettings
        );
    }

   

    void Setup()
    {
        //设置相机的属性
        context.SetupCameraProperties(camera);
        CameraClearFlags flags = camera.clearFlags;
        //清除渲染目标以消除其旧得内容(注意ClearRenderTarget用命令缓冲区的名称将清除封装在一个同一个样本中)
        buffer.ClearRenderTarget(
            flags <= CameraClearFlags.Depth,
            flags == CameraClearFlags.Color,
            flags == CameraClearFlags.Color?
            camera.backgroundColor.linear:Color.clear);
        ConfigLights();
        //使用命令缓冲区注入给Profiler注入样本，可以在Profiler和Fragment Debug中查看
        buffer.BeginSample(SampelName);
        buffer.SetGlobalVectorArray(
            visibleLightColorsId,visibleLightColors
        );
        buffer.SetGlobalVectorArray(
            visibleLightDirectionsId,visibleLightDirections
        );
        ExecuteBuffer();

    }

    void Submit()
    {
        buffer.EndSample(SampelName);
        ExecuteBuffer();
        context.Submit();
    }

    //执行缓冲区()
    void ExecuteBuffer()
    {
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    //剔除
    bool Cull()
    {
        if(camera.TryGetCullingParameters(out ScriptableCullingParameters p))
        {
            cullingResults=context.Cull(ref p);
            return true;
        }
        return false;
    }

    void ConfigLights()
    {
        for(int i=0;i<cullingResults.visibleLights.Length;i++)
        {
            VisibleLight light = cullingResults.visibleLights[i];
            visibleLightColors[i] = light.finalColor;
        }
    }
}
