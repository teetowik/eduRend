
Texture2D texDiffuse : register(t0);

cbuffer LightCamBuffer : register(b0)
{
    vector LightPosition;
    vector CamPosition;
};


cbuffer MaterialBuffer : register(b1)
{
    vector AmbientColour;
    vector DiffuseColour;
    vector SpecularColour;
}


struct PSIn
{
	float4 Pos  : SV_Position;
	float3 Normal : NORMAL;
	float2 TexCoord : TEX;
    float3 PosWorld : Position;
};

//-----------------------------------------------------------------------------------------
// Pixel Shader
//-----------------------------------------------------------------------------------------

float4 PS_main(PSIn input) : SV_Target
{
	// Debug shading #1: map and return normal as a color, i.e. from [-1,1]->[0,1] per component
	// The 4:th component is opacity and should be = 1
	//return float4(input.Normal*0.5+0.5, 1);
    
    float3 L = normalize(LightPosition.xyz - input.PosWorld);
    
    float3 V = normalize(CamPosition.xyz - input.PosWorld);
	
    float3 Ka = AmbientColour.xyz;
	
    float3 Kd = DiffuseColour.xyz;
	
    float3 Ks = SpecularColour.xyz;
	
    float3 R = reflect(-L, input.Normal);
    
    float Shininess = 30.0f;
	
    return float4(Ka + (Kd * max((dot(input.Normal, L)), 0.0) + Ks * (pow(max(dot(V, R), 0.0), Shininess))), 1);

	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//	return float4(input.TexCoord, 0, 1);
}


