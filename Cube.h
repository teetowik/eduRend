#pragma once
#ifndef CUBE_H
#define CUBE_H

#include "src/model.h"
#include "src/vec/vec.h"
#include "src/drawcall.h"

class Cube : public Model
{
	unsigned m_number_of_indices = 0;

	//vec3f AmbientColour;
	//vec3f DiffuseColour;
	//vec3f SpecularColour;

public:

	Cube(ID3D11Device* dxdevice, ID3D11DeviceContext* dxdevice_context);

	virtual void Render() const;

	~Cube() { }
};



#endif