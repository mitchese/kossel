include <configuration.scad>;

mount_radius = 7.9;   // Radius from brushless motor mount screws
screw_hole_radius = 2;// hole size for mount screws
flange_radius = 5;    // Radius of bearing flange (5mm)
flange_height = 1.5;  // Height of bearing flange (1.5mm)
bearing_radius = 4;   // Radius of bearing (below flange)

height = 7;           // height of overall effector

// mounts from original kossel mini
separation = 40;  // Distance between ball joint mounting faces.
offset = 20;  // Same as DELTA_EFFECTOR_OFFSET in Marlin.
cone_r1 = 2.5;
cone_r2 = 14;

module effector() {
  difference() {
    union() {
      cylinder(r=offset-3, h=height, center=true, $fn=60);
      for (a = [60:120:359]) rotate([0, 0, a]) {
	rotate([0, 0, 30]) translate([offset-2, 0, 0])
	  cube([10, 13, height], center=true);
	for (s = [-1, 1]) scale([s, 1, 1]) {
	  translate([0, offset, 0]) difference() {
	    intersection() {
	      cube([separation, 40, height], center=true);
	      translate([0, -4, 0]) rotate([0, 90, 0])
		cylinder(r=10, h=separation, center=true);
	      translate([separation/2-7, 0, 0]) rotate([0, 90, 0])
		cylinder(r1=cone_r2, r2=cone_r1, h=14, center=true, $fn=24);
	    }
	    rotate([0, 90, 0])
	      cylinder(r=m3_radius, h=separation+1, center=true, $fn=12);
	    rotate([90, 0, 90])
	      cylinder(r=m3_nut_radius, h=separation-24, center=true, $fn=6);
	  }
        }
      }
    }
    // Start bearing hole in centre
    translate([0, 0, flange_height])
     cylinder(r=flange_radius, h=height, $fn=36);
    translate([0, 0, -6])
     cylinder(r=bearing_radius, h=2*height, $fn=36);
    // Start mounting holes
    translate([0, 0, -6]); 
    for (a = [0:90:269]) rotate([0, 0, a]) {
      translate([0, mount_radius, 0])
	cylinder(r=screw_hole_radius, h=2*height, center=true, $fn=12);
    }
  }
}

translate([0, 0, height/2]) effector();

