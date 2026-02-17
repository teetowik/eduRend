
Texture2D texDiffuse : register(t0);
Texture2D NormalMap : register(t1);

SamplerState texSampler : register(s0);

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
    float3 Tangent : TANGENT;
    float3 Binormal : BINORMAL;
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
    /*
    float Shininess = 30.0f;
    
    float3 L = normalize(LightPosition.xyz - input.PosWorld);
    
    float3 V = normalize(CamPosition.xyz - input.PosWorld);
    
    float3 R = reflect(-L, input.Normal);
	
    float3 Ka = AmbientColour.xyz;
	
    float3 Kd = DiffuseColour.xyz;
    float3 diffuse = Kd * max((dot(input.Normal, L)), 0.0);
	
    float3 Ks = SpecularColour.xyz;
    float3 specular = Ks * (pow(max(dot(V, R), 0.0), Shininess));
	
    return float4(Ka + (Kd * max((dot(input.Normal, L)), 0.0) + Ks * (pow(max(dot(V, R), 0.0), Shininess))), 1);
*/
    
    //input.TexCoord = input.TexCoord * 2;

    float4 texColour = texDiffuse.Sample(texSampler, input.TexCoord);
    float3 Normal = input.Normal;
    
    int normalWidth, normalHeight;
    NormalMap.GetDimensions(normalWidth, normalHeight);
    
    if (normalWidth != 0)
    {
        float3x3 TBN = transpose(float3x3(input.Tangent, input.Binormal, input.Normal));
        Normal = NormalMap.Sample(texSampler, input.TexCoord).xyz;
        Normal = Normal * 2 - 1;
    
        Normal = mul(TBN, Normal);
    }
    
    float Shininess = 30.0f;
    
    float3 L = normalize(LightPosition.xyz - input.PosWorld);
    
    float3 V = normalize(CamPosition.xyz - input.PosWorld);
    
    float3 R = reflect(-L, Normal);
	
    float4 Ka = AmbientColour * texColour;
	
    float diffuse = max((dot(Normal, L)), 0.0);
    float4 Kd = DiffuseColour * texColour * diffuse;
	
    float specular = (pow(max(dot(V, R), 0.0), Shininess));
    float4 Ks = SpecularColour * specular;
    
    return float4(Ka + Kd + Ks);
    
	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//	return float4(input.TexCoord, 0, 1);
}


