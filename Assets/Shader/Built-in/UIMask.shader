Shader "Unlit/UIMask"
{
    Properties
    {

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile __ UNITY_UI_CLIP_RECT

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
			    float4 worldPosition : TEXCOORD1;
            };

            float4 _ClipRect;

            v2f vert (appdata v)
            {
               v2f o;
			    o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
			    o.vertex = UnityObjectToClipPos(v.vertex);
			    return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //return _ClipRect;
                fixed4 col;
                float xx = UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                if (xx > 0)
				{
					col = fixed4(1, 0, 0, 1);
				}
				else
				{
					col = fixed4(1, 1, 0, 1);
				}

				return xx;
            }
            ENDCG
        }
    }
}
