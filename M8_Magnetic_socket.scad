// ToolDown will sink down into the pocket, but does not provide a hanger for automatic tool changes
// ToolUp will come with a changeable hook
// The mounting flange is 3mm thick, 25mm wide
// the hole is then 
flange_radius = 25;     // Radius of bearing flange (5mm)
hole_radius = 20;    // Radius of bearing (below flange)
height = 18;            // height of overall effector
magnet_radius = 3;
magnet_height = 12; // actually bought 6mmx10mm magnets
magnet_count = 8;
extra_radius = 0.1;


module ToolDown()
{
        // outer flange
        translate([0, 0, 0])
        cylinder(r1=flange_radius-1, r2=flange_radius-2, h=4, $fn=72);
        // main cylinder
        translate([0, 0, 0])
        cylinder(r1=hole_radius-1, r2=hole_radius-3, h=height, $fn=72);
        // magnet pockets
        for (a = [0, 30, 60, 90, 135, 180, 225, 270, 310]) rotate([0, 0, a])
        {
            translate([0, hole_radius+magnet_radius+1, 1])
            #cylinder(r=magnet_radius+extra_radius, h=magnet_height, center=false, $fn=12);
        }
}

module ToolUp()
{
        // outer flange
        translate([0, 0, 0])
        cylinder(r1=flange_radius-1, r2=flange_radius-2, h=4, $fn=72);
        // Arm to go up
        translate([-13, 6, 0]) rotate([0,0,45])
        #cube([8,8,40], center=false);
        translate([-10,6,40]) rotate([0,90,135])
        cylinder(r=15, h=8, $fn=3);
        // magnet pockets
        for (a = [0, 30, 60, 90, 135, 180, 225, 270, 310]) rotate([0, 0, a])
        {
            translate([0, hole_radius+magnet_radius+1, 1])
            #cylinder(r=magnet_radius+extra_radius, h=magnet_height, center=false, $fn=12);
        }
}
ToolUp();