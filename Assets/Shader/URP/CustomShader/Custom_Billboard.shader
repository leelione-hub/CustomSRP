Shader "Custom/URP/Custom_Billboard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor("DiffuseColor",Color)=(1,1,1,1)
        _BaseColorInt("DiffuseInt",float)=1
        _YOffset("YOffset",Range(0,1))=1
    }
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }

        // #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        // #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        Pass
        {
            Tags{"LightMode"="UniversalForward"}

            Cull Back

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            real4 _BaseColor;
            real _BaseColorInt;
            float _YOffset;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal:NORMAL;
            };

            struct Varings
            {
                float4 positionCS : SV_POSITION;
                float4 uv : TEXCOORD0;
            };

            TEXTURE2D (_MainTex);
            SAMPLER(sampler_MainTex);

            Varings vert (Attributes IN)
            {
                Varings OUT;

                float3 center = float3(0,0,0);
                float3 viewLocal = mul (unity_WorldToObject,float4(_WorldSpaceCameraPos,1));
                viewLocal.y=lerp(0,viewLocal.y,_YOffset);
                viewLocal=normalize(viewLocal);
                float3 upDir=viewLocal.y>0.99?float3(1,0,0):float3(0,1,0);
                float3 rightDir=normalize(cross(viewLocal,upDir));
                upDir=normalize(cross(rightDir,viewLocal));
                
                float3 v = IN.positionOS.xyz; 

                float3 offset = center + v.x*rightDir + v.y*upDir + v.z*viewLocal;
                 
                OUT.positionCS = TransformObjectToHClip(offset);
                // VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS.xyz);
                // OUT.positionCS = positionInputs.positionCS;
                
                OUT.uv.xy = TRANSFORM_TEX(IN.uv, _MainTex);
                return OUT;
            }

            half4 frag (Varings i) : SV_Target
            {
                // sample the texture
                half4 col = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex, i.uv.xy);
                col*=_BaseColor*_BaseColorInt;
                return col;
            }
            ENDHLSL
        }
    }
    Fallback "Universal Render Pipeline/UnLit"
}