//include <configuration.scad>;
// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.3;
// OD = outside diameter, corner to corner.
m3_nut_od = 6.1;
m3_nut_radius = m3_nut_od/2 + 0.2 + extra_radius;
m3_washer_radius = 3.5 + extra_radius;

// Major diameter of metric 3mm thread.
m3_major = 2.85;
m3_radius = m3_major/2 + extra_radius;
m3_wide_radius = m3_major/2 + extra_radius + 0.2;

// OD = outside diameter, corner to corner.
m8_nut_od = 14.5;
m8_nut_radius = m8_nut_od/2 + 0.2 + extra_radius;
m8_washer_radius = 8.5 + extra_radius;

// Major diameter of metric 3mm thread.
m8_major = 7.85;
m8_radius = m8_major/2 + extra_radius;
m8_wide_radius = m8_major/2 + extra_radius + 0.2;

separation = 60;
thickness = 6;

horn_thickness = 26;
horn_x = 8;

belt_width = 5;
belt_x = 5.6;
belt_z = 7;

module carriage() {
  // Timing belt (up and down).
  translate([-belt_x, 0, belt_z + belt_width/2]) %
    cube([1.7, 100, belt_width], center=true);
  translate([belt_x, 0, belt_z + belt_width/2]) %
    cube([1.7, 100, belt_width], center=true);
  difference() {
    union() {
      // Main body.
      translate([0, 0, thickness/2])
        cube([27, 47, thickness], center=true);
      // Ball joint mount horns.
      for (x = [-1, 1]) {
        scale([x, 1, 1]) intersection() {
          translate([10, 0, (horn_thickness/2)])
            cube([separation, 46.4, horn_thickness], center=true);
          translate([horn_x, 0, (horn_thickness/2)]) rotate([0, 90, 0])
            cylinder(r1=20, r2=5.5, h=separation/2-horn_x);
        }
      }

      for (x = [-10, 10]) {
      for (y = [-10, 10]) {
        translate([x, y, thickness]) {
          //% cylinder(r=m3_wide_radius, h=50, center=true, $fn=12);
          cylinder(r=m3_washer_radius, h=horn_thickness-thickness, center=false, $fn=12);
          }
      }
    }


      // Belt clamps.
      difference() {
        //union() {
        //  translate([6.5, -15, horn_thickness/2+1])
        //    cube([14, 10, horn_thickness-2], center=true);
        //  translate([10.75, 2.5, horn_thickness/2+1])
        //    cube([5.5, 16, horn_thickness-2], center=true);
        //}
        // Avoid touching diagonal push rods (carbon tube).
        //translate([20, -10, 12.5]) rotate([35, 35, 30])
        //  cube([40, 40, 20], center=true);
      }
      for (y = [-12, 12]) {
        translate([1.25, y, horn_thickness/2-5])
          cube([7, 8, horn_thickness-12], center=true);
      }
    }
    // Screws for linear slider.
    for (x = [-10, 10]) {
      for (y = [-10, 10]) {
        translate([x, y, thickness]) {
          cylinder(r=m3_wide_radius, h=50, center=true, $fn=12);
          //#cylinder(r=m3_washer_radius, h=horn_thickness-thickness+1, center=false, $fn=12);
          }
      }
    }
    // Screws for ball joints.
    translate([0, 0, horn_thickness/2]) rotate([0, 90, 0]) 
      cylinder(r=m8_wide_radius, h=80, center=true, $fn=12);
    // Lock nuts for ball joints.
    for (x = [-1, 1]) {
      scale([x, 1, 1]) intersection() {
        translate([horn_x, 0, horn_thickness/2]) rotate([90, 30, -90])
          cylinder(r1=m8_nut_radius, r2=m8_nut_radius+0.5, h=12,
                   center=true, $fn=6);
      }
    }
  }
}

carriage();
