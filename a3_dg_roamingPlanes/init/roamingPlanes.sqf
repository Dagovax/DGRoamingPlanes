if (!isServer) exitWith {};

if (isNil "DGRP_Configured") then
{
	["Waiting until configuration completes...", "DG Roaming Planes"] call DGCore_fnc_log;
	waitUntil{uiSleep 10; !(isNil "DGRP_Configured")}
};

["Initializing Dagovax Games Roaming Planes", DGRP_MessageName] call DGCore_fnc_log;

/****************************************************************************************************/
/********************************  DO NOT EDIT THE CODE BELOW!!  ************************************/
/****************************************************************************************************/
if(DGRP_DebugMode) then 
{
	["Running in Debug mode!", DGRP_MessageName, "debug"] call DGCore_fnc_log;
	DGRP_MinAmountPlayers	= 0;
	DGRP_MinSleepTime		= 10;		// Minimum amount of seconds to sleep until new initialization starts.
	DGRP_MaxSleepTime		= 60; 		// Maximum amount of seconds to sleep until new initialization starts.
	DGRP_MaxPlanes			= 20; 		// Amount of roaming AI to be active at the same time.
	DGRP_EnableMarker		= true;
};

if (DGRP_MinAmountPlayers > 0) then
{
	diag_log format ["%1 Waiting for %2 players to be online.",DGRP_MessageName, DGRP_MinAmountPlayers];
	waitUntil { uiSleep 10; count( playableUnits ) > ( DGRP_MinAmountPlayers - 1 ) };
};
[format["%1 players reached. Initializing main loop of roaming civilian planes", DGRP_MinAmountPlayers], DGRP_MessageName, "debug"] call DGCore_fnc_log;

DGRP_RoamingQueue = []; // Active groups. 

_reInitialize = true; // Only initialize this when _reInitialize is true
while {true} do // Main Loop
{
	if(_reInitialize) then
	{
		_reInitialize = false;
		if(count DGRP_RoamingQueue >= DGRP_MaxPlanes) exitWith{};
		
		_planeInfo = [] call DGCore_fnc_spawnCivilPlane;
		if(isNil "_planeInfo") exitWith{}; // Something bad happened
		_newGroup = _planeInfo select 0;
		_ilsStart = _planeInfo select 1;
		_ilsEnd = _planeInfo select 2;
		if(isNil "_newGroup") exitWith{}; // Something bad happened
		
		[_newGroup, _ilsStart, _ilsEnd] spawn
		{
			params["_newGroup", "_ilsStart", "_ilsEnd"];
			_plane = [_newGroup, true] call BIS_fnc_groupVehicles select 0;
			if(isNil "_plane") exitWith{};
			if(isNull _plane) exitWith{};
			_planeName = getText (configFile >> "CfgVehicles" >> (typeOf _plane) >> "displayName");
			if(DGRP_EnableATC) then
			{
				_useAudio = true;
				if(isNil "DGRP_ATCTraffic") then
				{
					_useAudio = false;
				};
				if(DGRP_ATCTraffic isEqualTo []) then
				{
					_useAudio = false;
				};
				
				_startNearbyPlayers = [_ilsStart, 1000] call DGCore_fnc_getNearbyPlayers;
				_sndSelection = selectRandom DGRP_ATCTraffic;
				if(!isNil "_startNearbyPlayers") then
				{
					if (count _startNearbyPlayers > 0) then
					{
						if(_useAudio) then
						{
							[_sndSelection select 0] remoteExec ["playSound",_startNearbyPlayers]; // ATC clearance
						};
						_planeClearanceMessage = format ["[%1]: Tower, Ready for Departure - Runway %2",_planeName, DGRP_RunwayTakeoff];
						_planeClearanceMessage remoteExecCall ["systemChat",_startNearbyPlayers];
						
						while {alive _plane && !isNull _plane} do
						{
							if(!alive _plane || isNull _plane) exitWith{};
							_currentPos = getPos _plane;
							if( _currentPos distance2D _ilsStart <= 100) exitWith // Plane is ready to takeoff
							{
								uiSleep DGRP_ATCResponseTime;
								if(_useAudio) then
								{
									[_sndSelection select 1] remoteExec ["playSound",_startNearbyPlayers]; // Plane take off response
								};
								_atcClearanceMessage = format ["[ATC]: %1, Cleared for Takeoff - Runway %2",_planeName, DGRP_RunwayTakeoff];
								_atcClearanceMessage remoteExecCall ["systemChat",_startNearbyPlayers];
							};
							uiSleep 2;
						};
					};
				};
				
				while {alive _plane && !isNull _plane} do
				{
					if(!alive _plane || isNull _plane) exitWith{};
					_currentPos = getPos _plane;
					if( _currentPos distance2D _ilsEnd <= DGRP_ATCApproachRange) exitWith
					{
						_endNearbyPlayers = [_ilsEnd, 1000] call DGCore_fnc_getNearbyPlayers;
						if(!isNil "_endNearbyPlayers") then
						{
							if (count _endNearbyPlayers > 0) then
							{
								if(_useAudio) then
								{
									[_sndSelection select 2] remoteExec ["playSound",_endNearbyPlayers]; // Plane land request
								};
								_planeLandMessage = format ["[%1]: Ready to Land - Runway %2",_planeName, DGRP_RunwayLand];
								_planeLandMessage remoteExecCall ["systemChat",_endNearbyPlayers];
								uiSleep DGRP_ATCResponseTime;
								if(_useAudio) then
								{
									[_sndSelection select 3] remoteExec ["playSound",_endNearbyPlayers]; // ATC land response
								};
								_atcLandMessage = format ["[ATC]: %1, Cleared to Land - Runway %2",_planeName, DGRP_RunwayLand];
								_atcLandMessage remoteExecCall ["systemChat",_endNearbyPlayers];
							};
						};
					};
					uiSleep 5;
				};
			};
		};
		
		if(!isNull _newGroup) then
		{
			_queueLocator = format["%1", _newGroup];
			DGRP_RoamingQueue pushBack _queueLocator;
			
			if(DGRP_EnableMarker) then
			{
				_plane = [_newGroup, true] call BIS_fnc_groupVehicles select 0;
				if(isNil "_plane") exitWith{};
				if(!isNull _plane) then
				{
					[_plane, "c_plane"] call DGCore_fnc_addMarkerMonitor;
				};
			};
			
			[_newGroup, _queueLocator] spawn
			{
				params["_newGroup", "_queueLocator"];
				while {!isNull _newGroup} do
				{
					if(isNull _newGroup) exitWith{};
					_unitAlive = false;
					{
						if(alive _x) exitWith
						{
							_unitAlive = true;
						}
					} forEach units _newGroup;
					
					if(!_unitAlive) exitWith
					{
						deleteGroup _newGroup;
					};
				};
				DGRP_RoamingQueue deleteAt (DGRP_RoamingQueue find _queueLocator);
			};
		};
	};
	_reInitialize = true;
	
	// Wait randomly until next iteration.
	_waitTime =  (DGRP_MinSleepTime) + random((DGRP_MaxSleepTime) - (DGRP_MinSleepTime));
	[format ["Active queue [%1] = %2", count(DGRP_RoamingQueue), DGRP_RoamingQueue], DGRP_MessageName, "debug"] call DGCore_fnc_log;
	[format["Waiting %1 seconds for next roaming plane spawn iteration", _waitTime], DGRP_MessageName, "debug"] call DGCore_fnc_log;
	uiSleep _waitTime;
}