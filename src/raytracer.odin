package main

import "core:fmt"
import "core:log"
import "core:os"
import "core:time"


main :: proc() {
	log_file_handle, err := os.open("raytracer.log", os.O_RDWR | os.O_APPEND)
	fl := log.create_file_logger(
		log_file_handle,
		log.Level.Info,
		{log.Option.Level, log.Option.Long_File_Path, log.Option.Line},
		"raytracer",
	)
	cl := log.create_console_logger(
		log.Level.Info,
		{
			log.Option.Level,
			log.Option.Short_File_Path,
			log.Option.Line,
			log.Option.Procedure,
			log.Option.Terminal_Color,
		},
		"raytracer",
	)
	ml := log.create_multi_logger(fl, cl)
	context.logger = ml

	render_image()
}

render_image :: proc() {
	start_time := time.now()
	image_file, err := os.open("render.ppm", os.O_RDWR)
	if err != os.ERROR_NONE {
		// handle error
		fmt.println(err)
		os.exit(1)
	}
	defer os.close(image_file)

	image_width := 500
	aspect_ratio: f32 = 16.0 / 9.0
	image_height: int = auto_cast (cast(f32)image_width / aspect_ratio)
	image_height = (image_height < 1) ? 1 : image_height
	log.infof(
		"image width: %v, image height: %v, aspect_ratio: %v",
		image_width,
		image_height,
		aspect_ratio,
	)

	focal_length: f32 = 1.0
	viewport_height: f32 = 2.0
	viewport_width: f32 = viewport_height * auto_cast (image_width / image_height)

	camera_center := vec3{0, 0, 0}
	viewport_u := vec3{viewport_width, 0, 0}
	viewport_v := vec3{0, -viewport_height, 0}

	pixel_delta_u := viewport_u / cast(f32)image_width
	pixel_delta_v := viewport_v / cast(f32)image_height

	viewport_upper_left :=
		camera_center - vec3{0, 0, focal_length} - viewport_v / 2 - viewport_u / 2
	origin_pixel := viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v)

	os.write_string(image_file, fmt.tprintln("P3"))
	os.write_string(image_file, fmt.tprintfln("%v %v", image_width, image_height))
	os.write_string(image_file, fmt.tprintln("255"))

	for i := 0; i < image_height; i += 1 {
		log.debugf("ScanLines remaining: %v", image_height - i)
		for j in 0 ..< image_width {
			pixel_center :=
				origin_pixel + (pixel_delta_v * cast(f32)i) + (pixel_delta_u * cast(f32)j)
			ray_direction := pixel_center - camera_center
			r := ray{camera_center, ray_direction}
			c := ray_color(r)
			os.write_string(image_file, print_color(c))
		}
	}
	log.infof("Time elapsed: %v", time.since(start_time))
}
