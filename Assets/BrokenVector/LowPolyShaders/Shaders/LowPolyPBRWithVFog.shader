Shader "LowPolyShaders/LowPolyPBRWithFog" {
	Properties {
		_MainTex ("Color Scheme", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
    	_FogColor ("Fog Color", Color) = (1,1,1,1)
    	_FogStart ("Fog Start", Float) = 0.0
    	_FogDepth ("Fog Depth", Float) = -5.0
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0

		struct Input {
			float3 color : COLOR;
    		float2 uv_MainTex;
    		float3 worldPos;
		};

		sampler2D _MainTex;
		fixed4 _Color;
    	half3 _FogColor;
    	float _FogStart;
    	float _FogDepth;

		void vert (inout appdata_full v) {
			// the color comes from a texture tinted by color
			v.color = tex2Dlod(_MainTex, v.texcoord) * _Color;
        }

		half _Glossiness;
		half _Metallic;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from the vertex input
			//o.Albedo = IN.color;
			
    		fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
    		float clampedPos = clamp((IN.worldPos.y - _FogStart) / _FogDepth, 0.0, 1.0); // preparing "bw"ramp
    		o.Albedo = IN.color * c * (1-clampedPos); // apply inverted ramp to Texture
    		o.Emission = _FogColor * clampedPos; // apply ramp to FogColor
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
