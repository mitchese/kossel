
include <tslot.scad>; // for tslots, do tslot2060(length)
use <nema17.scad>;


// THIS WAS CONFIGURATION.SCAD
// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.1;

// OD = outside diameter, corner to corner.
m3_nut_od = 6.1;
m3_nut_radius = m3_nut_od/2 + 0.2 + extra_radius;
m3_washer_radius = 3.5 + extra_radius;

// Major diameter of metric 3mm thread.
m3_major = 2.85;
m3_radius = m3_major/2 + extra_radius;
m3_wide_radius = m3_major/2 + extra_radius + 0.2;

m5_major = 4.85;
m5_radius = m5_major/2 + extra_radius;
m5_wide_radius = m5_major/2 + extra_radius + 0.2;

// NEMA17 stepper motors.
motor_shaft_diameter = 5;
motor_shaft_radius = motor_shaft_diameter/2 + extra_radius;

// Frame brackets. M3x8mm screws work best with 3.6 mm brackets.
thickness = 3.6;

// OpenBeam or Misumi. Currently only 15x15 mm, but there is a plan
// to make models more parametric and allow 20x20 mm in the future.
extrusion = 20;

// Placement for the NEMA17 stepper motors.
motor_offset = 44;
motor_length = 47;

//END CONFIGURATION.SCAD

// THIS WAS VERTEX.SCAD
//include <configuration.scad>;

$fn = 24;
roundness = 6;

module extrusion_cutout(h, extra) {
  difference() {
    cube([3*extrusion+extra, extrusion+extra, h], center=true);
    for (a = [0:180:359]) rotate([0, 0, a]) {
      translate([3*extrusion/2, 0, 0])
        cube([6, 4.5, h+1], center=true);
    }
    for (a = [90:180:359]) rotate([0, 0, a]) {
      for (b = [0, 20, -20]) {
        translate([extrusion/2, b, 0])
        cube([6, 4.5, h+1], center=true);
       }
    }
  }
}

module screw_socket() {
  cylinder(r=m3_wide_radius, h=20, center=true);
  translate([0, 0, 3.8]) cylinder(r=3.5, h=10);
}

module screw_socket_m5() {
  cylinder(r=m5_wide_radius, h=20, center=true);
  translate([0, 0, 5.8]) cylinder(r=5.5, h=10);
}

module screw_socket_cone() {
  union() {
    cylinder(r=m5_wide_radius, h=20, center=true);
    translate([0, 0, 10]) cylinder(r=5.5, h=100);
    scale([1, 1, -1]) cylinder(r1=4, r2=7, h=4);
  }
}

