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
                float t = _Time.y;
                float4 col = 0; 
                float2 aspect = float2(2, 1);
                float2 uv = i.uv * _Size * aspect;
                float2 gv = frac(uv) - 0.5;                             // frac (值：x - floor(x)）  gv范围 -0.5 - 0.5

                float x = 0;
                float y = -sin(t + sin(t + sin(t) * 0.5)) * 0.45;       // -0.5 - 0.5

                float2 dropPos = (gv - float2(x, y)) / aspect;          // gv 相对于 x,y的向量， 除aspect椭圆变正圆
                float drop = smoothstep(0.05, 0.03, length(dropPos));   // 小于0.03 为1， 大于0.05 为0， 中间平滑过渡

                float2 dropTrailPos = (gv - float2(x, 0)) / aspect;     // 创建拖尾水滴
                //return fixed4(frac(dropTrailPos.y), 0, 0, 0);
                dropTrailPos.y = (frac(dropTrailPos.y * 8) / 8) - 0.03; // 生成多个水滴，生成的是半圆，因为是到 最低边中点为圆心 的距离，所以减0.03就是底边加0.03为圆心
                float dropTrail = smoothstep(0.03, 0.02, length(dropTrailPos));


                col += drop;
                col += dropTrail;
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
