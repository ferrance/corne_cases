// 2022 12 10    original design
// 2023 01 01    clean up terrible code, now it is just really bad
//               add one piece backplate and feet
//               made the ledge a little taller

$fn=100;


// this just imports the bottom plate and positions it
module k3d() {
    translate([2,0,3.5]) rotate([0,180,0])
    difference() {
        translate([0, 31, 0 ]) 
            mirror([0,1,0])
                import("backplate_nofeet.stl");
    }
}

// 2d projection of the botom plate
module k2d() {
    offset(r=.5)
    projection() k3d(); 
}




// a wedge without the lip
module 1piece_wedge() {
  difference() {
    linear_extrude(30) projection() rotate([0,-ANGLE,0]) k3d();
    rotate([0,-ANGLE,0]) translate([-10,0,0]) linear_extrude(30) square(200);
    translate([15,0,0])
        linear_extrude(50) square([102,200]);      
  }
}



difference() {
    linear_extrude(27) square([140,170]);
    
    // bottom one 
    translate([139,98,0]) mirror([0,1,0]) mirror([1,0,0]) linear_extrude(100) k2d();
    
    // top one
    translate([0,70,0]) mirror([0,0,0]) linear_extrude(100) k2d();
}


