#ifndef MYRP_LIT_INCLUDED
#define MYRP_LIT_INCLUDED
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

// cbuffer UnityPerFrame{
//     float4x4 unity_MatrixVP;
// }

// cbuffer UnityPerDraw{
//     float4x4 unity_ObjectToWorld;
// }

//常量缓冲区并不能在所有平台获得收益，所以我们托管给Unity内置的宏来处理
CBUFFER_START(UnityPerFrame)
    float4x4 unity_MatrixVP;
CBUFFER_END

CBUFFER_START(UnityPerDraw)
    float4x4 unity_ObjectToWorld;
CBUFFER_END

// CBUFFER_START(UnityPerMaterial)
//     float4 _BaseColor;
// CBUFFER_END


#define UNITY_MATRIX_M unity_ObjectToWorld
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"

UNITY_INSTANCING_BUFFER_START(Perinstance)
    UNITY_DEFINE_INSTANCED_PROP(float4,_BaseColor)
UNITY_INSTANCING_BUFFER_END(PerInstance)

#define MAX_VISIBLE_LIGHTS 4

CBUFFER_START(_LightBuffers)
    float4 _VisibleLightColors[MAX_VISIBLE_LIGHTS];
    float4 _VisibleLightDirections[MAX_VISIBLE_LIGHTS];
CBUFFER_END

float3 DiffuseLight(int index,float3 normal)
{
    float3 lightColor = _VisibleLightColors[index];
    float3 lightDirecion = _VisibleLightDirections[index].xyz;
    float diffuse = saturate(dot(normal,lightDirecion));
    return diffuse * lightColor;
}

struct Attributes{
    float4 positionOS:POSITION;
    float3 normal:NORMAL;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varings{
    float4 positionCS:SV_POSITION;
    float3 normal:TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

Varings vert(Attributes IN)
{
    Varings OUT;
    UNITY_SETUP_INSTANCE_ID(IN);
    UNITY_TRANSFER_INSTANCE_ID(IN,OUT);
    float4 worldPos = mul(UNITY_MATRIX_M,float4((IN.positionOS.xyz),1));
    OUT.positionCS = mul(unity_MatrixVP,worldPos);
    OUT.normal = mul((float3x3)UNITY_MATRIX_M,IN.normal);
    return OUT;
}

float4 frag(Varings i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    i.normal = normalize(i.normal);
    float3 albedo = UNITY_ACCESS_INSTANCED_PROP(PerInstance,_BaseColor);
    
    //float3 diffuseLight = saturate(dot(i.normal,float3(0,1,0)));
    float3 diffuseLight=0;
    for(int index = 0;index<MAX_VISIBLE_LIGHTS;index++)
    {
        diffuseLight += DiffuseLight(index,i.normal);
    }
    float3 color = albedo*diffuseLight;

    return float4(color,1);
}
#endif  //MYRP_LIT_INCLUDED

