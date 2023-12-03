// 2023 05 29    put shared functions in this library
//
// Assumes these files are present:
//   - backplate_nofeet.stl (3.5mm tall)
//   - cherryplate.stl (4.5mm tall)
//
// functions:
//
// sinewave
// hex_grid
// chop
//
// screw_holes
// magnets
// crkbd3d
// crkbd2d
//

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
        color("red") translate([-500,-500,-HT]) linear_extrude(HT) square(1000);
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
module magnets(SCREWS=true) {
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
            if (SCREWS) {
                cylinder(r=SMALL_R, h=BIG);
            }
        }
}

// six holes for the underglow LEDs
module underglow()
{
    LEDS = [ 
                // pinky
               [27,46,0],
               [27,66,0],
    
                // middle
               [65,35,0],
               [65,72.5,0],
    
                // index
               [103,29.5,0],
               [103,68,0]
            ];

    for (l=LEDS)
        translate(l)
            cube([6,6,100]);
}

module top_plate() {

    chop() 
    difference() {

        union() {
            translate([4,2,4.5]) 
            rotate([0,180,0])
            translate([0, 31, 0 ]) 
                mirror([0,1,0])
                    import("input/cherryplate.stl");
            
            // fill in the screw holes in the input STL,
            // we will remove them again below
            screw_holes(HT=4.5, R=2.6, R2=2.6);
        }
        
        // widen the screw holes
        // but don't inset them, it isn't necessary and it
        // complicates the printing
        translate([0,0,5]) 
            mirror([0,0,1]) 
                screw_holes(HT=5,R=1.3, R2=1.3);        

        // square off the top edges
        if (true) {
            color("green") translate([35,87,0]) linear_extrude(10) square(5);
            color("green") translate([54,91.8,0]) linear_extrude(10) square(5);
            color("green") translate([77,91.8,0]) linear_extrude(10) square(5);
            color("green") translate([96,89.3,0]) linear_extrude(10) square(5);
        }
        
    } // diff
        
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
module crkbd3d(SCREWS=true) {
      
    difference() {

        translate([2,0,3.5]) rotate([0,180,0])
            translate([0, 31, 0 ]) 
                mirror([0,1,0])
                    import("input/backplate_nofeet.stl");
        
        // widen the screw holes
        screw_holes(HT=BASE_THICKNESS);
            
    } // diff
}

// 2d projection of the botom plate
// there are no screw holes
module crkbd2d(SCREWS=true) {
    projection() {
        crkbd3d(SCREWS=SCREWS);
        screw_holes(); 
    }
}

