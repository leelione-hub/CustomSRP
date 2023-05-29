using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(menuName ="Rendering/Custom Render Pipeline")]
public class CustomRenderPipelineAsset : RenderPipelineAsset
{
    [SerializeField]
    bool dynamicBatching;
    [SerializeField]
    bool Instancing;
    protected override RenderPipeline CreatePipeline()
    {
        Debug.Log("dynamicBatching:"+dynamicBatching);
        return new CustomRenderPipeline(dynamicBatching,Instancing);
    }
}
