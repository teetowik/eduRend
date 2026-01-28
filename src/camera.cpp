#include "Camera.h"


using namespace linalg;

void Camera::MoveTo(const vec3f& position) noexcept
{
	m_position = position;
}

void Camera::Move(const vec3f& direction) noexcept
{
	// full movement translation
	m_position += direction * m_rotation.get_3x3().inverse();


	//mat4f test = m_rotation.get_3x3().inverse();
	
	// full z,x movement translation y = always up/down
	/*
	m_position.z += direction.x * test.m13 + direction.z * test.m33;
	m_position.x += direction.x * test.m11 + direction.z * test.m31;
	m_position.y += direction.x * test.m12 + direction.y + direction.z * test.m32;
	*/

	// 2D z,x movement translation y = always up/down
	/*
	m_position.z += direction.x * test.m13 + direction.z * test.m33;
	m_position.x += direction.x * test.m11 + direction.z * test.m31;
	m_position.y += direction.y;
	*/
}


void Camera::Rotate(const float& yaw, float& pitch) noexcept
{
	if (pitch > PI / 2)
	{
		pitch = PI / 2;
	}
	else if (pitch < -PI / 2)
	{
		pitch = -PI / 2;
	}
	m_rotation = mat4f::rotation(0, yaw, pitch);
}


mat4f Camera::WorldToViewMatrix() const noexcept
{
	// Assuming a camera's position and rotation is defined by matrices T(p) and R,
	// the View-to-World transform is T(p)*R (for a first-person style camera).
	//
	// World-to-View then is the inverse of T(p)*R;
	//		inverse(T(p)*R) = inverse(R)*inverse(T(p)) = transpose(R)*T(-p)
	// Since now there is no rotation, this matrix is simply T(-p)

	return transpose(m_rotation) * mat4f::translation(-m_position);
}

mat4f Camera::ProjectionMatrix() const noexcept
{
	return mat4f::projection(m_vertical_fov, m_aspect_ratio, m_near_plane, m_far_plane);
}

vec4f Camera::GetCamPos() noexcept
{
	return vec4f(m_position.x, m_position.y, m_position.z, 0); // 0 is padding?
}