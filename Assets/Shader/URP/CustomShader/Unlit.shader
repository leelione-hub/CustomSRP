Shader "Custom/URP/Unlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor("DiffuseColor",Color)=(1,1,1,1)
        _BaseColorInt("DiffuseInt",float)=1
    }
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
        pass
        {
            HLSLPROGRAM
            #pragma target 3.5
            #pragma multi_compile_instancing
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "../ShaderLibrary/Unlit.hlsl"
            ENDHLSL
        }
    }
}