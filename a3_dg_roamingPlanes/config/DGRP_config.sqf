
DGRP_MessageName = "DG RoamingPlanes";

if (!isServer) exitWith {
	["Failed to load configuration data, as this code is not being executed by the server!", DGRP_MessageName] call DGCore_fnc_log;
};

["Loading configuration data...", DGRP_MessageName] call DGCore_fnc_log;

/****************************************************************************************************/
/********************************  CONFIG PART. EDIT AS YOU LIKE!!  ************************************/
/****************************************************************************************************/

// Generic
DGRP_DebugMode			= false; 	// Only for creator. Leave it on false
DGRP_MinAmountPlayers	= 1; 		// Amount of players required to start the missions spawning. Set to 0 to have no wait time for players
DGRP_MinSleepTime		= 120;		// Minimum amount of seconds to sleep until new initialization starts.
DGRP_MaxSleepTime		= 600; 		// Maximum amount of seconds to sleep until new initialization starts.
DGRP_MaxPlanes			= 4; 		// Amount of these type AI to be active at the same time.
DGRP_EnableMarker		= false;	// Will show a marker
DGRP_AllowDamage		= true;		// Plane can take damage. Default false
DGRP_Side				= CIVILIAN;	// Side of the unit that spawns. Choose between CIVILIAN | EAST | WEST | INDEPENDENT
DGRP_SetCaptive			= true;		// Pilot will be ignored by everyone, and no map icon will be visible. Civilians will be ignored by AI, even with setCaptive to false, unless Civilian side is made enemy
DGRP_WaitTime			= 30;		// Amount in seconds the plane will wait after spawn until taking off. (set this higher for player taxi). Default 0 (planes will take off instantly)

// ATC
DGRP_EnableATC			= true;		// Sends ATC land and take off messages to nearby players
DGRP_ATCRange			= 1500;		// Range around the airfield players will be notified of ATC messages/sounds
DGRP_ATCApproachRange	= 500;		// Aproach range for incoming aircraft. They will contact ATC at this distance from the airport
DGRP_ATCResponseTime	= 5; 		// Seconds in wich the ATC will respond to the aircraft call. If you enabled sounds and length is longer than this, they will interfere.
DGRP_RunwayTakeoff		= 26;		// Call sign of the runway the planes will take off from. Will be used in messages. (does not affect anything else)
DGRP_RunwayLand			= 10;		// Call sign of the runway the planes will land on. Will be used in messages. (does not affect anything else)

// This default input uses Base Defense Systems sounds by Dagovax. Turn ATC off if you don't use this mod: BDS -> (https://steamcommunity.com/sharedfiles/filedetails/?id=2631873636)
// Needs to be any sound defined in CfgSounds. Check config viewer for available sounds
DGRP_ATCTraffic = // Array in text format: [Aircraft Departure sound  | ATC Clearance sound | Aircraft Approach sound | ATC Approuch sound]
[
	["DG_CallSign_Arma3_Delivery_Departure", "DG_ATC_Arma3_Delivery_Departure", "DG_CallSign_Arma3_Delivery_Arrival", "DG_ATC_Arma3_Delivery_Arrival"],
	["DG_CallSign_DG_Departure", "DG_ATC_DG_Departure", "DG_CallSign_DG_Arrival", "DG_ATC_DG_Arrival"],
	["DG_CallSign_Cessna215b_Departure", "DG_ATC_Cessna215b_Departure", "DG_CallSign_Cessna215b_Arrival", "DG_ATC_Cessna215b_Arrival"],
	["DG_CallSign_DGCore_Airlines_Departure", "DG_ATC_DGCore_Airlines_Departure", "DG_CallSign_DGCore_Airlines_Arrival", "DG_ATC_DGCore_Airlines_Arrival"]
];

DGRP_Configured = true;
["Configuration loaded", DGRP_MessageName] call DGCore_fnc_log;