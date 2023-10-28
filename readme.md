![image of crkbd](/images/corne_feet.jpg)

These are the various ways I have built my [corne keyboads](https://github.com/foostan/crkbd).
Over time it has evolved into more of a toolkit for corne-related projects in OpenSCAD.

# Source files


## crkbd.scad

This is the main library file that all of the projects are built on.

### crkbd3d(SCREWS=true)

This creates a bottom plate. It starts with the backplate_nofeet.stl file,
which it moves to a standard position in the upper right quadrant. It then
cuts out the screw holes. Doing this widens them slightly and makes sure that 
they are in the exact same spots as anything else done by this API.


### crkbd2d(SCREWS=true)

This creates a 2d profile of the PCB. The SCREWS parameter
controls whether or not it will include holes for the five
standoffs that the PCB allows for. The 2D profile is useful 
for making more complicated shapes.

This is basically a projection of crkbd3d().

## stl files
The project can be built from 3 files:
- corne_feet.scad
- cherryplate.stl
- backplate_nofeet.stl

The two STLs come from: https://thingiverse.com/thing:4459741

The scad file generates all of the other STLs.

# Projects

## stl-feet

## Pillars

This is sort of a bottom plate. It contains five pillars that are 
extruded 20 degrees around an axis to give it 20 degrees of tenting.
The pillars have holes that you can screw M2 screws into. I didn't 
thread these, they are just small enough that the screw will to that 
for you. The screws are meant to go down through the top plate and PCB
directly into the 3D printed object. 

I am using this with a fairly strange corne that i built with the 
controller on the bottom. It accomodates that nicely. This board 
also uses a 1.3" OLED. There is a separate mount for that included
in the project. But it would work just fine with normal OLEDs and controllers.

## Case

A quick and dirty box to store a corne in for travel. Before I built
this I actually lost a keyswitch and keycap when pulling the board out 
of a pocket in my laptop case. This should fix that.
# STL Files

- keyplate.stl

  the top plate that the cherry mx switches fit in. It does not
  matter what top plate you use, you can use the rest of these STLs
  with any top plate, even an FR4 or an acrylic plate.

- base_plate_flat.stl

  flat bottom plate with holes for 4 magnets. This is 
  the bottom plate to attach to keyplate.stl if you want
  to use the magnetic attachments.

- base_plate_5x5.stl

  a base plate with 5 degrees of tent ant 5 degrees of tilt.
  It does not use magnets. It is best for keebs that you don't 
  need to travel with. You can dial in an appropriate amount of
  tent and tilt in the SCAD file; 5x5 just happens to work nicely
  for me.
  
- corne_feet.stl

  These are small feet which attach via magnets to the magnetic
  bottom plate to provide some tenting.


