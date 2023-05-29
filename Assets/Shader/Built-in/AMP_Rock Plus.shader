// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Scene/AMP_RockPlus"
{
	Properties
	{
		_ShadowInt("ShadowInt", Range( 0 , 1)) = 0
		_DarkLength("DarkLength", Float) = 100
		_DarkSmoothStep("DarkSmoothStep", Float) = 0.5
		_DarkRange("DarkRange", Float) = 0
		_ToonShadowInt("ToonShadowInt", Range( 0 , 1)) = 0
		_ToonShadowRange("ToonShadowRange", Float) = 2
		_TranslucencyLengthRange("TranslucencyLengthRange", Float) = 10
		_TranslucencyRange("TranslucencyRange", Range( 0 , 1)) = 0
		_TranslucencyStep("TranslucencyStep", Float) = 5
		_TranslucencyColor("TranslucencyColor", Color) = (0,0,0,0)
		_TranslucencyInt("TranslucencyInt", Float) = 0
		_TranslucencyDistance("TranslucencyDistance", Range( 0 , 1)) = 0
		[Toggle(_USEWORLDPOSITION_ON)] _UseWorldPosition("UseWorldPosition", Float) = 0
		_NormalUp("NormalUp", Range( 0 , 1)) = 1
		_HighMap("HighMap", 2D) = "white" {}
		_HighMapOffset("HighMapOffset", Vector) = (0,0,0,0)
		_HighMapScale("HighMapScale", Float) = 1
		_CoverPoint("CoverPoint", Float) = -0.37
		_CoverStep("CoverStep", Range( 0 , 1)) = 0.324748
		_BottomPoint("BottomPoint", Float) = -1
		_BottomStep("BottomStep", Range( 0 , 1)) = 0
		_SpecGloss("SpecGloss", Float) = 17.16
		_SpecInt("SpecInt", Float) = 1.2
		_MainTex("MainTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,0)
		_MainInt("MainInt", Float) = 1
		_CoverTex("CoverTex", 2D) = "white" {}
		_CoverColor("CoverColor", Color) = (1,1,1,0)
		_CoverInt("CoverInt", Float) = 1
		_CoverTexUV("CoverTexUV", Float) = 1
		_BottomTex("BottomTex", 2D) = "white" {}
		_BottomColor("BottomColor", Color) = (1,1,1,0)
		_BottomInt("BottomInt", Float) = 1
		_BottomTexUV("BottomTexUV", Float) = 1
		_NorInt("NorInt", Float) = 1
		_NorTex("NorTex", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEWORLDPOSITION_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _NorTex;
		uniform float4 _NorTex_ST;
		uniform float _NorInt;
		uniform float _NormalUp;
		uniform float _CoverPoint;
		uniform float _CoverStep;
		uniform float _BottomPoint;
		uniform sampler2D _HighMap;
		uniform float2 _HighMapOffset;
		uniform float _HighMapScale;
		uniform float _BottomStep;
		uniform float _ShadowInt;
		uniform float _SpecGloss;
		uniform float _SpecInt;
		uniform float _TranslucencyLengthRange;
		uniform float _TranslucencyRange;
		uniform float _TranslucencyStep;
		uniform float _TranslucencyDistance;
		uniform float _TranslucencyInt;
		uniform float4 _TranslucencyColor;
		uniform float _ToonShadowInt;
		uniform float _ToonShadowRange;
		uniform float _DarkLength;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _MainColor;
		uniform float _MainInt;
		sampler2D _CoverTex;
		uniform float _CoverTexUV;
		uniform float4 _CoverColor;
		uniform float _CoverInt;
		sampler2D _BottomTex;
		uniform float _BottomTexUV;
		uniform float4 _BottomColor;
		uniform float _BottomInt;
		uniform float _DarkRange;
		uniform float _DarkSmoothStep;


		inline float4 TriplanarSampling72( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling73( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 uv_NorTex = i.uv_texcoord * _NorTex_ST.xy + _NorTex_ST.zw;
			float3 tex2DNode71 = UnpackScaleNormal( tex2D( _NorTex, uv_NorTex ), _NorInt );
			float3 newWorldNormal17_g73 = normalize( (WorldNormalVector( i , tex2DNode71 )) );
			float3 lerpResult12_g73 = lerp( newWorldNormal17_g73 , float3(0,1,0) , _NormalUp);
			float temp_output_9_0_g73 = saturate( ( ( newWorldNormal17_g73.y + _CoverPoint ) / _CoverStep ) );
			float3 lerpResult22_g73 = lerp( newWorldNormal17_g73 , lerpResult12_g73 , temp_output_9_0_g73);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			#ifdef _USEWORLDPOSITION_ON
				float staticSwitch36_g73 = ase_worldPos.y;
			#else
				float staticSwitch36_g73 = ase_vertex3Pos.y;
			#endif
			float2 appendResult19_g73 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_29_0_g73 = saturate( ( ( ( staticSwitch36_g73 + ( _BottomPoint * -1.0 ) ) * tex2D( _HighMap, ( ( appendResult19_g73 + _HighMapOffset ) * _HighMapScale ) ).r ) / ( _BottomStep * -1.0 ) ) );
			float3 lerpResult15_g73 = lerp( lerpResult22_g73 , lerpResult12_g73 , temp_output_29_0_g73);
			float3 NormalInput301_g71 = lerpResult15_g73;
			float dotResult226_g71 = dot( ase_worldlightDir , NormalInput301_g71 );
			float3 LightColor46_g71 = ( ase_lightColor.rgb * (saturate( ( ase_lightAtten * dotResult226_g71 ) )*1.0 + _ShadowInt) );
			UnityGI gi86_g71 = gi;
			float3 diffNorm86_g71 = NormalInput301_g71;
			gi86_g71 = UnityGI_Base( data, 1, diffNorm86_g71 );
			float3 indirectDiffuse86_g71 = gi86_g71.indirect.diffuse + diffNorm86_g71 * 0.0001;
			float3 SkyColor35_g71 = (indirectDiffuse86_g71).xyz;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult7_g74 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult4_g74 = dot( normalizeResult7_g74 , tex2DNode71 );
			float SpMask33_g74 = saturate( ( dotResult4_g74 * ase_lightAtten ) );
			float Sp32_g74 = ( pow( SpMask33_g74 , max( _SpecGloss , 0.2 ) ) * _SpecInt * 1.0 );
			float SpCover29_g74 = ( pow( SpMask33_g74 , 1.0 ) * 1.0 * 1.0 );
			float lerpResult40_g74 = lerp( Sp32_g74 , SpCover29_g74 , 0.0);
			float SpBottom28_g74 = ( pow( SpMask33_g74 , 1.0 ) * 1.0 * 1.0 );
			float lerpResult42_g74 = lerp( lerpResult40_g74 , SpBottom28_g74 , 0.0);
			float3 worldSpaceViewDir65_g71 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
			float3 objToWorldDir68_g71 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 0 ) ).xyz;
			float dotResult69_g71 = dot( -( ase_worldlightDir + ( objToWorldDir68_g71 * _TranslucencyRange ) ) , ase_worldViewDir );
			float clampResult318_g71 = clamp( ase_lightAtten , _TranslucencyDistance , 1.0 );
			float4 SSSColor59_g71 = ( saturate( ( pow( length( ( worldSpaceViewDir65_g71 * _TranslucencyLengthRange * 0.001 ) ) , 2.0 ) * pow( ( dotResult69_g71 * (NormalInput301_g71).y ) , _TranslucencyStep ) * clampResult318_g71 ) ) * _TranslucencyInt * _TranslucencyColor );
			float dotResult175_g71 = dot( NormalInput301_g71 , ase_worldlightDir );
			float lerpResult174_g71 = lerp( (1.0 + (_ToonShadowInt - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) , 1.0 , step( _ToonShadowRange , dotResult175_g71 ));
			float3 worldSpaceViewDir24_g71 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
			float lerpResult19_g71 = lerp( 1.0 , 0.0 , saturate( length( ( worldSpaceViewDir24_g71 * _DarkLength * 0.001 ) ) ));
			float lengh178_g71 = lerpResult19_g71;
			float clampResult173_g71 = clamp( lerpResult174_g71 , ( 1.0 - lengh178_g71 ) , 1.0 );
			float ToonShadow169_g71 = clampResult173_g71;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar72 = TriplanarSampling72( _CoverTex, ( ase_worldPos * _CoverTexUV ), ase_worldNormal, 1.0, float2( 1,1 ), 1.0, 0 );
			float3 lerpResult239_g71 = lerp( ( tex2D( _MainTex, uv_MainTex ) * _MainColor * _MainInt ).rgb , ( triplanar72 * _CoverColor * _CoverInt ).xyz , temp_output_9_0_g73);
			float4 triplanar73 = TriplanarSampling73( _BottomTex, ( ase_worldPos * _BottomTexUV ), ase_worldNormal, 1.0, float2( 1,1 ), 1.0, 0 );
			float3 lerpResult243_g71 = lerp( lerpResult239_g71 , ( triplanar73 * _BottomColor * _BottomInt ).xyz , temp_output_29_0_g73);
			float dotResult5_g72 = dot( ase_worldNormal , ase_worldlightDir );
			float clampResult13_g71 = clamp( ( ( (dotResult5_g72*0.5 + 0.5) + _DarkRange ) / abs( _DarkSmoothStep ) ) , lerpResult19_g71 , 1.0 );
			float DackDetail12_g71 = clampResult13_g71;
			c.rgb = ( ( float4( LightColor46_g71 , 0.0 ) + float4( SkyColor35_g71 , 0.0 ) + lerpResult42_g74 + SSSColor59_g71 ) * ToonShadow169_g71 * float4( lerpResult243_g71 , 0.0 ) * DackDetail12_g71 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
387;136;1920;1023;5442.853;3427.029;3.760589;True;False
Node;AmplifyShaderEditor.RangedFloatNode;83;-3185.61,-1774.965;Inherit;False;Property;_BottomTexUV;BottomTexUV;36;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-3180.154,-1871.754;Inherit;False;Property;_CoverTexUV;CoverTexUV;32;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;81;-3182.921,-2026.611;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2812.18,-1792.863;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-2754.395,-2639.924;Inherit;False;Property;_NorInt;NorInt;37;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2827.04,-1993.176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;69;-2589.574,-2443.521;Inherit;True;Property;_MainTex;MainTex;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-2485.991,-2086.941;Inherit;False;Property;_MainInt;MainInt;28;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2389.222,-1222.17;Inherit;False;Property;_BottomInt;BottomInt;35;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;66;-2558.182,-2246.686;Inherit;False;Property;_MainColor;MainColor;27;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;68;-2435.303,-1827.356;Inherit;False;Property;_CoverColor;CoverColor;30;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;75;-2462.413,-1383.45;Inherit;False;Property;_BottomColor;BottomColor;34;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-2363.112,-1667.612;Inherit;False;Property;_CoverInt;CoverInt;31;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-2593.191,-2685.621;Inherit;True;Property;_NorTex;NorTex;38;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;72;-2629.122,-2015.391;Inherit;True;Spherical;World;False;CoverTex;_CoverTex;white;29;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;73;-2627.631,-1577.725;Inherit;True;Spherical;World;False;BottomTex;_BottomTex;white;33;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;95;-2019.228,-2388.844;Inherit;False;NormalWarpUP;13;;73;f46d3b5f55b4bbf488dd60e27b19b95b;0;1;41;FLOAT3;0,0,1;False;3;FLOAT3;0;FLOAT;39;FLOAT;40
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2095.847,-1398.811;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-2069.736,-1844.252;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-2192.614,-2263.582;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;96;-1656.489,-2505.669;Inherit;False;ToonLightSpec;23;;74;de863677f82b06b4d9972a8bc5cb97b8;0;10;39;FLOAT3;0,0,0;False;13;FLOAT;1;False;41;FLOAT;0;False;15;FLOAT;1;False;44;FLOAT;1;False;45;FLOAT;1;False;43;FLOAT;0;False;20;FLOAT;1;False;47;FLOAT;1;False;46;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-2982.536,-1628.482;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;94;-1351.084,-2034.925;Inherit;False;ToonLightSky;0;;71;30824869f926f944e8ad480a89c18229;0;7;300;FLOAT3;0,1,0;False;110;FLOAT3;0,0,0;False;310;FLOAT;0;False;244;FLOAT3;0,0,0;False;308;FLOAT;0;False;309;FLOAT;0;False;245;FLOAT3;0,0,0;False;1;COLOR;75
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;97;-1037.839,-2030.511;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Scene/AMP_RockPlus;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;67;0;81;0
WireConnection;67;1;83;0
WireConnection;74;0;81;0
WireConnection;74;1;82;0
WireConnection;71;5;79;0
WireConnection;72;9;74;0
WireConnection;73;9;67;0
WireConnection;95;41;71;0
WireConnection;77;0;73;0
WireConnection;77;1;75;0
WireConnection;77;2;78;0
WireConnection;84;0;72;0
WireConnection;84;1;68;0
WireConnection;84;2;76;0
WireConnection;80;0;69;0
WireConnection;80;1;66;0
WireConnection;80;2;70;0
WireConnection;96;39;71;0
WireConnection;85;0;81;1
WireConnection;85;1;81;3
WireConnection;94;300;95;0
WireConnection;94;110;80;0
WireConnection;94;310;96;0
WireConnection;94;244;84;0
WireConnection;94;308;95;39
WireConnection;94;309;95;40
WireConnection;94;245;77;0
WireConnection;97;13;94;75
ASEEND*/
//CHKSM=C0371EBD2A774E90372C4CB888881B756758840E