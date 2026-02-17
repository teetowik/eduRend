#include "model.h"

Model::Model(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context)
	: m_dxdevice(dxdevice), m_dxdevice_context(dxdevice_context)
{
	InitMaterialBuffer();

	samplerdesc = {
		D3D11_FILTER_ANISOTROPIC,
		D3D11_TEXTURE_ADDRESS_MIRROR,
		D3D11_TEXTURE_ADDRESS_MIRROR,
		D3D11_TEXTURE_ADDRESS_MIRROR,
		0.0f,
		16,
		D3D11_COMPARISON_NEVER,
		{1.0f, 1.0f, 1.0f, 1.0f},
		-FLT_MAX,
		FLT_MAX,
	};

	dxdevice->CreateSamplerState(&samplerdesc, &sampler);
}


void Model::InitMaterialBuffer()
{
	HRESULT hr;
	D3D11_BUFFER_DESC matrixBufferDesc = { 0 };
	matrixBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	matrixBufferDesc.ByteWidth = sizeof(MaterialBuffer);
	matrixBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	matrixBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	matrixBufferDesc.MiscFlags = 0;
	matrixBufferDesc.StructureByteStride = 0;
	ASSERT(hr = m_dxdevice->CreateBuffer(&matrixBufferDesc, nullptr, &material_buffer));
}

void Model::UpdateMaterialBuffer(const Material& material, float Shininess) const
{
	// Map the resource buffer, obtain a pointer and then write our matrices to it
	D3D11_MAPPED_SUBRESOURCE resource;
	m_dxdevice_context->Map(material_buffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &resource);
	MaterialBuffer* matrixBuffer = (MaterialBuffer*)resource.pData;
	matrixBuffer->AmbientColour = vec4f(material.AmbientColour, Shininess);
	matrixBuffer->DiffuseColour = vec4f(material.DiffuseColour, Shininess);
	matrixBuffer->SpecularColour = vec4f(material.SpecularColour, Shininess);
	m_dxdevice_context->Unmap(material_buffer, 0);
}

void Model::Compute_TB(Vertex& v0, Vertex& v1, Vertex& v2)
{
	vec3f tangent, binormal;

	//lengyel
	// 3D vectors
	vec3f D = v1.Position - v0.Position;
	vec3f E = v2.Position - v0.Position;

	// 2D vectors
	vec2f F = v1.TexCoord - v0.TexCoord;
	vec2f G = v2.TexCoord - v0.TexCoord;

	float det = 1 / ((F.x * G.y) - (F.y * G.x));

	tangent.x = det * (G.y * D.x + -F.y * E.x);
	tangent.y = det * (G.y * D.y + -F.y * E.y);
	tangent.z = det * (G.y * D.z + -F.y * E.z);

	binormal.x = det * (-G.x * D.x + F.x * E.x);
	binormal.y = det * (-G.x * D.y + F.x * E.y);
	binormal.z = det * (-G.x * D.z + F.x * E.z);

	v0.Tangent = v1.Tangent = v2.Tangent = tangent;
	v0.Binormal = v1.Binormal = v2.Binormal = binormal;
}