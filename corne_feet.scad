// 2022 12 10    original design
// 2023 01 01    clean up terrible code, now it is just really bad
//               add one piece backplate and feet
//               made the ledge a little taller
// 2023 01 08    adding holes to allow magnets to be removed
//               more easily. Widen screw holes and inset them
//               got rid of the two middle magnets
// 2023 03 22    refactor everything, make a base plate with tent/tilt w/o magnets
//
// 2023 05 26    cleaning up the code
//
// 2023 09 05    adding round_magnets()
//
// 2023 12 02    added holes for underglow, refactoring
//
// Assumes these files are present:
//   - backplate_nofeet.stl (3.5mm tall)
//   - cherryplate.stl (4.5mm tall)

use <crkbd.scad>

$fn=10;

BASE_THICKNESS = 3.5;    // per slicer, measured is as high as 3.9, sigh
TOP_THICKNESS  = 4.5;    // ht of top plate
MAG_H = 2.6;  // measured ht of magnets 

// the top, with a border to snap into the bottom plate
// draws a 3.5mm high, 2mm wide border
// then subpracts a 1.5mm baseplate
// then rotates it all ANGLE DEGREES
// note that you can't put a 2.5mm magnet here because there's
// only 1mm of top to pet it in
//
// currently only called by wedge
//
module top() {
    ANGLE = 5;
    rotate([0,-ANGLE,0])
        difference() {
            linear_extrude(3.5) offset(r=2) k2d();
            translate([0,0,1]) linear_extrude(10) k2d();
        }
}

module wedge(magnets=false) {
    ANGLE = 5;
    difference() {
      union() {    
        // make a base that matches the projection of the top
        difference() {
          linear_extrude(20) projection() top();
          rotate([0,-ANGLE,0]) 
            translate([-10,0,0]) linear_extrude(30) square(200);
        }
      
        // now add the top
        top();
      } //union
      
      if (magnets) {
        rotate([0,-ANGLE,0]) translate([0,0,-1.59]) magnets();
      }
  } // difference

}

// these are the feet that attach to the insidbe magnets
// to provide some tenting
// 
// this was my original idea for tenting and portability. it
// still works but I prefer the full base with the built in magnets now
//
module corne_feet(magnets=false) {
    difference() {
        wedge(magnets);
        
        linear_extrude(20) translate([114,150,-0.01]) 
          rotate([0,0,-90]) polygon(sinewave(3,150,5));
        translate([0.01,0,-1]) linear_extrude(20) square([114,200]);
        translate([-2,0,0]) linear_extrude(20) square([10,200]);

    } 
}

// bottom plate with buit in tenting
module one_piece() {
    //corne_feet();
    rotate([0,-5, 0]) crkbd3d();
    color("red") 1piece_wedge();
}    


// this is the base plate with optional integral tent/tilt
//
// ht = ht/thickness of base plate. prob shld always be 3.5 
// tent = tent angle
// tilt = tilt angle
// magnets = true for magnet holes, false for no magnet holes
// ZOFS = move up or down before chopping. use to adjust final ht
//
// Make a big chunk shaped like a base plate
// rotate it by the tent and tilt
// allow height adjustment
// then chop off everything below z=0
//
module base_plate(ht=3,tent=0,tilt=0,MAGNETS=true,ZOFS=0,UNDERGLOW=true) {
    BIG = 40;
    
    chop(t=[0,0,ht-BIG+ZOFS], r=[tilt, -tent, 0] )
    { 
        // giant k2d with holes
        difference() {        
            linear_extrude(BIG) crkbd2d();
            if (MAGNETS) {
                translate([0,0,BIG-ht]) magnets();
            }
            screw_holes(HT=BIG);
            
            if (UNDERGLOW) 
                underglow();
            
            // remove material for aesthetics and maybe print time
            if (true) {
                translate([-18,5,0]) hex_grid(BIG-ht);
            }
        }
    }  // chop    
}

// this creates a magnetic attachment that can attach to
// the bottom of a base plate. It can have varying degrees
// of tent and tilt.
//
// This is useful if you travel with the keeb because it allows
// you to remove the angled part and have a flat (easy to carry)
// keeb
//
// if you don't travel, you could just create a one piece angled base 
// plate
//
// ht = thickness of plate if plate is flat. if not flat, then play
//      with this parameter to get the height you want.
//
module flat_magnets(ht=3,tent=0,tilt=0, SCREWS=true) {
    BIG=100;
    
    chop(r=[tilt, -tent, 0], t=[0,0,ht-BIG])
    {                
        // make a giant k2d shaped block w holes
        difference() {
            linear_extrude(BIG) crkbd2d(SCREWS=SCREWS);
            translate([0,0,BIG]) mirror([0,0,1]) magnets(SCREWS=SCREWS);
            translate([18,0,0]) linear_extrude(BIG+1) square([100,200]);
        }
        
        // add crossbar
        translate([18,50,0]) linear_extrude(BIG) square([100,20]);
    } // chop
}

module round_magnets(ht=3,tent=0,tilt=0) {
//    ANGLE = 20; OFS = .2;
    ANGLE = 25; OFS = 1;
//    ANGLE = 30; OFS = 1;

    rotate([90,0,0]) {
    
        difference() {
            rotate_extrude(angle=ANGLE, $fn=300)
                projection()
                    flat_magnets(SCREWS=false);
            rotate_extrude(angle=ANGLE - 1, $fn=300)
                translate([18,50,0]) square([100,20]);    
        }
        
        // put the top on it
        translate([0,0,8.61])
        rotate([90,0,ANGLE])    
            mirror([0,0,1])
                color("blue") flat_magnets(OFS,0,5,SCREWS=false);

    }

}

//uncomment one of these:

// These are feet that go on the inside to create tent.
// Right now they create no tilt.
//corne_feet(magnets=true);  // magnets=false for no magnets

// This base attaches magnetically to the base plate.
// It has no snap in borders. Can be configured with
// different tent and tilt. It is not a great travel 
// option but it is what I use on my desktop.

//flat_magnets();            // flat magnet base 3mm tall
//flat_magnets(-0.4,5,5);      // base plate with tilt and tent
//flat_magnets(-0.4,3,5);      // base plate with tilt and tent
                             // this is my preferred option

//flat_magnets(2,15,5);

// This is a base plate with built in tent and tilt. 
// It does not require magnets and a separate base, so
// it can be thinner. but it is less adjustable. 
//
//base_plate(); // flat base plate with magnets
//base_plate(3.5,5,5,false,-4); // tented,tilted plate w/o mags
base_plate(UNDERGLOW=true);


// The top plate for cherry mx switches
// The only thing this changes from the original is to
// counterbore instead of countersinking the screws, since
// I found it hard to keep the standoffs at right angles to 
// the plate with the original design.
//
//top_plate();



// for testing:
//crkbd3d();
//crkbd2d();
//translate([0,0,BASE_THICKNESS]) mirror([0,0,1]) screw_holes(HT=BASE_THICKNESS);
//magnets();
//mirror([0,0,1]) magnets();
//hex_grid(45);



//round_magnets(2,15,5);
