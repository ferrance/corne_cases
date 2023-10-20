use <../crkbd.scad>

H=62; // should be 60

module box() 
{
    difference() {
        // original offsets were 2 and .8 - too loose
        // 1.8 and .2 - too tight
        linear_extrude(H+1) offset(r=1.8) crkbd2d();
        translate([0,0,1]) linear_extrude(H+1) offset(r=.4) crkbd2d();

        // cutout for cable
        translate([130,33,13]) color("red") cube([10,10,H]);
        
        // cutout for usb
        translate([119,80,13]) color("red") cube([15,15,H]);
        
        // finger holes
        translate([20,55,-1]) cylinder(r=12,h=H, $fn=6);
        translate([67.5,55,-1]) cylinder(r=12,h=H, $fn=6);
        translate([115,55,-1]) cylinder(r=12,h=H, $fn=6);
    }
}

module cover() 
{
    difference() {
        linear_extrude(11) offset(r=3.2) crkbd2d();
        translate([0,0,1]) linear_extrude(H+1) offset(r=2.2) crkbd2d();
    }
}


//box();
translate([0,-110,0]) mirror([0,0,1]) cover();

