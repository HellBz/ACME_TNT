/*/////////////////////////////////////
//...................................//
//...............ACME's..............//
//................TNT................//
//.....Terrible Nuke Territory.......//
//........by CH!LL3R & $p4rkY........//
//...................................//
//............inspired by............//
//..mmmyum's animated air raid dayz..//	["systemChatRequest", [format ["%1 has won a round of Russian Roulette!", name _playerObject]]] call ExileServer_system_network_send_broadcast;
//...................................//
//..........www.acme-vip.de..........//
//...................................//
/////////////////////////////////////*/
     
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	 
    private ["_speaker1","_speaker2","_speaker3","_dropHeight","_rndTime","_time","_getTime","_breakMin","_breakMax","_rdmBomb","_randomlcs","_randomlcsoutput","_randomlocCity","_randomLocz","_randomlocxx","_randomlocy","_lcs","_lct","_alarm1","_alarm2","_alarm3","_mortar","_dropdist","_soundPath","_deleteJetLoc","_spawnPointJet","_preWaypointPos","_spawnMarker","_spawnRadius","_wp","_espl","_sound","_duration","_loc","_city","_z","_xx","_y","_coords","_target","_posdebug","_jetModel","_jetStart","_safetyPoint","_bomberName","_positionLand","_bomber","_landingzone2","_aigroup2","_jetPilot","_wp2","_pos","_pos1","_wp3","_preWaypoints","_sirendist","_ray","_pos2","_targetpos","_poswhistl","_citySwing","_wpT","_citySwing2","_wpT2","_wpLand","_numberOfBombs","_esp3","_posEsp3","_debugPosEs1","_bomberDisT","_sirenPlayCnt","_randomLoc","_bomberPos","_debugRPT","_EndCounter","_safetyEndPos","_safetyEnd"];
    diag_log format ["| ACME TNT | Terrible Nuke Territory ready to start. Waiting for first Player to start.............."];
	waitUntil{({isPlayer _x} count playableUnits) >= 1};	//wait until server has one or more player
	_soundPath 			= [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;	//we need this for soundfiles, do not edit... change soundpath down by alarm1, alarm2 ando on, if needed
	_mapSize = getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize"); //get the total size of current map
	_worldCenter 		= [(_mapSize/2), (_mapSize/2)]; //now we have the center of current map
	'centerPoint' setMarkerPos _worldCenter;			//now we get a point to start
    _spawnMarker 		= 'centerPoint';				//this is for the prewaypoints
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////
	//														//
    //	Start Setup - change settings below to your wishes	//
	//														//
	//////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_debugRPT 			= false;						//true = extended debug messages || use only to check for errors, spams the server.rpt
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	uisleep 			  300;							// sleeps 5 minutes after first player has connected and on start of every cycle
    _breakMin 			= 2700;							//minimum time between each bomb cycle in seconds |2700 = 45 minutes
    _breakMax 			= 3600;							//maximum time between each bomb cycle in seconds |3600 = 60 minutes
    _minDist2Trader     = 1000;                         //set minimum distance to TraderZones -- set to 0 if not needed
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    _jetModel 			= selectRandom [				//change to classnames of jets you want to random select.
						"B_Plane_CAS_01_F",				// A-164 --- Wipeout
						"I_Plane_Fighter_03_CAS_F",	    // A-143 --- Buzzard
						"O_Plane_CAS_02_F",             // To-199 -- Neophron
						"B_T_VTOL_01_armed_F"			// V-44 X -- Blackfish (Armed)
						];	                            //if you only want one kind of a jet, just change all to the same classname ;-)
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_rdmBomb 			= selectRandom [				//change to classnames of bombs you want to random select.
						"Bo_Mk82_MI08",
						"Bomb_03_F",
						"Bomb_04_F",
						"Bo_GBU12_LGB"
						];
	_dropHeight			= 75;							//from this height bombs will fall down, needs to be lower than the bomber, or bomber = boom!!!
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_spawnPointJet 		= selectRandom [				// random spawnpoints for the jet [x,y,z] | [0,0,300] is the bottom left corner of the map, height 300
						[0,0,300],		                // if you want to have only one point to start, just change all to the same coords :-) or delete all lines except the first line
						[0,0,300],		                // these coords are from Chernarus
						[0,0,300]		                // <-- Last entry, no comma
						];
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_deleteJetLoc 		= selectRandom [				// random points to delete jet after bombing | for now its the top right corner of the map. For specific coords use [x,y,z]
						[_mapSize, _mapSize,300],		// handle the same way as _spawnPointJet above
						[_mapSize, _mapSize,300] 		// <-- Last entry, no comma
						];
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_ambientSound		= true;							// <-- set to false if you want no sounds like sirens and falling bombs around 1000m of the nukezone
	_alarm1 			= _soundPath + "Sounds\siren1.ogg";	// <-- change to matching soundpath for siren 1 -- this one plays a long siren for 2:08 minutes
    _alarm2 			= _soundPath + "Sounds\siren2.ogg";	// <-- change to matching soundpath for siren 2 -- this one plays a long siren for 1:39 minutes
    _alarm3 			= _soundPath + "Sounds\siren3.ogg";	// <-- change to matching soundpath for siren 3 -- this one plays a long siren for 0:12 minutes (it is for loop)
    _mortar 			= _soundPath + "Sounds\drop.ogg";	// <-- change to matching soundpath for falling Bomb -- this one plays a sound for 0:04 minutes
	_sirendist			= 1000;							//distance sirens are audible at
	_dropdist			= 500;							//distance droppingsounds are audible at
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    _randomLoc 			= true;							//true if you want random locations (be sure to set static location otherwise!)
    _loc 				= ["BalotaAirstrip",_dropHeight,4829.9868,2450.1104];	//Set to static location format ["name",_dropHeight,x,y]  //SKIP if using random locations
    _city 				= "BalotaAirstrip";				//Set to string name of static location//allows for custom name in rpt no spaces
    _numberOfBombs 		= 15;							//how many bombs are dropped assuming 1 per cycle
	_preWaypoints 		= 2;							//add waypoints before arriving at location.
    _spawnRadius = 3000;								//radius to choose for prewaypoint (choose within x of _spawnMarker wich is centered of the map)
    _ray = 100;											//ray of bombing//radius
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////End of Setup - dont change anything below this line until you exactly know what you are doing :-)//////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if (_debugRPT) then {diag_log format ["| ACME TNT | Extended Debug - Info activated |  Sound: %1  | Map Size: %2 | Map Center: %3 | Marker for Prewaypoint: %4 |",_soundPath,_mapSize,_worldCenter,_spawnMarker];
	 					 diag_log format ["| ACME TNT | Jet selected .......| %1 |",_jetModel];
	 					 diag_log format ["| ACME TNT | Bomb selected ......| %1 |",_rdmBomb];
	 					 diag_log format ["| ACME TNT | Spawn selectet .....| %1 |",_spawnPointJet];
	 					 diag_log format ["| ACME TNT | Endpoint selectet ..| %1 |",_deleteJetLoc];
	 					 diag_log format ["| ACME TNT | Randomlocation: ....| %1 |",_randomLoc];
	 					 diag_log format ["| ACME TNT | If static location: | Coords: %1 | Name_ %2",_loc,_city];
	 					 diag_log format ["| ACME TNT | Bombs: %1 | Waypoints: %2 | Radius Waypoints: %3 | Bombs Ray: %4 |",_numberOfBombs,_preWaypoints,_spawnRadius,_ray];
	 					 diag_log format ["| ACME TNT | Sounds: | activated: %5 | %1 | %2 | %3 | %4 |",_alarm1,_alarm2,_alarm3,_mortar,_ambientSound];};
						 diag_log format ["| ACME TNT | %1 with %2 selected. Starting at %3",_jetModel,_rdmBomb,_spawnPointJet];
	
	
    //Initialize //dont change this
    _xx = (_mapSize/2);
    _y  = (_mapSize/2);
    _z  = _dropHeight;


    _duration = _numberOfBombs;
     
    //if option for random/static
   if (_randomLoc) then {
                      _noValidPos = true;   
                      While {_noValidPos} do { 
                                                 _lcs = [];
                                                {_lct = _forEachIndex;
                                                    {   _lcs pushBack [text _x, _lct, locationPosition _x, direction _x, size _x, rectangular _x];
                                                    } forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), [_x], worldSize];    
                                                } forEach ["NameCity", "NameCityCapital", "Airport", "NameMarine"];
                                                _randomlcs = selectRandom _lcs;
                                                _randomlcsoutput = [_randomlcs select 0,_randomlcs select 2];
                                                _randomlocCity = _randomlcsoutput select 0;
                                                _randomLocz = _dropHeight;
                                                _randomlocxx = (_randomlcsoutput select 1) select 0;
                                                _randomlocy = (_randomlcsoutput select 1) select 1;
                                                _loc = [_randomlocCity, _randomLocz, _randomlocxx, _randomlocy];
                                                _city = _loc select 0;
                                                _z = _dropHeight;
                                                _xx = _loc select 2;
                                                _y = _loc select 3;
                                                _coords = [_xx,_y,_z];
                                                if ([_coords, _minDist2Trader] call ExileClient_util_world_isTraderZoneInRange) then {_noValidPos = true;}
                                                                                                                                     else {_noValidPos = false;};
                                                };
                                                diag_log format ["| ACME TNT | RANDOM WORLDSPACE: %1 | %2",_city,_coords];
                    }else{
                        _z =_dropHeight;
                        _xx = _loc select 2;
                        _y = _loc select 3;
                        _coords = [_xx,_y,_z];
                        diag_log format ["| ACME TNT | STATIC WORLDSPACE: %1 | %2",_city,_coords];
                     };
    uisleep 1;
     
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //above  ---- the worldpace is selected, coordinates stored in _coords = [_xx,_y,_z]/////////////////////////////////////////////////////////
    //below  ---- jet is created, flies to waypoint _coords while sirens play, hangs around till bombs are done flies off and is deleted/////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     
    //CREATE TARGET///////////////
    _loc = createVehicle ["HeliHEmpty", _coords,[], 0, "NONE"];
    _target = createVehicle ["HeliHEmpty",position _loc,[], 0, "NONE"];  
    _posdebug = position _target;
    if (_debugRPT) then {diag_log format ["| ACME TNT | SEL: %1 | TARGET: %2 | CITY: %3",_posdebug,_coords,_city];};
    uisleep 2;
    _jetStart = _spawnPointJet;
    _safetyPoint = _deleteJetLoc;
	_bomberName     = getText (configFile >> "CfgVehicles" >> _jetModel >> "displayName");
    if (_debugRPT) then {diag_log format ["| ACME TNT | %1 | TYPE: %4 Start at %2 | End at %3",_bomberName,str(_jetStart),str(_safetyPoint),_jetModel];};
    _positionLand = [position _target,0,50,5,0,0,0] call BIS_fnc_findSafePos; //set jet destination
    if (_debugRPT) then {diag_log format ["| ACME TNT | %1 moving from %2 to %3 NOW!( TIME: %4 )", _bomberName,  str(_jetStart), str(_positionLand), round(time)];};
     ["toastRequest", ["ErrorTitleAndText", ["AIRRAID DETECTED!", format ["A %1 has startet to bomb down %2",_bomberName,_city]]]] call ExileServer_system_network_send_broadcast;
     ["systemChatRequest", [format ["Airraid detected: A %1 has startet to bomb down %2",_bomberName,_city]]] call ExileServer_system_network_send_broadcast;
    //Build bomber
    _bomber = createVehicle [_jetModel,_jetStart, [], 0, "FLY"];
    _bomber engineOn true;
    _bomber flyInHeight 100;
    _bomber forceSpeed 300;
    //Create an Invisibile Landingpad near place to be bombed
    _landingzone2 = createVehicle ["HeliHEmpty", [_positionLand select 0, _positionLand select 1,0], [], 0, "CAN_COLLIDE"]; //_targets x,y
    if (_debugRPT) then {diag_log format ["| ACME TNT | %1 | BOMBER POS: %2 | POS LAND: %3 | TARGET: %4",str(getPosATL _landingzone2),str(getPosATL _bomber),str(_positionLand),str(getPosATL _target)];};
    _aigroup2 = creategroup civilian;
    _aigroup2 setVariable ["DMS_AllowFreezing",false];
    _jetPilot = _aigroup2 createUnit ["B_T_Pilot_F",getPos _bomber,[],0,"FORM"];
    _jetPilot moveindriver _bomber;
    _jetPilot assignAsDriver _bomber;
    uisleep 0.5;
    //prewaypoints
    if(_preWaypoints > 0) then {
            for "_x" from 1 to _preWaypoints do {
                    _preWaypointPos = [getMarkerPos _spawnMarker,0,_spawnRadius,10,0,2000,0] call BIS_fnc_findSafePos;
                    if (_debugRPT) then {diag_log format ["| ACME TNT | Adding Pre-target Waypoint #%1 on %2", _x,str(_preWaypointPos)];};
                    _wp = _aigroup2 addWaypoint [_preWaypointPos, 0];
                    _wp setWaypointType "MOVE";
                    _bomber flyInHeight 100;
                    _bomber forceSpeed 300;
                    _bomber setspeedmode "NORMAL";
                    uisleep 45;
                    waituntil {(_bomber distance _preWaypointPos) <= 2000 || !alive _bomber};
                    _bomberPos = getPosATL _bomber;
                    _wp setWPPos _bomberPos;
                    uisleep 35;
                    deleteWaypoint _wp; //deletes waypoint
                    if (_debugRPT) then {diag_log format ["| ACME TNT | %1  POS: %2 end moving to Pre-target Waypoint at %3 ( TIME: %4 )", _bomberName, str(getPosATL _bomber), str(_preWaypointPos), round(time)];};
            };
    };
    //Tell bomber to move to target
    _wp2 = _aigroup2 addWaypoint [position _target, 0];
    _wp2 setWaypointType "MOVE";
    _wp2 setWaypointBehaviour "CARELESS";
                   
    waituntil {(_bomber distance _positionLand) <= 10000 || !alive _bomber};
    _bomber flyInHeight 100;
    _bomber forceSpeed 300;
    _bomber setspeedmode "NORMAL";
	["toastRequest", ["ErrorTitleAndText", ["AIRRAID DETECTED!", format ["A %1 is on his way to bomb down %2. We advise you to leave this area immediately!",_bomberName, _city]]]] call ExileServer_system_network_send_broadcast;     
     ["systemChatRequest", [format ["Airraid detected: A %1 is on his way to bomb down %2. We advise you to leave this area immediately!",_bomberName, _city]]] call ExileServer_system_network_send_broadcast;
	
    ///////////////////////////////////////////////////////////////////START SIRENS/////////////////////////////////////////////////////
     
    _pos = position _target;
    if (!alive _bomber) then {diag_log format ["| ACME TNT | %1 DESTROYED...",_bomberName];};
    _speaker1 = createVehicle ["HeliHEmpty",position _target,[], 0, "NONE"];
    _speaker2 = createVehicle ["HeliHEmpty",position _target,[], 0, "NONE"];
    _pos1 = position _speaker1;
    if (_ambientSound) then {playSound3D [_alarm1, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
    uisleep 2;
    if (_ambientSound) then {playSound3D [_alarm2, _speaker2, false, getPos _speaker2, 15, 1, _sirendist];};
    _bomberDisT = _bomber distance _target;
    uisleep 5;
    _sirenPlayCnt = 0;
    //begin siren loop
	if (_ambientSound) then {["toastRequest", ["ErrorTitleAndText", ["AIRRAID INFO!", format ["If you can hear the siren at %1, we advise you to RUN!!!.", _city]]]] call ExileServer_system_network_send_broadcast;
							 ["systemChatRequest", [format ["AIRRAID INFO: If you can hear the siren at %1, we advise you to RUN!!!", _city]]] call ExileServer_system_network_send_broadcast;	
							}else{["toastRequest", ["ErrorTitleAndText", ["AIRRAID INFO!", format ["We advise you to leave %1 as fast as you can run!.", _city]]]] call ExileServer_system_network_send_broadcast;
								  ["systemChatRequest", [format ["AIRRAID INFO: We advise you to leave %1 as fast as you can... RUN!!!", _city]]] call ExileServer_system_network_send_broadcast;};
    while {(_bomberDisT < 10000) and (_bomberDisT > 1000) and (_sirenPlayCnt < 10)} do {
                    if (!alive _bomber) exitWith{diag_log format ["| ACME TNT | %1 DESTROYED...",_bomberName]};
             if (_debugRPT) then {if (_ambientSound) then {diag_log format ["| ACME TNT | Playing Siren at %1 | Siren Nam %2 | Loop Num: %3",str(getPosATL _speaker1),_sirendist,_sirenPlayCnt];};
                    if (_ambientSound) then {playSound3D [_alarm3, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
                    uisleep 10;
                    _bomberDisT = _bomber distance _pos;
                    uisleep 1;
                    _sirenPlayCnt = _sirenPlayCnt + 1;
                    uisleep 1;
            };
    if (_sirenPlayCnt < 3) then {
            if (_ambientSound) then {playSound3D [_alarm3, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
            uisleep 7;
            if (_ambientSound) then {playSound3D [_alarm3, _speaker2, false, getPos _speaker2, 15, 1, _sirendist];};
            uisleep 8;
            if (_ambientSound) then {playSound3D [_alarm3, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
            uisleep 7;
        if (_debugRPT) then {if (_ambientSound) then {diag_log format ["| ACME TNT | SIRENIF: PLAYCOUNT: %1 + 3| POSITION: %2",_sirenPlayCnt,str(getPosATL _bomber)];};};
    };
    if (_ambientSound) then {playSound3D [_alarm1, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
    uisleep 10;
    if (_ambientSound) then {playSound3D [_alarm2, _speaker2, false, getPos _speaker2, 15, 1, _sirendist];};
    uisleep 10;
     
    _bomber flyInHeight 100;
    _bomber forceSpeed 200;
    _bomber setspeedmode "NORMAL";
    _bomberDisT = _bomber distance _pos;
    diag_log format ["| ACME TNT | %3 DISTANCE: %1 | POSITION: %2",_bomberDisT,str(getPosATL _bomber),_bomberName];
    if (_ambientSound) then {playSound3D [_alarm1, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
    uisleep 12;
    if (_ambientSound) then {playSound3D [_alarm2, _speaker2, false, getPos _speaker2, 15, 1, _sirendist];};
    waituntil {(_bomber distance _target) <= 1200 || !alive _bomber};
    uisleep 8;
    _bomberPos = getPosATL _bomber;
    _wp2 setWPPos _bomberPos;
    uisleep 8;
    deleteWaypoint _wp2; //deletes waypoint
    _bomber flyInHeight 150;
    _bomber forceSpeed 200;
    _bomber setspeedmode "LIMITED";
    if (_ambientSound) then {playSound3D [_alarm3, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
    _citySwing = [position _target,0,20,1,0,2000,0] call BIS_fnc_findSafePos; //set chopper cycle move back and forth over city
    _wpT = _aigroup2 addWaypoint [_citySwing, 0];
    _wpT setWaypointType "MOVE";
    uisleep 15;
    _citySwing2 = [position _target,20,45,1,0,2000,0] call BIS_fnc_findSafePos; //set chopper cycle move back and forth over city
    _wpT2 = _aigroup2 addWaypoint [_citySwing2, 0];
    _wpT2 setWaypointType "MOVE";
    diag_log format ["| ACME TNT | %1 Bombing Initialize: arrived at %2!, ", _bomberName, str(getPosATL _bomber)];
    if (_ambientSound) then {playSound3D [_alarm3, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
                           
     ///////////////////////////////////////////////////START BOMBING////////////////////////////////////////////////////////////////////
     
    _debugPosEs1 = getPosATL _bomber;
    _debugPosEs1 set [2, 0.1];
    uisleep 1;
    _esp3 = createVehicle [_rdmBomb,_debugPosEs1,[], 0, "NONE"];
    _posEsp3 = position _esp3;
    if (_debugRPT) then {diag_log format ["| ACME TNT |  DEBUG ESP3: %1 | debugPosEs1: %2",_posEsp3,_debugPosEs1];};
    ///////////////////////////debug above
    uisleep 3;
    //play long siren during bombing, one short siren
    if (_ambientSound) then {playSound3D [_alarm2, _speaker2, false, getPos _speaker2, 15, 1, _sirendist];};
    uisleep 1;
    if (_ambientSound) then {playSound3D [_alarm3, _speaker1, false, getPos _speaker1, 15, 1, _sirendist];};
     
    //start bombs loop
    While {_duration > 0} do {
    if (!alive _bomber) exitWith{diag_log format ["| ACME TNT | %1 DESTROYED...",_bomberName]};

            _speaker3 = createVehicle ["Land_HelipadEmpty_F",position _target,[], _ray, "NONE"];
            uisleep 2;
            _espl = createVehicle [_rdmBomb,position _speaker3,[], 0, "NONE"];
            if (_ambientSound) then {playSound3D [_mortar, _speaker3, false, getPos _speaker3, 15, 1, _dropdist];};
            if (_duration > 9 || _duration < 2) then {
                   	if (_ambientSound) then {playSound3D [_alarm3, _speaker1, false, getPos _speaker1, 15, 1, _dropdist];};
                    _pos2 = getPosATL _espl;
                    _poswhistl = getPosATL _speaker3;
                    _targetpos = getPosATL _target;
                    diag_log format ["| ACME TNT | BOMB: %1 | TARGET: %2 | NUMBER: %3 | SOUND: %4 |",str(_pos2),_targetpos,_duration,_poswhistl];
            };
            _duration = _duration - 1;
            uisleep 2;
            deletevehicle _speaker3;
           
    }; // Close while loop. loop while _duration >1
    ///////////////////////////////////////////////////END SIRENS AND BOMBING, HELI LOWER TO GROUND, (SPAWN AIs), FLY AWAY//////////////////////////////////////////////////////////////
                    
    uisleep 2;
    _bomberPos = getPosATL _bomber;
    _wpT setWPPos _bomberPos;
    uisleep 5;
    deleteWaypoint _wpT;
    _bomberPos = getPosATL _bomber;
    _wpT2 setWPPos _bomberPos;
    uisleep 5;
    deleteWaypoint _wpT2;
   	["toastRequest", ["InfoTitleAndText", ["AIRRAID INFO!", format ["%1 is running out of bombs and leaving %2 now.", _bomberName,_city]]]] call ExileServer_system_network_send_broadcast;
   	["systemChatRequest", [format ["AIRRAID INFO: %1 is running out of bombs and leaving %2 now.", _bomberName,_city]]] call ExileServer_system_network_send_broadcast;
    diag_log format ["| ACME TNT |  %1 has Completed Bombing at %2!", _bomberName, str(getPosATL _bomber)];

     
    if (!alive _bomber) then {diag_log format ["| ACME TNT | %1 DESTROYED...",_bomberName];};
    uisleep 5;
    _safetyEndPos = [[_safetyPoint select 0,_safetyPoint select 1,0],0,1000,4,1,2000,0] call BIS_fnc_findSafePos;
    _safetyEnd = createVehicle ["HeliHEmpty", _safetyEndPos,[], 0, "NONE"];
    //Adding a last Waypoint up in the North, to send bomber away after completion. Change this location (_safetyPoint) to where you want the AI to seem to originate from
    _wp3 = _aigroup2 addWaypoint [_safetyEndPos, 0];
    _wp3 setWaypointType "MOVE"; //maybe change to land?
    _wp3 setWaypointBehaviour "CARELESS";
    uisleep 3;
    _bomber forceSpeed 400;
    _bomber flyInHeight 400;
    _bomber setspeedmode "FULL";
    diag_log format ["| ACME TNT |  %1 Leaving Area %2", _bomberName, str(getPosATL _bomber)];
    _bomberDisT = _bomber distance _safetyEnd;
    _EndCounter = 0;
    while {(_bomberDisT < 20000) and (_bomberDisT > 2000) and (_EndCounter < 45)} do {
                    if (!alive _bomber) exitWith{diag_log format ["AIRRAID: BOMBER DESTROYED: %1",_bomberName]};
                    _bomberDisT = _bomber distance _safetyEnd;
                    diag_log format ["| ACME TNT |  DISTANCE SAFETYPOINT: %1 | POSITION: %2",_bomberDisT,str(getPosATL _bomber)];
                    uisleep 30;
                    _EndCounter = _EndCounter + 1;
            };
     
    //////////////////////////////////////////////////////////CLEAN UP//CLEAN UP//CLEAN UP//
    uisleep 60;
    _bomberDisT = _bomber distance _safetyEnd;
    if (_debugRPT) then {diag_log format ["| ACME TNT |  DISTANCE SAFETYPOINT: %1 | POSITION: %2",_bomberDisT,str(getPosATL _bomber)];};
    _bomber forceSpeed 200;
    _bomber flyInHeight 100;
    _bomber setspeedmode "FULL";
    uisleep 5;
    deletevehicle _jetPilot;
    deletevehicle _bomber;
    if (_debugRPT) then {diag_log format ["| ACME TNT | %1 deleted.....",_bomberName];};
    deletevehicle _landingzone2;
    deletevehicle _speaker1;
    deletevehicle _speaker2;
    deletevehicle _loc;
    deletevehicle _target;
	["toastRequest", ["InfoTitleAndText", ["AIRRAID INFO!", format ["%1 is safe again... Which city will be the next target?", _city]]]] call ExileServer_system_network_send_broadcast;
   	["systemChatRequest", [format ["AIRRAID INFO: %1 is safe again... Which city will be the next target?", _city]]] call ExileServer_system_network_send_broadcast;
	_rndTime = [_breakMax,_breakMin];
    _time = diag_tickTime;
    _getTime = round(random(_rndTime select 1)) max(_rndTime select 0);
    diag_log format ["| ACME TNT | TNT sleeps for %1 |",_getTime];
    waitUntil{if((diag_tickTime - _time) >= _getTime)then[{true},{false}]}; 
    };