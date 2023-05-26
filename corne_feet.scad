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
// Assumes these files are present:
//   - backplate_nofeet.stl (3.5mm tall)
//   - cherryplate.stl (4.5mm tall)


$fn=50;

BASE_THICKNESS = 3.5;    // per slicer, measured is as high as 3.9, sigh
TOP_THICKNESS  = 4.5;    // ht of top plate
MAG_H = 2.6;  // measured ht of magnets 

// sine wave used to make the feet look nicer
function sinewave(radius,length,waves) = [
            [0,0], 
            for (phi = [1 : 6 : 360*waves]) 
                [length*phi/(360*waves), radius + radius * sin(phi)],
            [length,0]
                
    ];

// grid of hexagons to subtract from things
module hex_grid(ht) {
    CR = 10;
    D = 3;
    translate([150,0,0]) rotate([0,0,90])
    for (y=[0:8] ) {
        for (x=[0:7] ) {
            translate([x*(2*CR+D) + (y%2)*(CR+D/2), y*(2*CR)*.9,0])
            color("blue") rotate([0,0,30]) cylinder(r=CR, h=ht, $fn=6);
        }
    }
}

// a helper that rotates and translates, then chops off 
// everything below z=0
//
module chop(t=[0,0,0],r=[0,0,0])
{
    HT = 100;
    difference() {
        translate(t)
        rotate(r)

        children();
        color("red") translate([-50,-50,-HT]) linear_extrude(HT) square(500);
    }
}

// these are where the screws are on CRKBD
// you can subtract this from a volume to get countersunk
// holes for the screws
//
// it is oriented the same was as k3d and k2d
//
// most of the cylinder is countersunk because it is 
// expected that the screws will always be small (around
// 4mm) but the countersink depth will vary depending on
// what they are in
//
//   R  = inner diameter
//   R2 = outer diameter
module screw_holes(R=1.3, R2=3, HT=25) {
    OFS = BASE_THICKNESS-1.5;
    HOLES = [ [20.4,49.4], [20.5,68.6], [96.5,72.1], 
              [63.7,32.4], [110.2,24.5]
    ];
    
    for (h=HOLES) {
        translate([h[0],h[1],0]) {
            color("blue") cylinder(r=R, h=HT);
            color("green") cylinder(r=R2, h=HT-OFS);
        }
    }
}    

// four holes for magnets
// subtract out as necessary
module magnets() {
    MAG_R = 4.2;  // 4.05 was a a little too tight
    SMALL_R = 1.5;
    BIG = 50;
    MAGNETS = [[127,36,0], [127,76,0], [10,75,0], [10,42,0]];
    
    // each magnet hole has a hole for the magnet and
    // a thinner hole to facilitate getting the magnet
    // out if the hole is a tight fit
    for(m=MAGNETS)
        translate(m) {
            translate([0,0,MAG_H-BIG]) cylinder(r=MAG_R,h=BIG);
            cylinder(r=SMALL_R, h=BIG);
        }
}

module top_plate() {
    difference() {

        union() {
        translate([4,2,4.5]) rotate([0,180,0])
            translate([0, 31, 0 ]) 
                mirror([0,1,0])
                    import("cherryplate.stl");
            screw_holes(HT=4.5, R=2.6, R2=2.6);
        }
        
        // widen the screw holes
        // but don't inset them, it isn't necessary and it
        // complicates the printing
        translate([0,0,5]) 
            mirror([0,0,1]) 
                screw_holes(HT=5,R=1.3, R2=1.3);        
        
        // makes sure there is nothing below zero
        translate([0,0,-5]) linear_extrude(5) square(200);
            
    } // diff
        
    //screw_holes(HT=BASE_THICKNESS);
}

// this just imports the bottom plate and positions it
// the bottom plate has screw holes that are a little tooes
// small and that are countersunk wrong for the type of 
// screws I have, so I ended up redoing the holes 
//
// you can use this by itself as a bottom plate
//
// this is about 3.9mm thick
//
module crkbd3d() {
      
    difference() {

        translate([2,0,3.5]) rotate([0,180,0])
            translate([0, 31, 0 ]) 
                mirror([0,1,0])
                    import("backplate_nofeet.stl");
        
        // widen the screw holes
        screw_holes(HT=BASE_THICKNESS);
            
    } // diff
}

// 2d projection of the botom plate
// there are no screw holes
module crkbd2d() {
    projection() {
        crkbd3d();
       screw_holes(); 
    }
}

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
module base_plate(ht=3,tent=0,tilt=0,MAGNETS=true,ZOFS=0) {
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
module flat_magnets(ht=3,tent=0,tilt=0) {
    BIG=40;
    
    chop(r=[tilt, -tent, 0], t=[0,0,ht-BIG])
    {                
        // make a giant k2d shaped block w holes
        difference() {
            linear_extrude(BIG) crkbd2d();
            translate([0,0,BIG]) mirror([0,0,1]) magnets();
            translate([18,0,0]) linear_extrude(BIG+1) square([100,200]);
        }
        
        // add crossbar
        translate([18,50,0]) linear_extrude(BIG) square([100,20]);
    } // chop
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
//flat_magnets(-1,5,5);      // base plate with tilt and tent
                             // this is my preferred option

// This is a base plate with built in tent and tilt. 
// It does not require magnets and a separate base, so
// it can be thinner. but it is less adjustable. 
//
base_plate(); // flat base plate with magnets
//base_plate(3.5,5,5,false,-4); // tented,tilted plate w/o mags

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



