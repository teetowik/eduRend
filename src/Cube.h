#pragma once
#ifndef CUBE_H
#define CUBE_H

#include "model.h"
#include "vec/vec.h"
#include "drawcall.h"

class Cube : public Model
{
	unsigned m_number_of_indices = 0;

	Material material;

public:

	Cube(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context);

	virtual void Render() const;

	~Cube() { }
};



#endif