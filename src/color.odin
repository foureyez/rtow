package main

import "core:fmt"

color :: [3]f32

print_color :: proc(c: color) -> string {
	r := int(255.999 * c.r)
	g := int(255.999 * c.g)
	b := int(255.999 * c.b)
	return fmt.tprintfln("%v %v %v", r, g, b)
}
