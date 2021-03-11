Shader "Unlit/GlassWater"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size("Size", Float) = 1
        _Distortion("Distortion", Range(0, 1)) = 1
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

            #include "UnityCG.cginc"

            float _Size;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 col = 0;
                float2 aspect = float2(2, 1);
                float2 uv = i.uv * _Size * aspect;
                float2 gv = frac(uv) - 0.5;             // frac 只保留小数部分  范围 -0.5 - 0.5
                float drop = smoothstep(0.05, 0.03, length(gv / aspect));

                col += drop;
                //col.rg += gv;                            


                if (gv.x > 0.48 || gv.y > 0.49)
                {
                    return float4(1, 0, 0, 0);
                }
                return col;
            }
            ENDCG
        }
    }
}
