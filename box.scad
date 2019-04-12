inner_dimensions = [120, 60, 40];

wall_thickness = 3;
edge_roundness = 6;
bevel = 0.4;

tolerance = 0.15;

img = "img.dxf";
img_depth = 1;
img_border = 5;

$fn = 90;

difference() {
    box(inner_dimensions, wall_thickness, edge_roundness);

    translate([0, 0, wall_thickness + inner_dimensions[2]])
    lid([inner_dimensions[0]*2, inner_dimensions[1], wall_thickness], edge_roundness, wall_thickness, bevel);

    translate([inner_dimensions[0] + wall_thickness, 0, inner_dimensions[2] + wall_thickness])
    cube([wall_thickness*2, inner_dimensions[1] + 2*wall_thickness, wall_thickness*2]);
}

translate([0, inner_dimensions[1] + 3*wall_thickness, 0])
lid_with_image([inner_dimensions[0] - 2*tolerance, inner_dimensions[1] - 2*tolerance, wall_thickness], edge_roundness, wall_thickness, bevel, img, img_depth, img_border);

module lid_with_image(dimensions, edge_roundness, wall_thickness, bevel, img, img_depth, img_border)
{
    img_size = min(dimensions[0], dimensions[1]) - img_border*2;

    difference () {
        lid(dimensions, edge_roundness, wall_thickness, bevel);

        translate([dimensions[0]/2 + wall_thickness, dimensions[1]/2 + wall_thickness, wall_thickness])
        translate([-img_size/2, -img_size/2, 0])
        resize([img_size, img_size, img_depth * 2])
        linear_extrude(1, center=true)
        import(img, center=true);
    }
}

module lid(dimensions, edge_roundness, wall_thickness, bevel) {
    hull() {
        translate([edge_roundness, edge_roundness, 0])
        cylinder(dimensions[2], edge_roundness - wall_thickness + bevel*wall_thickness, edge_roundness - wall_thickness);

        translate([dimensions[0] - edge_roundness + 2*wall_thickness, edge_roundness, 0])
        cylinder(dimensions[2], edge_roundness - wall_thickness + bevel*wall_thickness, edge_roundness - wall_thickness);

        translate([edge_roundness, dimensions[1] - edge_roundness + 2*wall_thickness, 0])
        cylinder(dimensions[2], edge_roundness - wall_thickness + bevel*wall_thickness, edge_roundness - wall_thickness);

        translate([dimensions[0] - edge_roundness + 2*wall_thickness, dimensions[1] - edge_roundness + 2*wall_thickness, 0])
        cylinder(dimensions[2], edge_roundness - wall_thickness + bevel*wall_thickness, edge_roundness - wall_thickness);
    }
}

module box(inner_dimensions, wall_thickness, edge_roundness) {
    outer_dimensions = [inner_dimensions[0] + 2*wall_thickness, inner_dimensions[1] + 2*wall_thickness, inner_dimensions[2] + 2*wall_thickness];

    difference() {
        rounded_cube(outer_dimensions, edge_roundness);

        translate([wall_thickness, wall_thickness, wall_thickness])
        rounded_cube([inner_dimensions[0], inner_dimensions[1], inner_dimensions[2]+2*wall_thickness], edge_roundness - wall_thickness);
    }
}

module rounded_cube(dimensions, edge_roundness) {
    hull() {
        translate([edge_roundness, edge_roundness, 0])
        cylinder(dimensions[2], r=edge_roundness);

        translate([dimensions[0] - edge_roundness, edge_roundness, 0])
        cylinder(dimensions[2], r=edge_roundness);

        translate([edge_roundness, dimensions[1] - edge_roundness, 0])
        cylinder(dimensions[2], r=edge_roundness);

        translate([dimensions[0] - edge_roundness, dimensions[1] - edge_roundness, 0])
        cylinder(dimensions[2], r=edge_roundness);
    }
}
