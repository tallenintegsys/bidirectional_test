# bidirectional_test
testing normal way vs Lattice primitives for bidirectional (Hi-Z) pin
This is a graphical representation of my RTL.  
![RTL](/doc/beforeSynth.png)

Does the IO associated with gpio_13 get converted to primitives (presumabably TRELLIS_IO) at the PNR step?  
![synthd](doc/beforePNR.png)

Is TRELLIS_IO the same as Lattice sysI/O?
