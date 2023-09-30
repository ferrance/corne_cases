use <crkbd.scad>

$fn=10;

BASE_THICKNESS = 3.5;    // per slicer, measured is as high as 3.9, sigh
TOP_THICKNESS  = 4.5;    // ht of top plate
MAG_H = 2.6;  // measured ht of magnets 

module top_plate() {

    chop() 
    difference() {

        union() {
            translate([4,2,4.5]) 
            rotate([0,180,0])
            translate([0, 31, 0 ]) 
                mirror([0,1,0])
                    import("cherryplate.stl");
            
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

top_plate();