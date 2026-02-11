#pragma once
#ifndef CUBE_H
#define CUBE_H

#include "model.h"

class Cube : public Model
{
	unsigned m_number_of_indices = 0;

	Material material;

public:

	Cube(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context);

	virtual void Render() const;

	~Cube() { SAFE_RELEASE(material.DiffuseTexture.TextureView) }
};



#endif