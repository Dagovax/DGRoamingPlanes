waitUntil {uiSleep 5; !(isNil "DGCore_Initialized")}; // Wait until DGCore was initialized

["Starting Dagovax Games Roaming Planes"] call DGCore_fnc_log;
execvm "\x\addons\a3_dg_roamingPlanes\config\DGRP_config.sqf";
execvm "\x\addons\a3_dg_roamingPlanes\init\roamingPlanes.sqf";
