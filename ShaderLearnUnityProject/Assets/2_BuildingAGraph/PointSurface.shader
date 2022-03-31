Shader "2_Graph/PointSurface"
{
    SubShader
    {
        CGPROGRAM
        
        #pragma surface ConfigureSurface Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
			float3 worldPos;
		};

		void ConfigureSurface (Input input, SurfaceOutputStandard surface)
		{
			surface.Smoothness = 0.5;
		}
        
		ENDCG
    }
    FallBack "Diffuse"
}
