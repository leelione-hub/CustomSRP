#ifndef MYRP_UNLIT_INCLUDED
#define MYRP_UNLIT_INCLUDED
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

struct Attributes{
    float4 positionOS:POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varings{
    float4 positionCS:SV_POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

Varings vert(Attributes IN)
{
    Varings OUT;
    UNITY_SETUP_INSTANCE_ID(IN);
    UNITY_TRANSFER_INSTANCE_ID(IN,OUT);
    float4 worldPos = mul(UNITY_MATRIX_M,float4((IN.positionOS.xyz),1));
    OUT.positionCS = mul(unity_MatrixVP,worldPos);
    return OUT;
}

float4 frag(Varings i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    float4 finalColor = UNITY_ACCESS_INSTANCED_PROP(PerInstance,_BaseColor);
    return finalColor;
}
#endif

