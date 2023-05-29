using UnityEngine;
using UnityEngine.Rendering;

public class CustomRenderPipeline : RenderPipeline
{
    CameraRender renderer = new CameraRender();
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach(var temp in cameras)
        {
            renderer.Render(context, temp);
        }
        //throw new System.NotImplementedException();
    }
}
