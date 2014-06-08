
// The mounting flange is 3mm thick, 25mm wide
// the hole is then 



mount_radius_2 = 7.9;  // Radius from brushless motor mount screws
mount_radius_1 = 9.5;  // radius for single mount screw
screw_hole_radius = 2; // hole size for mount screws
flange_radius = 25;     // Radius of bearing flange (5mm)
flange_height = 6;   // Height of bearing flange (1.5mm)
bearing_radius = 20;    // Radius of bearing (below flange)
height = 18;            // height of overall effector

magnet_radius = 3;
magnet_height = 12; // actually bought 6mmx10mm magnets

magnet_count = 8;
// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.3;

// OD = outside diameter, corner to corner.
m8_nut_od = 14.5;
m8_nut_radius = m8_nut_od/2 + 0.2 + extra_radius;
m8_washer_radius = 8.5 + extra_radius;

// Major diameter of metric 3mm thread.
m8_major = 7.85;
m8_radius = m8_major/2 + extra_radius;
m8_wide_radius = m8_major/2 + extra_radius + 0.2;

// mounts from original kossel mini
separation = 60;  // Distance between ball joint mounting faces.
offset = 40;      // distance from the center of the ball joint

// Same as DELTA_EFFECTOR_OFFSET in Marlin.
cone_r1 = 5.5;  // was 7.5 controls the ball joint rounding
cone_r2 = 14;   // was 16 controls the ball joint rounding 

module effector()
{
    difference()
    {
        union()
        {
            cylinder(r=offset-8, h=height, center=true, $fn=60);
            for (a = [60:120:359]) rotate([0, 0, a])
            {
                rotate([0, 0, 30]) translate([offset-10, 0, 0])
                // cubes between the ball joints extending from center
                cube([12, 39, height], center=true);
                for (s = [-1, 1]) scale([s, 1, 1])
                {
                    translate([0, offset, 0]) difference()
                    {
                        intersection()
                        {
                            // uh...sticks out to accept ball joints, is cut by light rounding
                            cube([separation+5, 50, height], center=true);
                            translate([0, 0, 0]) rotate([0, 90, 0])
                            //Light rounding on the very edges of the effector
                            cylinder(r=15, h=separation, center=true);
                            translate([separation/2-7, 0, 0]) rotate([0, 90, 0])
                            //rounding on the ball joint faces
                            cylinder(r1=cone_r2, r2=cone_r1, h=19, center=true, $fn=24);
                        }
                        rotate([0, 90, 0])
                        // Holes for ball joints
                        cylinder(r=m8_radius, h=separation+1, center=true, $fn=12);
                        rotate([90, 0, 90])
                        // nut traps for ball joints
                        cylinder(r=m8_nut_radius, h=separation-26, center=true, $fn=6);
                    }
                }
            }
        }
        // Start bearing hole in centre
        translate([0, 0, flange_height])
        cylinder(r=flange_radius, h=4, $fn=72);
        translate([0, 0, -height])
        cylinder(r=bearing_radius, h=2*height, $fn=72);
        // Start mounting holes
        //translate([0, 0, -6]);
        for (a = [0, 30, 60, 90, 135, 180, 225, 270, 310]) rotate([0, 0, a])
        {
            translate([0, bearing_radius+magnet_radius+1, flange_height-5])
            #cylinder(r=magnet_radius+extra_radius, h=magnet_height+5, center=true, $fn=12);
        }
        //rotate([0,0,90])
        //translate([0, mount_radius_1, 0])
        //cylinder(r=screw_hole_radius, h=2*height, center=true, $fn=12);
    }
}
translate([0, 0, height/2]) effector();