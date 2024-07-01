package main

import "core:math"

vec3 :: [3]f32
point :: [3]f32

vec_unit :: proc(v: vec3) -> vec3 {
	return v / vec_mag(v)
}

vec_mag :: proc(v: vec3) -> f32 {
	return math.sqrt_f32(v.x * v.x + v.y * v.y + v.z * v.z)
}
