// 2023 05 17    UPSIDEDOWN!!!!
// 2023 05 29    refactor common stuff into library
//
// Assumes these files are present:
//   - backplate_nofeet.stl (3.5mm tall)
//   - cherryplate.stl (4.5mm tall)

use <crkbd.scad>

$fn=50;

BASE_THICKNESS = 3.5;    // per slicer, measured is as high as 3.9, sigh
MAG_H = 2.6;  // measured ht of magnets 

module ledge() {
    ANGLE = 10;
    HOLE_OFS = 16;

    
    difference() {

        // tilt it and have some holes
        translate([3,0.2,0]) rotate([ANGLE,0,0])
        {
            linear_extrude(3) square([16,34]);
            translate([4,0,0]) linear_extrude(5) square([12,34]);
            
            rotate([-90,0,0])
                linear_extrude(34)
                    polygon([ [0,0], [8,0], [0,8] ]);

        }
        
        // cut out the two holes to mount the lcd
        rotate([ANGLE,0,0]) {
            translate([HOLE_OFS,3,-10]) cylinder(r=1.5,h=50);
            translate([HOLE_OFS,3+28,-10]) cylinder(r=1.5,h=50);

            // recess for nut
            //translate([HOLE_OFS,3,-1]) cylinder(r=2.5,h=2,$fn=6);
            //translate([HOLE_OFS,3+28,-1]) cylinder(r=2.5,h=2,$fn=6);
        }
        
    } // difference
}

module base() {
    HT = 30;
    PCB_INSET = 6.2+2;
    PROMICRO_INSET = 8 + PCB_INSET;
    TENT = 4;
    TILT = 5;
    
    chop( t=[5,5,-HT+5.6], r=[TILT,-TENT,0] ) 
    {
        
        // support for large oled
        // this has to be within the chop block
        color("blue")
            translate([133,52.2,HT-6])
                ledge();

        // everything else
        difference() {
            union() {
                // this is the outermost border of the whole thing
                // make it 2mm wider than PCB
                linear_extrude(HT) offset(r=2) crkbd2d();
            }

            // cut out angle so there is room for the lcd
            // mounting plate
            translate([132,52.2,HT-6])
            translate([3,0.2,0]) rotate([10,0,0])
                linear_extrude(33) square([16,34]);
            
            // cut out for PCB, 2mm deep
            // needs a tiny bit of play, so add small offset 
            // took 0.3 from the lily case
            // was loose, trying .2
            translate([0,0,HT-PCB_INSET]) 
                linear_extrude(HT) offset(r=.2) crkbd2d();
            
            // promicro hole
            translate([115,47.2,HT-PROMICRO_INSET])
            linear_extrude(HT) square([20,40]);
            
            // TRRS cable
            translate([130,36.5,HT-5])
            linear_extrude(10) square([10,6]);
  
            linear_extrude(HT) offset(r=-5) crkbd2d();
            
            // usb hole
            translate([120,80,HT-9])
            rotate([-90,0,0])
            linear_extrude(12) square([12,10]);

            // cutout for large oled
            translate([130,52,HT-3])
                linear_extrude(10) square([15,18]);
      
        } // difference
        
        // standoffs
        color("red") translate([15,30.3,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);
        color("red") translate([1.5,52,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);
        color("red") translate([18,84.6,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);
        color("red") translate([76.5,89.5,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);

        color("red") translate([90,12.2,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);
        color("red") translate([113,86.5,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);
        color("red") translate([119.2,1.5,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);
        color("red") translate([133,45,0]) 
            linear_extrude(HT-PCB_INSET+2) square(3);

        // for screws
                
    } // chop   

}

// holder for the 1.3mm LED
module led_plate_1_3() {
     
    difference() {
        union() {
            
            // base
            linear_extrude(1) square([36,34]);
            
            // setoffs bcs of stuff on back
            
            // left supports
            translate([0,6,1])
            linear_extrude(1) square([3,8]);
            translate([0,20,1])
            linear_extrude(1) square([3,8]);
            
            // right supports 
            translate([33,6,1])
            linear_extrude(1) square([3,8]);
            
            translate([33,20,1])
            linear_extrude(1) square([3,8]);
            
            // one for the bottom
            translate([11,0,1])
            linear_extrude(3) square([13,3]);

            // don't use lower screw hole
            translate([2.5,3,1]) cylinder(r=1.5,h=3);
          
            // raise it up a little
            // this is dumb because it requires supports
            // probably should move to the keeb tray once 
            // everything is dialed in
            //translate([24,0,-2]) 
            //linear_extrude(2)
            //square([12,34]);

        }
        
        // cutout for wires
        translate([12,29,0])
        linear_extrude(10) square([12,5]);
        
        // screw holes
        translate([2.5,3+28,-1]) cylinder(r=1.5,h=50);
//            translate([2.5,3,-1]) cylinder(r=1.5,h=50);
        translate([2.5+30.5,3,-3]) cylinder(r=1.5,h=50);
        translate([2.5+30.5,3+28,-3]) cylinder(r=1.5,h=50);

    }
    
    
}
 
module useless() {
    translate([-100,0,0]) {
        difference() {
            linear_extrude(2) square([12,34]);
            translate([2.5,3+28,-1]) cylinder(r=1.5,h=50);
            translate([2.5,3,-1]) cylinder(r=1.5,h=50);
        }
    }
}

module clamp1() 
{
    D1 = 19;
    R  = 3.5;
    
    difference() 
    {
        union()
        {
            translate([-R,-R,0])
                linear_extrude(1) square([7,D1+2*R]);
            translate([0,0,1]) cylinder(r=R, h=2);
            translate([0,D1,1]) cylinder(r=R, h=2);
        }
        
        cylinder(r=1.2, h=10);
        translate([0,D1,0]) cylinder(r=1.2, h=10);

    } 
    
}


//base();
//translate([-50,0,0]) led_plate_1_3();
//useless();
//ledge();
clamp1();