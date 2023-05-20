![image of crkbd](/images/corne_feet.jpg)

These are the various ways I have built my [corne keyboads](https://github.com/foostan/crkbd).

# Source files

The project can be built from 3 files:
- corne_feet.scad
- cherryplate.stl
- backplate_nofeet.stl

The two STLs come from: https://thingiverse.com/thing:4459741

The scad file generates all of the other STLs.

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


