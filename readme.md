![image of crkbd](/images/corne_feet.jpg)

These are the various ways I have built my [corne keyboads](https://github.com/foostan/crkbd).
Over time it has evolved into more of a toolkit for corne-related projects in OpenSCAD.

# Source files


## crkbd.scad

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

## Case

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


