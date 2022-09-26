Shader "Unlit/PseudoHighReso"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ResolutionMultiplier ("ResolutionMultiplier", Range(1, 8)) = 0
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            
            #include "UnityCG.cginc"
 
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            float _ResolutionMultiplier;
 
            inline float2 PseudoHighResolution(float2 uv, float multiplier)
            {
                float2 decimal = uv * _MainTex_TexelSize.zw + 0.5 / multiplier;
                float2 integer = floor(decimal);	// テクセル座標系の整数部分
                decimal -= integer;					// テクセル座標系の少数部分( 0 <= decimal < 1.0 )

                return (integer + min(decimal * multiplier, 1) - 0.5) * _MainTex_TexelSize.xy;
            }
            
            float4 frag (v2f_img i) : SV_Target
            {
                return tex2D(_MainTex, PseudoHighResolution(i.uv, _ResolutionMultiplier));
            }
            ENDCG
        }
    }
}
