use <../crkbd.scad>

FN=120;
$fn=FN;


module holes(R=1.3, R2=3, HT=25, HOLES=[]) {
    
    for (h=HOLES) {
        translate([h[0],h[1],0]) {
            difference() {
            color("green") cylinder(r=R2, h=HT);
            color("blue") cylinder(r=R, h=HT);
            }
        }
    }
}   

// This does most of the work for the stand. Even the base
// is just a hull of the pillars
// 
// there are some clearance issues at the attachment points 
// that require the ends that touch the board to be small
// 
// I deal with this by extruding slightly less degrees for the 
// thick part. Original was 20/18
//
module pillars() {

    TENT = 15;  // degree of tenting
    
    h_big = [ [96.5,72.1], 
              [63.7,32.4], [110.2,24.5]
    ];

    h_small = [ [20.4,49.4], [20.5,68.6], [96.5,72.1], 
              [63.7,32.4], [110.2,24.5]
    ];
    
    // the thick parts
    rotate([90,0,0])
    rotate_extrude(angle=TENT-2, $fn=FN)
        projection() holes(R=1.1, R2=5, HT=.2, HOLES=h_big);

    // the thick parts
    rotate([90,0,0])
    rotate_extrude(angle=TENT, $fn=FN)
        projection() holes(R=1.1, R2=3, HT=.2, HOLES=h_small);

}

module stand(ht=5) 
{
    // base
    translate([0,0,-ht])
        linear_extrude(ht)
            offset(r=5) hull() projection() pillars();

    // pillars
    pillars();
}

module whole_thing() 
{
    // stand 6.5 mm high, angle 5 degrees currently
    difference() {
        translate([0,80,0])
            stand(6.5);

        // subtract out this rotated flat surface to add some 
        // tilt to the stand
        translate([0,-10,-17])
        color("red") rotate([5,0,0]) cube([200,200,10]);

    }


}


// holder for the 1.3mm LED
module lcd_1_3(ht=2) {
     
    difference() {
        union() {
            
            // base
            translate([0,0,2-ht]) linear_extrude(ht) square([36,34]);
            
            // the original corne cover
            //color("red") translate([20,32.9,0]) import("oled_cover.stl");                        
            
            // left supports
            color("purple") {
            
            // top
            translate([0,31,2])
                linear_extrude(1) square([36,3]);    
            
            translate([0,0,2])
                linear_extrude(1) square([3,14]);
            translate([0,20,2])
                linear_extrude(1) square([3,14]);
            
            // right supports 
            translate([33,0,2])
                linear_extrude(1) square([3,14]);            
            translate([30,0,2]) linear_extrude(1) square(6);
                
            translate([33,20,2])
                linear_extrude(1) square([3,8]);
            translate([30,28,2]) linear_extrude(1) square(6);
            
            // bottom supports
            translate([11,0,2])
                linear_extrude(3) square([13,3]);
            translate([0,0,2])
                linear_extrude(1) square([36,3]);    

            }
        }
        
        // cutout for wires
        translate([12,29,-0.01])
            linear_extrude(10) square([12,5]);
        
        // screw holes
        translate([2.5,3+28,-4]) cylinder(r=1.1,h=50);
        translate([2.5,3,-4]) cylinder(r=1.1,h=50);
        translate([2.5+30.5,3,-4]) cylinder(r=1.1,h=50);
        translate([2.5+30.5,3+28,-4]) cylinder(r=1.1,h=50);

    }
    
    
}


module corne_1_3()
{
    intersection() 
    {
        rotate([15,0,0]) lcd_1_3(30);
        linear_extrude(100) projection() chop() rotate([15,0,0]) lcd_1_3();
    }            // the original corne cover
    difference() {
        color("red") translate([20,31.7,0]) import("../input/oled_cover.stl");
            // cutout for wires
            translate([12,28,-0.01])
                linear_extrude(10) square([12,5]);
    }                        
}

module corne_1_3b()
{
    TENT = -20;

    
    /*
    intersection() 
    {
        rotate([15,0,0]) lcd_1_3(30);
        linear_extrude(100) projection() chop() rotate([15,0,0]) lcd_1_3();
    } 
    */
    difference() {
    translate([0,0,10]) rotate([0,-TENT,0]) {
        // the original corne cover
        translate([.2,0,-11])
        rotate([0,TENT,0])
        difference() {
            color("red") 
                translate([20,31.7,0]) import("../input/oled_cover.stl");
            // cutout for wires
            translate([12,28,-0.01])
                linear_extrude(10) square([12,5]);
        }                        

        translate([0,0,-5]) intersection() 
        {
            rotate([15,0,0]) lcd_1_3(30);
            translate([0,0,-5]) linear_extrude(100) projection() chop() rotate([15,0,0]) lcd_1_3();
        } 

//        rotate([15,0,0]) lcd_1_3(30);
    }
    translate([-1,-10,-50.4]) cube([17.5,100,50]);
    
        translate([17,0,-0.6])
    rotate([0,-TENT,0]) color("blue") 
        translate([-1,-10,-10]) cube([50,100,10]);

    }


}

whole_thing();
//corne_1_3();
//corne_1_3b();
