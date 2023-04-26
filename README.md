# DGRoamingPlanes
DG Script that adds roaming planes (with ATC option)

# Description

This Arma 3 Exile script spawns roaming civilians in a plane, and let them fly between airports on the map.
The plane will first take off from a random airport, and then move to a position on the map that is mirrored (x,y) of the starting position.
After it reached that position it will land at another random airport. If there is only one airport on the map, it will land at the same airport it took of from.

After landing, the pilot will leave the plane and move to the nearest enterable house. (or despawns instantly if no house was found). At the same time a timer will be enabled
which will delete the plane if no player entered it after `120 seconds`. This time will later be integrated in `DGCore Configuration`.
Once a player enters the plane before the timer ran out, it will stop despawning, and the player can claim/sell the plane.

The pilot will be deleted once he reached the house, but he will be deleted from the active queue once he landed.

## ATC
I integrated ATC communication between the planes and virtual ATC. This can come in handy for players that are trying to land at that exact moment a plane is on the runway.
You can disable this in the `configuration`. 

I implemented some default sounds into the `@Base Defense Systems` mod, which will trigger the comminucation for players in range. If you uncomment the BDS arrays in `DGRP_ATCTraffic` they will be used. By default you need to add your own `CfgSound` classes in array format.

# Installation

1. Be sure you have [@DGCore](https://github.com/Dagovax/DGCore) installed on your Exile server

2. Download the `DGRoamingPlanes-main.zip` and extract it to your documents.

3. Place the `a3_dg_roamingPlanes.pbo` inside your "@ExileServer\addons" folder on your server

# Configuration

You can configure the scipt to your needs by opening `a3_dg_roamingPlanes\config\DGRP_config.sqf`:
After you completed the configuration, don't forget to PBO the folder `a3_dg_roamingPlanes` and place it in your "@ExileServer\addons".

Note: This scipt requires `@DGCore`. Configuration for planes will be used for plane class selection.