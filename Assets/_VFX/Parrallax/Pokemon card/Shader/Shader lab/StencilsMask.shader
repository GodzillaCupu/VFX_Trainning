Shader "IndonesianTradingCard/StencilsMask"
{
    Properties
    {
        [intRange(0, 1)] _StencilRef("Stencil Ref", Range(0,255)) = 1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
            "Queue"="Geometry"
            "RenderPipeline"="UniversalPipeline"
        }
        Pass
        {
            Name "StencilMask"
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _AlphaCutoff;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS);
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 tex = tex2D(_MainTex, IN.uv);
                clip(tex.a - _AlphaCutoff); // Only draw where alpha > cutoff
                return tex;
            }
            ENDHLSL


            Stencil
            {
                Ref [_StencilRef]
                Comp Always
                Pass Replace
                Fail Keep
            }
            ZWrite Off
            ColorMask RGB
        }
    }
    FallBack "Off"
}
