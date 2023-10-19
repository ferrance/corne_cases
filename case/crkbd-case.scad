use <../crkbd.scad>

H=62; // should be 60

difference() {
    // original offsets were 2 and .8
    linear_extrude(H+1) offset(r=1.8) crkbd2d();
    translate([0,0,1]) linear_extrude(H) offset(r=.2) crkbd2d();

    // cutout for cable
    translate([130,33,13]) color("red") cube([10,10,H]);
    
    // cutout for usb
    translate([119,80,13]) color("red") cube([15,15,H]);
    
}


