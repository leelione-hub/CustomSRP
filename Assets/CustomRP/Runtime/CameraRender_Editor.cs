using UnityEngine;
using UnityEditor;
using UnityEngine.Rendering;
using UnityEngine.Profiling;
partial class CameraRender 
{
    partial void DrawUnsupportedShaders();
    partial void DrawGizmos();
    partial void PrepareForSceneWindow();
    partial void PrepareBuffer();

    #if UNITY_EDITOR

    //默认built-in项目中的shadertagids
    static ShaderTagId[] legacyShaderTagIds={
        new ShaderTagId("Always"),
        new ShaderTagId("ForwardBase"),
        new ShaderTagId("PrepassBase"),
        new ShaderTagId("Vertex"),
        new ShaderTagId("VertexLMRGBM"),
        new ShaderTagId("VertexLM")
    };

    static Material errorMaterial;
    string SampelName{get;set;}

    partial void PrepareBuffer()
    {
        Profiler.BeginSample("Editor Only");
        //buffer.name=camera.name;
        buffer.name = SampelName = camera.name;
        Profiler.EndSample();
    }

    partial void DrawGizmos()
    {
        if(Handles.ShouldRenderGizmos())
        {
            context.DrawGizmos(camera,GizmoSubset.PreImageEffects);
            context.DrawGizmos(camera,GizmoSubset.PostImageEffects);
        }
    }

    partial void PrepareForSceneWindow()
    {
        if(camera.cameraType == CameraType.SceneView)
        {
            ScriptableRenderContext.EmitWorldGeometryForSceneView(camera);
        }
    }

     //绘制URP不持支的built-in管线的shader
    partial void DrawUnsupportedShaders()
    {
        if(errorMaterial==null)
        {
            errorMaterial=new Material(Shader.Find("Hidden/InternalErrorShader"));
        }
        var drawingSettings = new DrawingSettings(
            legacyShaderTagIds[0],new SortingSettings(camera)
        ){
            overrideMaterial = errorMaterial,
        };
        for(int i=1;i<legacyShaderTagIds.Length;i++)
        {
            drawingSettings.SetShaderPassName(i,legacyShaderTagIds[i]);
        }
        var filteringSettings=new FilteringSettings(RenderQueueRange.all);
        context.DrawRenderers(cullingResults,ref drawingSettings,ref filteringSettings);
    }

    #else
    const string SampleName=bufferName;
    #endif
}