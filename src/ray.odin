package main

import "core:log"
ray :: struct {
	origin:    point,
	direction: vec3,
}


ray_color :: proc(ray: ray) -> color {
	unit_direction := vec_unit(ray.direction)
	// log.info(unit_direction)
	a := 0.5 * (unit_direction.y + 1.0)
	return (1.0 - a) * color{1.0, 1.0, 1.0} + a * color{0.5, 0.7, 1.0}
}
