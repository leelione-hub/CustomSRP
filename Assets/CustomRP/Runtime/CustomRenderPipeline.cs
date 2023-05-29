using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class CustomRenderPipeline : RenderPipeline
{
    private CameraRender renderer;
    
    public CustomRenderPipeline(bool enableDynamicBatching,bool enableInstancing)
    {
        GraphicsSettings.lightsUseLinearIntensity = true;
        renderer = new CameraRender(enableDynamicBatching,enableInstancing);
    }
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach(Camera camera in cameras)
        {
            renderer.Render(context,camera);
        }
    }
}
