using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetMaterialPreperty : MonoBehaviour
{
    public Color color;
    static int colorID = Shader.PropertyToID("_BaseColor");
    void OnValidate()
    {
        var propertyBlock=new MaterialPropertyBlock();
        propertyBlock.SetColor("_BaseColor",color);
        GetComponent<MeshRenderer>().SetPropertyBlock(propertyBlock);
    }
}
