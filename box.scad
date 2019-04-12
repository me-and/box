inner_dimensions = [120, 60, 40];

wall_thickness = 3;
edge_roundness = 6;
bevel = 0.4;

tolerance = 0.15;

separation = wall_thickness;

img = "img.dxf";
img_depth = 1;
img_border = 5;

$fn = 90;

// Check assumptions
assert(bevel >= 0);
assert(bevel <= 1);
assert(wall_thickness < edge_roundness);

box_with_slider(inner_dimensions, wall_thickness, edge_roundness, bevel);

translate([0, inner_dimensions[1] + 2*wall_thickness + separation, 0])
lid_with_image([inner_dimensions[0] - 2*tolerance,
		inner_dimensions[1] - 2*tolerance,
		wall_thickness],
	       edge_roundness, wall_thickness, bevel,
	       img, img_depth, img_border);

module lid_with_image(dimensions, edge_roundness, wall_thickness, bevel,
		      img, img_depth, img_border)
{
	img_size = min(dimensions[0], dimensions[1]) - img_border*2;

	difference () {
		lid(dimensions, edge_roundness, wall_thickness, bevel);

		translate([dimensions[0]/2 + wall_thickness - img_size/2,
			   dimensions[1]/2 + wall_thickness - img_size/2,
			   wall_thickness])
		image(img, img_depth, img_size);
	}
}

module image(img, img_depth, img_size)
{
	// Will be centred in the z-axis, and in the positive x,y quadrant.
	resize([img_size, img_size, img_depth * 2])
	linear_extrude(1, center=true)
	import(img);
}

module lid(dimensions, edge_roundness, wall_thickness, bevel)
{
	corner_r1 = edge_roundness - wall_thickness + bevel*wall_thickness;
	corner_r2 = edge_roundness - wall_thickness;

	near_x_point = edge_roundness;
	near_y_point = edge_roundness;
	far_x_point = dimensions[0] - edge_roundness + 2*wall_thickness;
	far_y_point = dimensions[1] - edge_roundness + 2*wall_thickness;

	hull() {
		translate([near_x_point, near_y_point, 0])
		cylinder(dimensions[2], corner_r1, corner_r2);

		translate([near_x_point, far_y_point, 0])
		cylinder(dimensions[2], corner_r1, corner_r2);

		translate([far_x_point, near_y_point, 0])
		cylinder(dimensions[2], corner_r1, corner_r2);

		translate([far_x_point, far_y_point, 0])
		cylinder(dimensions[2], corner_r1, corner_r2);
	}
}

module box_with_slider(inner_dimensions, wall_thickness, edge_roundness, bevel)
{
	difference() {
		box(inner_dimensions, wall_thickness, edge_roundness);

		// Create an extra-long lid to create the main runners for the
		// slider.
		translate([0, 0, wall_thickness + inner_dimensions[2]])
		lid([inner_dimensions[0] + 2*wall_thickness,
		     inner_dimensions[1],
		     wall_thickness],
		    edge_roundness, wall_thickness, bevel);

		// To avoid an odd curve, also remove a box at the end of the
		// slide.
		translate([inner_dimensions[0] + wall_thickness, 0,
			   inner_dimensions[2] + wall_thickness])
		cube([wall_thickness*2,
		      inner_dimensions[1] + 2*wall_thickness,
		      wall_thickness*2]);
	}
}

module box(inner_dimensions, wall_thickness, edge_roundness)
{
	outer_dimensions = [inner_dimensions[0] + 2*wall_thickness,
			    inner_dimensions[1] + 2*wall_thickness,
			    inner_dimensions[2] + 2*wall_thickness];

	difference() {
		rounded_cube(outer_dimensions, edge_roundness);

		translate([wall_thickness, wall_thickness, wall_thickness])
		rounded_cube([inner_dimensions[0],
			      inner_dimensions[1],
			      inner_dimensions[2] + 2*wall_thickness],
			     edge_roundness - wall_thickness);
	}
}

module rounded_cube(dimensions, edge_roundness) {
	near_x_point = edge_roundness;
	near_y_point = edge_roundness;

	far_x_point = dimensions[0] - edge_roundness;
	far_y_point = dimensions[1] - edge_roundness;

	hull() {
		translate([near_x_point, near_y_point, 0])
		cylinder(dimensions[2], r=edge_roundness);

		translate([near_x_point, far_y_point, 0])
		cylinder(dimensions[2], r=edge_roundness);

		translate([far_x_point, near_y_point, 0])
		cylinder(dimensions[2], r=edge_roundness);

		translate([far_x_point, far_y_point, 0])
		cylinder(dimensions[2], r=edge_roundness);
	}
}
