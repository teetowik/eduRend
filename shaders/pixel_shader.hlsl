
Texture2D texDiffuse : register(t0);
Texture2D NormalMap : register(t1);
Texture2D texSpecular : register(t2);
TextureCube CubeMap : register(t3);

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
    
    float3 texColour = texDiffuse.Sample(texSampler, input.TexCoord).xyz;
    float3 Normal = input.Normal;
    //float4 specColour = float4(1, 1, 1, 1);
    
    int normalWidth, normalHeight, specularWidth, specularHeight;
    NormalMap.GetDimensions(normalWidth, normalHeight);
    
    if (normalWidth != 0)
    {
        float3x3 TBN = transpose(float3x3(input.Tangent, input.Binormal, input.Normal));
        float3 normal = NormalMap.Sample(texSampler, input.TexCoord).xyz * 2 - 1;
    
        Normal = mul(TBN, normal);
    }
    
    float Shininess = 0.0f;
    
    float3 L = normalize(LightPosition.xyz - input.PosWorld);
    
    float3 V = normalize(CamPosition.xyz - input.PosWorld);
    
    float3 R = reflect(-L, Normal);
    
    //float3 cubeMap = CubeMap.Sample(texSampler, reflect(V, Normal)).xyz;
    float3 cubeMap = CubeMap.Sample(texSampler, V).xyz; // for skybox
	
    float3 Ka = AmbientColour.xyz * texColour;
	
    float diffuse = saturate((dot(Normal, L)));
    float3 Kd = texColour * diffuse * cubeMap;
	
    float specular = (pow(max(dot(V, R), 0.0), Shininess));
    float3 Ks = SpecularColour.xyz * specular * cubeMap; // * specColour;
    
    return float4(Ka + Kd + Ks, 1);
    
	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//	return float4(input.TexCoord, 0, 1);
}


