Shader "UI/UIImageGray"
{
    Properties
    {
        [PerRendererData]_MainTex ("Texture", 2D) = "white" {}
        _GrayInt("GrayInt",Range(0,1))=1
    }
    SubShader
    {
        Tags
        {

        }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _GrayInt;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color=v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv)*i.color;
                fixed gray = (col.r*30+col.g*59+col.b*11+50)/100;
                fixed4 finalColor = fixed4(gray,gray,gray,col.a);
                finalColor=lerp(col,finalColor,_GrayInt);
                return finalColor;
            }
            ENDCG
        }
    }
}