module vertex(height, idler_offset, idler_space) {
  union() {
    // Pads to improve print bed adhesion for slim ends.
    translate([-84.5, 81.2, -height/2]) cylinder(r=8, h=0.5);
    translate([84.5, 81.2, -height/2]) cylinder(r=8, h=0.5);
    difference() {
      union() {
// this is the rounded nose of it
        intersection() {
          translate([0, 72, 0])
            cylinder(r=80+extrusion, h=height, center=true, $fn=60);
          //translate([0, 22, 0])
          //  %cylinder(r=48+extrusion, h=height, center=true, $fn=60);
          translate([0, -57, 0]) rotate([0, 0, 30])
            cylinder(r=85, h=height+1, center=true, $fn=6);
        }
// this is the base triangle shape
        translate([0, 38, 0]) intersection() {
          rotate([0, 0, -90])
            cylinder(r=110, h=height, center=true, $fn=3);
          translate([0, 30, 0]) // 0 0 0
            cube([200, 165, 2*height], center=true); // 200,165,2*height
          translate([0, -10, 0]) rotate([0, 0, 30])
            cylinder(r=110, h=height+1, center=true, $fn=6);
        }
      }
// remove plastic for pulley, motor shaft, etc
      difference() {
        translate([0, 58, 0]) minkowski() {
          intersection() {
            rotate([0, 0, -90])
              cylinder(r=105, h=height, center=true, $fn=3);
            translate([0, -29, 0])
              cube([180, 16, 2*height], center=true);
          }
          cylinder(r=roundness, h=1, center=true);
        }
        // Idler support cones.
        translate([0, 26+idler_offset-30, 0]) rotate([-90, 0, 0])
          cylinder(r1=30, r2=2, h=30-idler_space/2);
        translate([0, 26+idler_offset+30, 0]) rotate([90, 0, 0])
          cylinder(r1=30, r2=2, h=30-idler_space/2);
      }
// remove plastic where motor is
      translate([0, 58, 0]) minkowski() {
        intersection() {
          rotate([0, 0, -90])
            cylinder(r=105, h=height, center=true, $fn=3);
          translate([0, 16, 0])
            cube([180, 40, 2*height], center=true);
        }
        cylinder(r=roundness, h=1, center=true);
      }
      extrusion_cutout(height+10, 2*extra_radius);
      for (z = [0:extrusion:height+1]) {
        for (x = [0, -20, 20]) {
            translate([x, -10-extra_radius, z+extrusion/2-height/2]) rotate([90, 0, 0])
            #screw_socket_cone();
        }


        for (a = [-1, 1]) {
          rotate([0, 0, 30*a]) translate([-((extrusion/2)+36)*a, 111, z+(extrusion/2)-height/2]) {
            // % rotate([90, 0, 0]) extrusion_cutout(200, 0);
            // Screw sockets.
            for (y = [-66, -22, -6]) {
              translate([a*(extrusion/2), y, 0]) rotate([0, a*90, 0]) screw_socket_m5();
            }
        
          }
        }
      }
    }
  }
}

//translate([0, 0, 7.5]) vertex(15, idler_offset=0, idler_space=10);
//END VERTEX


$fn = 24;

module frame_motor() {
  difference() {
    // No idler cones.
    vertex(3*extrusion, idler_offset=0, idler_space=100);
    // KOSSEL logotype.
    //translate([20.5, -11, 0]) rotate([90, -90, 30])
    //  scale([0.11, 0.11, 1]) import("logotype.stl");
    // Motor cable paths.
    //for (mirror = [-1, 1]) scale([mirror, 1, 1]) {
    //  translate([-35, 45, 0]) rotate([0, 0, -30])
    //    # cube([4, 15, 15], center=true);
    //      // -6 for 15mm extrusions, -8.5 for 20mm
    //  translate([-9, 0, 0]) cylinder(r=2.5, h=40);
    //      // -11 for 15mm extrusions, -14 for 20mm
    //  translate([-14, 0, 0]) # cube([15, 4, 15], center=true);
   // }
    translate([0, motor_offset, 0]) {
      // Motor shaft/pulley cutout.
      rotate([90, 0, 0]) cylinder(r=12, h=20, center=true, $fn=60);
      // NEMA 17 stepper motor mounting screws.
      for (x = [-1, 1]) for (z = [-1, 1]) {
        scale([x, 1, z]) translate([15.5, -5, 15.5]) {
          rotate([90, 0, 0]) cylinder(r=1.65, h=20, center=true, $fn=12);
          // Easier ball driver access.
          #rotate([74, -30, 0])  cylinder(r=1.8, h=80, $fn=12);
        }
      }
    }
    translate([0, motor_offset, 0]) rotate([90, 0, 0]) % nema17();
  }
}

rotate([0,0,90])
% tslot2060(100);
translate([0, 0, 22.5]) frame_motor();


for (a = [-1, 1]) {
          rotate([90, 0, 30*a]) translate([-((extrusion/2)+36)*a, 22.5, -574]) {
            // % rotate([90, 0, 0]) extrusion_cutout(200, 0);
            // Screw sockets.
%tslot2060(550);
           }
}
