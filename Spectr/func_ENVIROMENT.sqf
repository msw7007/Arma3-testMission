///Спавн зон аномалий
AnoEnviroment_CreateAnomalyZones = {
	params ["_count"];
	for [{_i=0},{_i<_count},{_i=_i+1}] do {
		_pos = [[[OPCENTRALZONE, OPZONERAD]], [[OSIRIS, 500],"water"]] call BIS_fnc_randomPos;
		[_pos] spawn AnoEnviroment_CreateAnomalyZone;
	};
};
AnoEnviroment_CreateAnomalyZone = {
	params ["_pos"];
	_trg = createTrigger ["EmptyDetector", _pos, false];
	_trg setTriggerArea [150, 150, 0, false, 50];
	_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_triggerName = "AnomalyZone_" + str(round(random(10000)));
	_trg setVehicleVarName _triggerName;
	_triggerName = _trg;
	publicVariable "_triggerName";
	missionNamespace setVariable [str(_triggerName),_trg];
	_code = "[10,  " + str(_trg) + "] remoteExec ['enviroment_Anomalies', 2];";
	_trg setTriggerStatements ["this", _code, ""];
	_trg setTriggerInterval 5;
	[_triggerName, 0] call G_Signal_CreateEmitter;
	ANOCONTROLZONES pushbackUnique _trg;
	MISSIONSPECIALZONES pushbackUnique _trg;
	_maxCrys = ((random 3) + 2)*2;
	for [{ _i = 0 }, { _i <= _maxCrys }, { _i = _i + 1 }] do { 
		_flocation = [_pos, 0, 5, 1, 0, 20, 0] call BIS_fnc_findSafePos;
		_ElCrysClass = selectRandom BLUECRYSTS;
		_ElCrys = _ElCrysClass createVehicle _flocation;
		_ElCrys setDir (random 360);
		[_ElCrys, true, [0,2,1], 0] call ace_dragging_fnc_setCarryable;
		[_ElCrys, 1] call ace_cargo_fnc_setSize;
	};
	_obj = createVehicle ["Flag_CSAT_F" , _pos, [], 0, "NONE"];
	[_obj, 0] call BIS_fnc_animateFlag;
	_obj setFlagTexture "";
	[
		_obj,											// Object the action is attached to
		"Установка отметки",										// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Progress icon shown on screen
		"_this distance _target < 5",						// Condition for the action to be shown
		"_caller distance _target < 5",						// Condition for the action to progress
		{},													// Code executed when action starts
		{},													// Code executed on every progress tick
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			[_target, 1] call BIS_fnc_animateFlag;
			_obj setFlagTexture "\A3\Data_F\Flags\Flag_CSAT_CO.paa";
			MSQUADSUPPPOINTS = MSQUADSUPPPOINTS + 20;
			publicVariable "MSQUADSUPPPOINTS";
			[[east, "HQ"],"С.П.Е.К.Т.Р. видим вашу метку, мы позже направим в регион научный отряд."] remoteExec ["sideChat", 0];
		},				// Code executed on completion
		{},													// Code executed on interrupted
		[],													// Arguments passed to the scripts as _this select 3
		2,													// Action duration [s]
		0,													// Priority
		false,												// Remove on completion
		false												// Show in unconscious state 
	] remoteExec ["BIS_fnc_holdActionAdd", 0, _obj];	// MP compatible implementation
};

///Спавн зон мутантов
AnoEnviroment_CreateMutantZones = {
	params ["_count"];
	for [{_i=0},{_i<_count},{_i=_i+1}] do {
		_pos = [[[OPCENTRALZONE, OPZONERAD]], [[OSIRIS, 500],"water"]] call BIS_fnc_randomPos;
		[_pos] spawn AnoEnviroment_CreateMutantZone;
	};
};
AnoEnviroment_CreateMutantZone = {
	params ["_pos"];
	_trg = createTrigger ["EmptyDetector", _pos, false];
	_trg setTriggerArea [250, 250, 50, false, 50];
	_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_triggerName = "MonsterZone_" + str(round(random(10000)));
	_trg setVehicleVarName _triggerName;
	_triggerName = _trg;
	publicVariable "_triggerName";
	missionNamespace setVariable [str(_triggerName),_trg];
	_code = "[10, " + str(_trg) + ",5] remoteExec ['enviroment_Mutants', 2];";
	_trg setTriggerStatements ["this", _code, ""];
	_trg setTriggerInterval 5;
	[_triggerName, 0] call G_Signal_CreateEmitter;
	INFCONTROLZONES pushbackUnique _trg;
	MISSIONSPECIALZONES pushbackUnique _trg;
	_maxCrys = (random 2) + 2;
	for [{ _i = 0 }, { _i <= _maxCrys }, { _i = _i + 1 }] do { 
		_flocation = [_pos, 0, 5, 1, 0, 20, 0] call BIS_fnc_findSafePos;
		_ElCrysClass = selectRandom REDCRYSTS;
		_ElCrys = _ElCrysClass createVehicle _flocation;
		_ElCrys setDir (random 360);
		[_ElCrys, true, [0,2,1], 0] call ace_dragging_fnc_setCarryable;
		[_ElCrys, 1] call ace_cargo_fnc_setSize;
	};
};

///Спавн зон ресурсов
AnoEnviroment_CreateResourceZones = {
	params ["_count"];
	for [{_i=0},{_i<_count},{_i=_i+1}] do {
		_pos = [[[OPCENTRALZONE, OPZONERAD]], [[OSIRIS, 500],"water"]] call BIS_fnc_randomPos;
		[_pos] spawn AnoEnviroment_CreateResourceZone;
	};
};
AnoEnviroment_CreateResourceZone = {
	params ["_pos"];
	_maxCrys = ((random 3) + 2)*2;
	_ElCrysClass = selectRandom GREENCRYSTS;
	_ElCrys = _ElCrysClass createVehicle _pos;
	_trg = createTrigger ["EmptyDetector", _pos, false];
	_trg setTriggerArea [250, 250, 50, false, 50];
	_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_trg setTriggerStatements ["this", "", ""];
	_triggerName = "ResourceZone_" + str(round(random(10000)));
	_trg setVehicleVarName _triggerName;
	_triggerName = _trg;
	publicVariable "_triggerName";
	missionNamespace setVariable [str(_triggerName),_trg];
	[_triggerName, 0] call G_Signal_CreateEmitter;
	RESCONTROLZONES pushbackUnique _trg;
	for [{ _i = 0 }, { _i <= _maxCrys }, { _i = _i + 1 }] do { 
		_flocation = [_pos, 0, 5, 0.1, 0, 20, 0] call BIS_fnc_findSafePos;
		_ElCrysClass = selectRandom GREENCRYSTS;
		_ElCrys = _ElCrysClass createVehicle _flocation;
		_ElCrys setDir (random 360);
		[_ElCrys, true, [0,2,1], 0] call ace_dragging_fnc_setCarryable;
		[_ElCrys, 1] call ace_cargo_fnc_setSize;
	};
};

///Спавн зон раскопок
AnoEnviroment_CreateDigZones = {
	params ["_count"];
	for [{_i=0},{_i<_count},{_i=_i+1}] do {
		_pos = [[[OPCENTRALZONE, OPZONERAD]], [[OSIRIS, 500],"water"]] call BIS_fnc_randomPos;
		[_pos] spawn AnoEnviroment_CreateDigZone;
	};
};
AnoEnviroment_CreateDigZone = {
	params ["_pos"];
	_maxCrys = (random 2) + 2;
	_dlocation = [_pos, 0, 1000, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	_trg = createTrigger ["EmptyDetector", _pos, false];
	_trg setTriggerArea [250, 250, 50, false, 50];
	_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_trg setTriggerStatements ["this", "", ""];
	_triggerName = "ResourceZone_" + str(round(random(10000)));
	_trg setVehicleVarName _triggerName;
	_triggerName = _trg;
	publicVariable "_triggerName";
	missionNamespace setVariable [str(_triggerName),_trg];
	[_triggerName, 0] call G_Signal_CreateEmitter;
	for [{ _i = 0 }, { _i <= _maxCrys }, { _i = _i + 1 }] do { 
		_flocation = [_dlocation, 0, 5, 1, 0, 20, 0] call BIS_fnc_findSafePos;
		_ElCrysClass = selectRandom PURPLECRYSTS;
		_ElCrys = _ElCrysClass createVehicle _flocation;
		_ElCrys setDir (random 360);
		[_ElCrys, true, [0,2,1], 0] call ace_dragging_fnc_setCarryable;
		[_ElCrys, 1] call ace_cargo_fnc_setSize;
	};
	DIGCONTROLZONES pushbackUnique _trg;
	_flocation = [_dlocation, 0, 50, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	_digZoneItem = "Land_Bulldozer_01_abandoned_F" createVehicle _flocation;
	_digZoneItem setDir (random 360);
	_flocation = [_dlocation, 0, 50, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	_digZoneItem = "Land_HaulTruck_01_abandoned_F" createVehicle _flocation;
	_digZoneItem setDir (random 360);
	_flocation = [_dlocation, 0, 50, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	_digZoneItem = "Land_Excavator_01_abandoned_F" createVehicle _flocation;
	_digZoneItem setDir (random 360);
	_flocation = [_dlocation, 0, 50, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	_digZoneItem = "Land_MiningShovel_01_abandoned_F" createVehicle _flocation;
	_digZoneItem setDir (random 360);
};

///Спавны
enviroment_Anomalies = {
		params ["_count","_zone"];
		for [{_i=0},{_i<_count},{_i=_i+1}] do {
			_pos = _zone call BIS_fnc_randomPosTrigger;
			_ano = selectRandom ALLOWEDANOMALIES;
			switch (_ano) do
			{
				case "M" : {[_pos] call anomaly_fnc_createMeatgrinder;};
				case "E" : {[_pos] call anomaly_fnc_createElectra;};
				case "S" : {[_pos] call anomaly_fnc_createSpringboard;};
				case "B" : {[_pos] call anomaly_fnc_createBurner;};
				case "P" : {[_pos] call anomaly_fnc_createFruitPunch;};
				case "T" : {
					PortalId = missionNamespace getVariable ["PortalId",0];
					[_pos, PortalId] call anomaly_fnc_createTeleport;
					_pos = [nil, ["water"]] call BIS_fnc_randomPos;
					[_pos, PortalId] call anomaly_fnc_createTeleport;
					PortalId = PortalId + 1;
					publicVariable "PortalId";
				};
				case "F" : {[_pos, 20, false] call anomaly_fnc_createFog;};
			};
		};
	};
enviroment_Mutants= {
		params ["_count","_zone","_cd"];
		if (INFECTED_ACTIVE) then {
			_iArray = [];
			_iZone = true;
			_timer = 0;
			_varName = str(_zone) + "_GrArray";
			missionNamespace setVariable [_varName,_iArray];
			iZones pushBackUnique _zone;
			_bi = ["Zombie_G_Walker_Civ","Zombie_G_Shambler_Civ","Zombie_G_Crawler_Civ","Zombie_G_RC_Civ"];
			While {Alive _zone} do {
				_iArray = missionNamespace getVariable _varName;
				if (_iZone && ({Alive _x} count _iArray <= _count) && _timer < TIMETOCLEAR) then {
					_pos = _zone call BIS_fnc_randomPosTrigger;
					_ano = selectRandom ALLOWEDINFECTIONS;
					_anoClass = "";
					_anoCount = 0;
					switch (_ano) do
					{
						case "BI" : {_anoClass = "basic";_anoCount = 10;};
						case "TB" : {
							if (dayTime < 8 && dayTime > 19) then {_anoClass = "dev_asymhuman_c";_anoCount = 2;}
							else {_anoClass = ""};
						};
						case "ST" : {_anoClass = "dev_form939_c";_anoCount = 2};
						case "SP" : {
							if (dayTime < 8 && dayTime > 19) then {_anoClass = "dev_toxmut_c";_anoCount = 2;}
							else {_anoClass = ""};
						};
						case "SC" : {
							_anoClass = "Zombie_Special_GREENFOR_Screamer";_anoCount = 1;
						};
						case "HE" : {
							if (dayTime < 8 && dayTime > 19) then {_anoClass = "WBK_SpecialZombie_Corrupted_1";_anoCount = 5;}
							else {_anoClass = ""};
						};
						case "BO" : {
							_anoClass = "Zombie_Special_GREENFOR_Boomer";_anoCount = 2;
						};
						case "BOSS" : {
							if (dayTime > 8 && dayTime < 19) then {_anoClass = "WBK_SpecialZombie_Smasher_1";_anoCount = 1;}
							else {_anoClass = ""};
						};
						case "PA" : {_anoClass = "dev_parasite_c";_anoCount = 5;}; 
						case "JU" : {
							if (dayTime < 8 && dayTime > 19) then {_anoClass = "dev_asymhuman_stage2_c";_anoCount = 1;}
							else {_anoClass = ""};
						};
					};	
					if (_anoClass != "") then {
						_zGroup = createGroup Civilian;
						if (_anoClass == "basic") then {
							for [{_i=0},{_i<_anoCount},{_i=_i+1}] do {
								_anoClass = selectRandom _bi;
								_zUnit = _zGroup createUnit [_anoClass, _pos, [], 0, "FORM"];
								_zUnit setVariable ["SFSM_Excluded", true, true];
								_iArray pushBackUnique _zUnit;
								missionNamespace setVariable [_varName,_iArray];
								_zUnit addEventHandler ["Killed", {
									{
										_iArray = _x select 1;
										if (_iArray find _unit >= 0) then {
											_zone = _x select 0;
											_varName = str(_zone) + "_GrArray";
											_iArray deleteAt (_iArray find _unit);
											missionNamespace setVariable [_varName,_iArray];
										};
									} foreach iZones;
								}];
								sleep 1;
							};
						} else {
							for [{_i=0},{_i<_anoCount},{_i=_i+1}] do {
								_zUnit = _zGroup createUnit [_anoClass, _pos, [], 0, "FORM"];
								_iArray pushBackUnique _zUnit;
								missionNamespace setVariable [_varName,_iArray];
							};
						};
					};
				};
				for [{_i=0},{_i<(count iZones)},{_i=_i+1}] do {
					_chZone = iZones select _i;
					if (_chZone == _zone) then {
						_areaPlayers = allPlayers select {alive _x && (_x inArea _zone || vehicle _x inArea _zone )};
						if (TIMETOCLEAR > _timer) then {
							_timer = _timer + _cd;
							_iZone = count _areaPlayers > 0;
						};
						if (_iZone && _timer > TIMETOCLEAR) then {
							MSQUADSUPPPOINTS = MSQUADSUPPPOINTS + 100;
							publicVariable "MSQUADSUPPPOINTS";
							[[east, "HQ"],"С.П.Е.К.Т.Р. вы успешно зачистили зону заражения, хорошая работа."] remoteExec ["sideChat", 0];
							deleteVehicle _zone;
						};
					};
				};
				sleep _cd;
			};
		};
	};			
///Спавн врат
AnoEnviroment_CreateStarGates= {
	params ["_count"];
	for [{_i=0},{_i<_count},{_i=_i+1}] do {
		_pos = [[[OPCENTRALZONE, OPZONERAD]], [[OSIRIS, 500],"water"]] call BIS_fnc_randomPos;
		[_pos] spawn AnoEnviroment_CreateStarGate;
	};
};

AnoEnviroment_CreateStarGate= {
	params ["_pos"];
	_gate = createVehicle ["sga_gate_orbital", _pos, [], 0, "NONE"];
	_dir = random 360;
	_gate setDir _dir;
	_gate setPos [_pos select 0, _pos select 1, (_pos select 2) - 2.5];
	_chance = random 100;
	if (_chance >= 50) then 
	{
		_dhdPos = _gate getRelPos [5, _dir];
		_dhd = createVehicle ["sga_dhd_simple", _dhdPos, [], 0, "NONE"];
		_dhd setDir _dir;
	};
};

//Грозовая зона
func_StartLightning = {
	params ["_center","_radius","_interval"];

	_objectTypes = ["Land_Loudspeakers_F", "Land_AncientPillar_F", "Land_BellTower_01_V1_F", "Land_BellTower_01_V2_F", "Land_LampAirport_off_F", "Land_LampAirport_F", "Land_LampHalogen_off_F", "Land_LampHalogen_F", "Land_LampStadium_F", "Land_Hospital_side2_F", "Land_LightHouse_F", "Land_Airport_Tower_F", "Land_Crane_F", "Land_HighVoltageColumn_F", "Land_HighVoltageTower_dam_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_largeCorner_F", "Land_PowerLine_distributor_F", "Land_ReservoirTank_Airport_", "Land_spp_Tower_F", "Land_Communication_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F", "Land_TTowerSmall_1_F", "Land_TTowerSmall_2_F", "Land_wpp_Turbine_V1_F", "Land_wpp_Turbine_V2_F", "Land_LampHarbour_off_F", "Land_LampHarbour_F", "Land_LampShabby_off_F", "Land_LampShabby_F", "Land_LampSolar_off_F", "Land_LampSolar_F", "Land_Offices_01_V1_F", "Land_Castle_01_tower_F", "Land_Hospital_main_F", "Land_Hospital_side1_F", "Land_Church_01_V1_F", "Land_cmp_Tower_F", "Land_dp_mainFactory_F", "Land_dp_smallTank_F", "Land_IndPipe2_big_ground1_F", "Land_IndPipe2_big_ground2_F", "Land_IndPipe2_bigL_L_F", "Land_IndPipe2_bigL_R_F", "Land_HighVoltageTower_large_F", "Land_PowerLine_part_F", "Land_PowerPoleConcrete_F", "Land_PowerPoleWooden_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V1_No1_F", "Land_Cargo_Tower_V1_No2_F", "Land_Cargo_Tower_V1_No3_F", "Land_Cargo_Tower_V1_No4_F", "Land_Cargo_Tower_V1_No5_F", "Land_Cargo_Tower_V1_No6_F", "Land_Cargo_Tower_V1_No7_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F", "Land_Stadium_p9_F"];
	_strikeCenter = [];
	_currentTarget = "";
	SHPLightningRun = true;
	publicVariableServer "SHPLightningRun";
	_centerPos = [];

	while {SHPLightningRun} do {
		if (typename _center == "STRING") then {_centerPos = markerpos _center};									// Check if _center is marker or object, get position.
		if (typename _center == "OBJECT") then {_centerPos = position _center};
		_buildingStrike = false;
		
		sleep random _interval;																					// Sleep defined by _interval.


		if (!_buildingStrike) Then {
			_randomx = (_centerPos select 0) + (_radius - (random (2*_radius)));										// Randomize _center X and Y axis.
			_randomY = (_centerPos select 1) + (_radius - (random (2*_radius)));
			_strikeCenter = [_randomx, _randomY, (_centerPos select 2)];
		};

		_dir =random 360;

		_bolt = createvehicle ["LightningBolt",_strikeCenter,[],0,"can_collide"];								// Create lightning sound and destruction.
		_bolt setposatl _strikeCenter;
		_bolt setDamage 1;																						// SetDamage required for proper lightning effect. Also does damage to strike location.

		_light = "#lightpoint" createvehiclelocal _strikeCenter;												// Create light flash effect.
		_light setposatl [_strikeCenter select 0,_strikeCenter select 1,(_strikeCenter select 2) + 10];
		_light setLightDayLight true;
		_light setLightBrightness 300;
		_light setLightAmbient [0.05, 0.05, 0.1];
		_light setlightcolor [1, 1, 2];
		sleep 0.1;
		_light setLightBrightness 0;
		sleep (random 0.1);

		_class = ["lightning1_F","lightning2_F"] call bis_Fnc_selectrandom;										// Choose and create visible lightning bolt object.
		_lightning = _class createvehiclelocal [100,100,100];
		_lightning setdir _dir;
		_lightning setpos _strikeCenter;

		_duration = random 2;																					// Keep bolt on screen for random duration. Also adds a second flash of light for a bit more realism.
		for "_i" from 0 to _duration do {
			_time = time + 0.1;
			_light setLightBrightness (100 + random 100);
			waituntil {time > _time};
		};
		deletevehicle _lightning;																				// Delete lightning bolt and light object.
		deletevehicle _light;

	};
};

//Остановка грозы
func_StopLightning = {
	SHPLightningRun = false;
	publicVariableServer "SHPLightningRun";
};

//Активация ЭМП
func_EMP = {
	params ["_logic", "_AOE"];
	playsound "earthquake_02";

	_bangsound= "#particlesource" createVehicleLocal getposatl _logic;
	_bangsound say3d ["up_impact",3500];
	_bangsound say3D ["final_boom",3500];
	_bangsound say3d ["echo1",3500];
	_bangsound say3d ["echo2",3500];

	_ripple = "#particlesource" createVehicleLocal getposatl _logic;
	_ripple setParticleCircle [0,[0,0,0]];
	_ripple setParticleRandom [0,[0.25,0.25,0],[0.175,0.175,0],0,0.25,[0,0,0,0.1],0,0];
	_ripple setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1], "", "Billboard", 1, 0.6, [0, 0, 0], [0, 0, 0],0,10,7.9,0, [10,0,25,50,100,150,210,250,325,400,475,550], [[1, 1, 1, 1], [1, 1, 1, 1]], [0.05], 1, 0, "", "", _logic];
	_ripple setDropInterval 50;


	_e_static2 = "#particlesource" createVehicleLocal getposatl _logic; 
	_e_static2 setParticleCircle [1.5, [0, 0, 0]];
	_e_static2 setParticleRandom [0.2, [3.5,3.5,0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 1], 1, 0]; 
	_e_static2 setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.05, [0, 0, 0], [0, 0, 0], 0, 10, 7.9,0, [1.15, 1.15, 1.15], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _logic]; 
	_e_static2 setDropInterval 0.015; 

	_light_emp = "#lightpoint" createVehiclelocal getposatl _logic; 
	_light_emp lightAttachObject [_logic, [0,0,3]];
	_light_emp setLightAmbient [0.1,0.1,1];  
	_light_emp setLightColor [0.1,0.1,1];
	_light_emp setLightBrightness 10;
	_light_emp setLightUseFlare true; _light_emp setLightFlareSize 10; _light_emp setLightFlareMaxDistance 2000;
	_light_emp setLightDayLight true;
	_light_emp setLightAttenuation [10,10,50,0,50,2000];
	_range_lit=0;
	_brit =0;

	while {_brit < 100} do 
	{
		_light_emp setLightBrightness _brit;
		_brit = _brit+2;
		sleep 0.01;
	};
	sleep 0.25;
	deleteVehicle _e_static2;
	deleteVehicle _ripple;
	deleteVehicle _light_emp;



	if (player distance _bangsound < 4000) then {
		sleep 2.5;
		_echosound = selectRandom ["echo1","echo2","echo3"];
		playSound _echosound;
	};




	{
	_x setHitPointDamage ["hitturret",1]; 
	_x setHitPointDamage ["hitcomturret",1]; 
	_x setHitPointDamage ["hitcomgun",1];
	_x setHitPointDamage ["HitBatteries",1]; 
	_x setHitPointDamage ["HitLight",1]; 
	_x setHitPointDamage ["#light_l",1];
	_x setHitPointDamage ["#light_r",1];
	_x setHitPointDamage ["#light_l_flare",1];
	_x setHitPointDamage ["#light_r_flare",1];
	_x setHitPointDamage ["light_l",1]; 
	_x setHitPointDamage ["light_r",1]; 
	_x setHitPointDamage ["light_l2",1]; 
	_x setHitPointDamage ["light_r2",1]; 
	_x setHitPointDamage ["hitEngine",1]; 
	_x setHitPointDamage ["HitEngine2",1]; 
	_x setHitPointDamage ["HitAvionics",1];
	_x disableTIEquipment true; 
	_x disableNVGEquipment true;
	_x setVariable ["A3TI_Disable", true];
	_x disableAI "LIGHTS"; 
	_x setPilotLight false;  
	_x setCollisionLight false;
	} forEach (nearestObjects [_logic, [
	"Car",
	"Motorcycle",
	"UAV",
	"Tank",
	"Air",
	"Ship",
	"Lamps",
	"Helicopter",
	"Plane",
	"Autonomous",
	"Armored",
	"B_static_AA_F", 
	"B_static_AT_F",
	"B_T_Static_AA_F",
	"B_T_Static_AT_F",
	"B_T_GMG_01_F",
	"B_T_HMG_01_F",
	"B_T_Mortar_01_F",
	"B_HMG_01_high_F",
	"B_HMG_01_A_F",
	"B_GMG_01_F",
	"B_GMG_01_high_F",
	"B_GMG_01_A_F",
	"B_Mortar_01_F",
	"B_G_Mortar_01_F",
	"B_Static_Designator_01_F",
	"B_AAA_System_01_F",
	"B_SAM_System_01_F",
	"B_SAM_System_02_F",
	"O_HMG_01_F",
	"O_HMG_01_high_F",
	"O_HMG_01_A_F",
	"O_GMG_01_F",
	"O_GMG_01_high_F",
	"O_GMG_01_A_F",
	"O_Mortar_01_F",
	"O_G_Mortar_01_F",
	"O_static_AA_F",
	"O_static_AT_F",
	"O_Static_Designator_02_F",
	"I_HMG_01_F",
	"I_HMG_01_high_F",
	"I_HMG_01_A_F",
	"I_GMG_01_F",
	"I_GMG_01_high_F",
	"I_GMG_01_A_F",
	"I_Mortar_01_F",
	"I_G_Mortar_01_F",
	"I_static_AA_F",
	"I_static_AT_F"
	], _AOE]); 



	{
	_spark_sound = ["spark1","spark11","spark2","spark22"] call BIS_fnc_selectRandom;
	_x say3D _spark_sound;
	_e_static = "#particlesource" createVehicleLocal (getPosATL _x);
	_e_static setParticleCircle [1.5, [0, 0, 0]];
	_e_static setParticleRandom [0.2, [3.5,3.5,0], [0.175, 0.175, 0], 0, 0.2, [0, 0, 0, 1], 1, 0];
	_e_static setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.05, [0, 0, 0], [0, 0, 0], 0, 10, 7.9,0, [0.003, 0.003], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _x];
	_e_static setDropInterval 0.025;
	sleep 0.5;
	deleteVehicle _e_static;
	} forEach (nearestObjects [_logic, [
	"Car",
	"Motorcycle",
	"UAV",
	"Tank",
	"Air",
	"Ship",
	"Autonomous",
	"Armored",
	"B_static_AA_F", 
	"B_static_AT_F",
	"B_T_Static_AA_F",
	"B_T_Static_AT_F",
	"B_T_GMG_01_F",
	"B_T_HMG_01_F",
	"B_T_Mortar_01_F",
	"B_HMG_01_high_F",
	"B_HMG_01_A_F",
	"B_GMG_01_F",
	"B_GMG_01_high_F",
	"B_GMG_01_A_F",
	"B_Mortar_01_F",
	"B_G_Mortar_01_F",
	"B_Static_Designator_01_F",
	"B_AAA_System_01_F",
	"B_SAM_System_01_F",
	"B_SAM_System_02_F",
	"O_HMG_01_F",
	"O_HMG_01_high_F",
	"O_HMG_01_A_F",
	"O_GMG_01_F",
	"O_GMG_01_high_F",
	"O_GMG_01_A_F",
	"O_Mortar_01_F",
	"O_G_Mortar_01_F",
	"O_static_AA_F",
	"O_static_AT_F",
	"O_Static_Designator_02_F",
	"I_HMG_01_F",
	"I_HMG_01_high_F",
	"I_HMG_01_A_F",
	"I_GMG_01_F",
	"I_GMG_01_high_F",
	"I_GMG_01_A_F",
	"I_Mortar_01_F",
	"I_G_Mortar_01_F",
	"I_static_AA_F",
	"I_static_AT_F"
	], _AOE]); 




	{
	_x setHit ["light_1_hitpoint", 0.97]; //all possible light hitpoints
	_x setHit ["light_2_hitpoint", 0.97]; //no lights escape this
	_x setHit ["light_3_hitpoint", 0.97];
	_x setHit ["light_4_hitpoint", 0.97];
	_bbr = boundingBoxReal vehicle _x;
	_p1 = _bbr select 0;
	_p2 = _bbr select 1;
	_maxHeight = abs ((_p2 select 2) - (_p1 select 2));

	//_spark_poz_rel = [getPos _lamp select 0,getPos _lamp select 1,_maxHeight-0.5];
	_spark_poz_rel = (_maxHeight/2)-0.45;

	_spark_type = ["white","orange"] call BIS_fnc_selectRandom;
	_spark_sound = ["spark1","spark11","spark2","spark22"] call BIS_fnc_selectRandom;
	_drop = 0.001+(random 0.05);
	_scantei_spark = "#particlesource" createVehicleLocal (getPosATL _x);

	if (_spark_type=="orange") then 
	{
		_scantei_spark setParticleCircle [0, [0, 0, 0]];
		_scantei_spark setParticleRandom [1, [0.1, 0.1, 0.1], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
		_scantei_spark setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1, [0, 0,_spark_poz_rel], [0, 0, 0], 0, 15, 7.9, 0, [0.5,0.5,0.05], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _x,0,true,0.3,[[0,0,0,0]]];
		_scantei_spark setDropInterval _drop;
	} else
	{
		//hint "alb";
		_scantei_spark setParticleCircle [0, [0, 0, 0]];
		_scantei_spark setParticleRandom [1, [0.05, 0.05, 0.1], [5, 5, 3], 0, 0.0025, [0, 0, 0, 0], 0, 0];
		_scantei_spark setParticleParams [["\A3\data_f\proxies\muzzle_flash\muzzle_flash_silencer.p3d", 1, 0, 1], "", "SpaceObject", 1, 1, [0, 0,_spark_poz_rel], [0, 0, 0], 0, 20, 7.9, 0, [0.5,0.5,0.05], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _x,0,true,0.3,[[0,0,0,0]]];
		_scantei_spark setDropInterval 0.001;
	};
	_scantei_spark say3D _spark_sound;
	sleep 0.4 + (random 0.7);
	deleteVehicle _scantei_spark;
	} forEach (nearestObjects [_logic, [
	"Lamps_base_F", //These are all the lights' base classes
	"PowerLines_base_F",
	"PowerLines_Small_base_F"
	], _AOE]);



	_gear = [
		'itemcTab',
		'itemMicroDAGR',
		'itemAndroid',
		'I_E_UavTerminal',
		'I_UavTerminal',
		'O_UavTerminal',
		'B_UavTerminal',
		'C_UavTerminal',
		'ItemGPS'
	];



	_nvgsw = [
		'WINTER_NVG_TI_GOOGLES',
		'NVGoggles',
		'Integrated_NVG_F',
		'NVGoggles_tna_F',
		'O_NVGoggles_grn_F',
		'O_NVGoggles_ghex_F',
		'O_NVGoggles_urb_F',
		'O_NVGoggles_hex_F',
		'NVGoggles_INDEP',
		'NVGoggles_OPFOR',
		'NVGoggles_mas_aus_h',
		'NVGoggles_mas_aus_hv',
		'UK3CB_PVS5A',
		'UK3CB_ANPVS7',
		'rhsusf_ANPVS15',
		'rhsusf_ANPVS14',
		'rhs_1PN138',
		'Integrated_NVG_TI_1_F',
		'Integrated_NVG_TI_0_F',
		'NVGogglesB_blk_F',
		'NVGogglesB_grn_F',
		'NVGogglesB_gry_F',
		'JAS_GPNVG18_Full_Tan_TI',
		'JAS_GPNVG18_Full_blk_TI',
		'JAS_GPNVG18_Tan_TI',
		'JAS_GPNVG18_blk_TI',
		'JAS_GPNVG18_Tan',
		'NVGoggles_mas_aus_hr',
		'ACE_NVG_Gen4',
		'ACE_NVG_Wide',
		'ACE_NVG_Gen1',
		'ACE_NVG_Gen2',
		'CUP_NVG_HMNVS',
		'CUP_NVG_PVS14',
		'CUP_NVG_GPNVG_black',
		'CUP_NVG_GPNVG_tan',
		'CUP_NVG_GPNVG_green',
		'CUP_NVG_GPNVG_winter',
		'CUP_NVG_PVS15_black',
		'CUP_NVG_PVS15_tan',
		'CUP_NVG_PVS15_green',
		'CUP_NVG_PVS15_winter',
		'LM_OPCAN_CAM',
		'LM_OPCAN_CAMSNI',
		'LM_OPCAN_CAMUA',
		'LM_OPCAN_COMM',
		'LM_OPCAN_CAMUA2',
		'LM_OPCAN_COMMCAM',
		'LM_OPCAN_COMMCAMSNI',
		'LM_OPCAN_COMMCAMUA2',
		'LM_OPCAN_COMMCAMUA',
		'LM_OPCAN_COMMUA',
		'LM_OPCAN_COMSNI',
		'LM_OPCAN_COMMUA2',
		'LM_OPCAN_FLA',
		'LM_OPCAN_FLACAMSNI',
		'LM_OPCAN_FLACAM',
		'LM_OPCAN_FLACAMUA',
		'LM_OPCAN_FLACAMUA2',
		'LM_OPCAN_FLASNI',
		'LM_OPCAN_FLAUA',
		'LM_OPCAN_SNI',
		'LM_OPCAN_FLAUA2',
		'LM_OPCAN_UA2',
		'LM_OPCAN_UA',
		'A3_TVG_S_F',
		'A3_TVG_S_F_CNM',
		'A3_TVG_S_F_HUL',
		'A3_TVG_S_F_HURS_CNM',
		'A3_TVG_S_F_HURS',
		'A3_TVG_S_F_MVI',
		'A3_TVG_S_F_HURS_HUL',
		'A3_TVG_S_F_MVI_CNM',
		'A3_TVG_S_F_MVI_HUL',
		'A3_TVG_S_F_MVI_UL',
		'A3_TVG_S_F_MVI_UL_CNM',
		'A3_TVG_S_F_MVI_UL_HUL',
		'A3_TVG_S_F_UA',
		'A3_TVG_S_F_UA_HUL',
		'A3_TVG_S_F_UA_CNM',
		'A3_TVG_S_F_UA_HURS',
		'A3_TVG_S_F_UA_HURS_CNM',
		'A3_TVG_S_F_UA_HURS_HUL',
		'A3_TVG_S_F_UA_UL',
		'A3_TVG_S_F_UAB',
		'A3_TVG_S_F_UA_UL_CNM',
		'A3_TVG_S_F_UAB_CNM',
		'A3_TVG_S_F_UAB_HUL',
		'A3_TVG_S_F_UAB_UL',
		'A3_TVG_S_F_UAB_UL_CNM',
		'A3_TVG_S_F_UAB_UL_HUL',
		'A3_TVG_S_F_UL',
		'A3_TVG_S_F_UL_CNM',
		'A3_TVG_S_F2',
		'A3_TVG_S_F_UL_HUL',
		'A3_TVG_S_F2_CNM',
		'A3_TVG_S_F2_HUL',
		'A3_TVG_S_F2_HURS',
		'A3_TVG_S_F2_HURS_HUL',
		'A3_TVG_S_F2_MVI',
		'A3_TVG_S_F2_MVI_CNM',
		'A3_TVG_S_F2_HURS_CNM',
		'A3_TVG_S_F2_MVI_HUL',
		'A3_TVG_S_F2_MVI_UL',
		'A3_TVG_S_F2_MVI_UL_HUL',
		'A3_TVG_S_F2_UA',
		'A3_TVG_S_F2_MVI_UL_CNM',
		'A3_TVG_S_F2_UA_HUL',
		'A3_TVG_S_F2_UA_CNM',
		'A3_TVG_S_F2_UA_HURS_HUL',
		'A3_TVG_S_F2_UA_HURS',
		'A3_TVG_S_F2_UA_HURS_CNM',
		'A3_TVG_S_F2_UA_UL',
		'A3_TVG_S_F2_UA_UL_CNM',
		'A3_TVG_S_F2_UAB',
		'A3_TVG_S_F2_UAB_CNM',
		'A3_TVG_S_F2_UAB_HUL',
		'A3_TVG_S_F2_UAB_UL',
		'A3_TVG_S_F2_UAB_UL_CNM',
		'A3_TVG_S_F2_UAB_UL_HUL',
		'A3_TVG_S_F2_UL',
		'A3_TVG_S_F2_UL_HUL',
		'A3_TVG_S_F2_UL_CNM',
		'A3_TVG_S_F3',
		'A3_TVG_S_F3_CNM',
		'A3_TVG_S_F3_HUL',
		'A3_TVG_S_F3_HURS',
		'A3_TVG_S_F3_HURS_CNM',
		'A3_TVG_S_F3_HURS_HUL',
		'A3_TVG_S_F3_MVI',
		'A3_TVG_S_F3_MVI_CNM',
		'A3_TVG_S_F3_MVI_HUL',
		'A3_TVG_S_F3_MVI_UL',
		'A3_TVG_S_F3_MVI_UL_HUL',
		'A3_TVG_S_F3_MVI_UL_CNM',
		'A3_TVG_S_F3_UA_CNM',
		'A3_TVG_S_F3_UA',
		'A3_TVG_S_F3_UA_HUL',
		'A3_TVG_S_F3_UA_HURS',
		'A3_TVG_S_F3_UA_HURS_CNM',
		'A3_TVG_S_F3_UA_HURS_HUL',
		'A3_TVG_S_F3_UA_UL',
		'A3_TVG_S_F3_UA_UL_CNM',
		'A3_TVG_S_F3_UAB',
		'A3_TVG_S_F3_UAB_HUL',
		'A3_TVG_S_F3_UAB_CNM',
		'A3_TVG_S_F3_UAB_UL',
		'A3_TVG_S_F3_UAB_UL_HUL',
		'A3_TVG_S_F3_UAB_UL_CNM',
		'A3_TVG_S_F3_UL',
		'A3_TVG_S_F3_UL_HUL',
		'A3_TVG_S_F3_UL_CNM',
		'A3_TVG_S_F45',
		'A3_TVG_S_F45_CNM',
		'A3_TVG_S_F45_HUL',
		'A3_TVG_S_F45_HURS',
		'A3_TVG_S_F45_HURS_CNM',
		'A3_TVG_S_F45_HURS_HUL',
		'A3_TVG_S_F45_MVI_CNM',
		'A3_TVG_S_F45_MVI',
		'A3_TVG_S_F45_MVI_HUL',
		'A3_TVG_S_F45_MVI_UL_CNM',
		'A3_TVG_S_F45_MVI_UL',
		'A3_TVG_S_F45_MVI_UL_HUL',
		'A3_TVG_S_F45_UA',
		'A3_TVG_S_F45_UA_CNM',
		'A3_TVG_S_F45_UA_HUL',
		'A3_TVG_S_F45_UA_HURS',
		'A3_TVG_S_F45_UA_HURS_CNM',
		'A3_TVG_S_F45_UA_HURS_HUL',
		'A3_TVG_S_F45_UA_UL',
		'A3_TVG_S_F45_UA_UL_CNM',
		'A3_TVG_S_F45_UAB',
		'A3_TVG_S_F45_UAB_CNM',
		'A3_TVG_S_F45_UAB_HUL',
		'A3_TVG_S_F45_UAB_UL',
		'A3_TVG_S_F45_UAB_UL_CNM',
		'A3_TVG_S_F45_UAB_UL_HUL',
		'A3_TVG_S_F45_UL_CNM',
		'A3_TVG_S_F45_UL',
		'A3_TVG_S_F45_UL_HUL',
		'A3_TVG_S_F6',
		'A3_TVG_S_F6_CNM',
		'A3_TVG_S_F6_HUL',
		'A3_TVG_S_F6_HURS_CNM',
		'A3_TVG_S_F6_HURS',
		'A3_TVG_S_F6_MVI',
		'A3_TVG_S_F6_HURS_HUL',
		'A3_TVG_S_F6_MVI_CNM',
		'A3_TVG_S_F6_MVI_HUL',
		'A3_TVG_S_F6_MVI_UL',
		'A3_TVG_S_F6_MVI_UL_CNM',
		'A3_TVG_S_F6_MVI_UL_HUL',
		'A3_TVG_S_F6_UA',
		'A3_TVG_S_F6_UA_CNM',
		'A3_TVG_S_F6_UA_HUL',
		'A3_TVG_S_F6_UA_HURS_HUL',
		'A3_TVG_S_F6_UA_HURS_CNM',
		'A3_TVG_S_F6_UA_HURS',
		'A3_TVG_S_F6_UA_UL',
		'A3_TVG_S_F6_UAB',
		'A3_TVG_S_F6_UA_UL_CNM',
		'A3_TVG_S_F6_UAB_CNM',
		'A3_TVG_S_F6_UAB_HUL',
		'A3_TVG_S_F6_UAB_UL',
		'A3_TVG_S_F6_UAB_UL_CNM',
		'A3_TVG_S_F6_UAB_UL_HUL',
		'A3_TVG_S_F6_UL',
		'A3_TVG_S_F6_UL_CNM',
		'A3_TVG_S_F7',
		'A3_TVG_S_F6_UL_HUL',
		'A3_TVG_S_F7_HUL',
		'A3_TVG_S_F7_CNM',
		'A3_TVG_S_F7_HURS',
		'A3_TVG_S_F7_HURS_CNM',
		'A3_TVG_S_F7_HURS_HUL',
		'A3_TVG_S_F7_MVI',
		'A3_TVG_S_F7_MVI_CNM',
		'A3_TVG_S_F7_MVI_UL',
		'A3_TVG_S_F7_MVI_HUL',
		'A3_TVG_S_F7_MVI_UL_CNM',
		'A3_TVG_S_F7_MVI_UL_HUL',
		'A3_TVG_S_F7_UA',
		'A3_TVG_S_F7_UA_HUL',
		'A3_TVG_S_F7_UA_CNM',
		'A3_TVG_S_F7_UA_HURS',
		'A3_TVG_S_F7_UA_HURS_CNM',
		'A3_TVG_S_F7_UA_UL',
		'A3_TVG_S_F7_UA_HURS_HUL',
		'A3_TVG_S_F7_UA_UL_CNM',
		'A3_TVG_S_F7_UAB',
		'A3_TVG_S_F7_UAB_CNM',
		'A3_TVG_S_F7_UAB_HUL',
		'A3_TVG_S_F7_UAB_UL_CNM',
		'A3_TVG_S_F7_UAB_UL',
		'A3_TVG_S_F7_UAB_UL_HUL',
		'A3_TVG_S_F7_UL',
		'A3_TVG_S_F7_UL_CNM',
		'A3_TVG_S_F7_UL_HUL',
		'A3_TVG_S_F8',
		'A3_TVG_S_F8_CNM',
		'A3_TVG_S_F8_HUL',
		'A3_TVG_S_F8_HURS_CNM',
		'A3_TVG_S_F8_HURS',
		'A3_TVG_S_F8_HURS_HUL',
		'A3_TVG_S_F8_MVI',
		'A3_TVG_S_F8_MVI_CNM',
		'A3_TVG_S_F8_MVI_UL_CNM',
		'A3_TVG_S_F8_MVI_UL',
		'A3_TVG_S_F8_MVI_HUL',
		'A3_TVG_S_F8_MVI_UL_HUL',
		'A3_TVG_S_F8_UA',
		'A3_TVG_S_F8_UA_CNM',
		'A3_TVG_S_F8_UA_HUL',
		'A3_TVG_S_F8_UA_HURS',
		'A3_TVG_S_F8_UA_HURS_CNM',
		'A3_TVG_S_F8_UA_HURS_HUL',
		'A3_TVG_S_F8_UA_UL',
		'A3_TVG_S_F8_UAB',
		'A3_TVG_S_F8_UA_UL_CNM',
		'A3_TVG_S_F8_UAB_CNM',
		'A3_TVG_S_F8_UAB_UL',
		'A3_TVG_S_F8_UAB_UL_CNM',
		'A3_TVG_S_F8_UAB_HUL',
		'A3_TVG_S_F8_UAB_UL_HUL',
		'A3_TVG_S_F8_UL',
		'A3_TVG_S_F8_UL_CNM',
		'A3_TVG_S_F8_UL_HUL',
		'OPCOS_NV_C',
		'OPCOS_NV_CM',
		'OPCOS_NV_A',
		'OPCOS_NV_AC',
		'OPCOS_NV_ACM',
		'OPCOS_NV_AM',
		'OPTRE_NVG',
		'OPCOS_NV_M',
		'OPTRE_FC_NVG',
		'VES_NVG_CNM',
		'VES_NVG_UL',
		'VES_NVG_HUL',
		'VES_NVG_HURS',
		'VES_NVG_HURS_CNM',
		'VES_NVG_HURS_HUL',
		'VES_NVG_MVI',
		'VES_NVG_MVI_HUL',
		'VES_NVG_MVI_UL_CNM',
		'VES_NVG_MVI_UL',
		'VES_NVG_MVI_CNM',
		'VES_NVG_MVI_UL_HUL',
		'VES_NVG_UA_CNM',
		'VES_NVG_UA_HUL',
		'VES_NVG_UA_HURS',
		'VES_NVG_UA_HURS_CNM',
		'VES_NVG_UA_HURS_HUL',
		'VES_NVG_UA_UL',
		'VES_NVG_UA_UL_CNM',
		'VES_NVG_UAB_CNM',
		'VES_NVG_UAB_HUL',
		'VES_NVG_UAB_UL',
		'VES_NVG_UAB_UL_CNM',
		'VES_NVG_UAB_UL_HUL',
		'VES_NVG_UL_CNM',
		'VES_NVG_UL_HUL',
		'VES_NVG_Collar',
		'VES_NVG_UA',
		'VES_NVG_UAB',
		'VES_NVG_Collar_VAC'																									
	];

	_binos = [
		'Rangefinder',
		'Laserdesignator',
		'Laserdesignator_02_ghex_F',
		'Laserdesignator_02',
		'Laserdesignator_01_khk_F',
		'Laserdesignator_03',
		'rhsusf_bino_lerca_1200_black',
		'rhsusf_bino_lerca_1200_tan',
		'rhs_pdu4',
		'ACE_Vector',
		'ACE_VectorDay',
		'ACE_Yardage450',
		'ACE_MX2A',
		'CUP_Vector21Nite',
		'CUP_SOFLAM',
		'CUP_LRTV',
		'CUP_Binocular_Vector',
		'CUP_Laserdesignator',
		'CUP_LRTV_ACR',
		'OPTRE_Binoculars',
		'OPTRE_Smartfinder'		
	];




	{							
		if(alive _x) then {
					
			_itemsUnit = assignedItems _x;
			_commonItemsArray = ((_nvgsw + _binos + _gear) arrayIntersect _itemsUnit);
			_nvg = _commonItemsArray select 0;
			if(!isNil '_nvg') then {
				_x unassignItem _nvg;
				_x removeItem _nvg;
				_x removeWeapon _nvg;
			};
		};
	} forEach (nearestObjects [_logic, [
	"Civilian",
	"SoldierGB",
	"SoldierEB",
	"SoldierWB"
	], _AOE]); 

	sleep 0.05;
	{							
		if(alive _x) then {
					
			_itemsUnit = assignedItems _x;
			_commonItemsArray = ((_nvgsw + _binos + _gear) arrayIntersect _itemsUnit);
			_nvg = _commonItemsArray select 0;
			if(!isNil '_nvg') then {
				_x unassignItem _nvg;
				_x removeItem _nvg;
				_x removeWeapon _nvg;
			};
		};
	} forEach (nearestObjects [_logic, [
	"Civilian",
	"SoldierGB",
	"SoldierEB",
	"SoldierWB"
	], _AOE]); 

	sleep 0.05;
	{							
		if(alive _x) then {
					
			_itemsUnit = assignedItems _x;
			_commonItemsArray = ((_nvgsw + _binos + _gear) arrayIntersect _itemsUnit);
			_nvg = _commonItemsArray select 0;
			if(!isNil '_nvg') then {
				_x unassignItem _nvg;
				_x removeItem _nvg;
				_x removeWeapon _nvg;
			};
		};
	} forEach (nearestObjects [_logic, [
	"Civilian",
	"SoldierGB",
	"SoldierEB",
	"SoldierWB"
	], _AOE]); 

	sleep 0.05;
	{							
		if(alive _x) then {
					
			_itemsUnit = assignedItems _x;
			_commonItemsArray = ((_nvgsw + _binos + _gear) arrayIntersect _itemsUnit);
			_nvg = _commonItemsArray select 0;
			if(!isNil '_nvg') then {
				_x unassignItem _nvg;
				_x removeItem _nvg;
				_x removeWeapon _nvg;
			};
		};
	} forEach (nearestObjects [_logic, [
	"Civilian",
	"SoldierGB",
	"SoldierEB",
	"SoldierWB"
	], _AOE]); 
	sleep 0.05;

	{
	_x removePrimaryWeaponItem "rh_anpvs13cl";
	_x removePrimaryWeaponItem "rh_anpvs13cmg";
	_x removePrimaryWeaponItem "rh_anpvs13cm ";
	_x removePrimaryWeaponItem "rh_anpvs13ch";
	_x removePrimaryWeaponItem "rh_anpvs10";
	_x removePrimaryWeaponItem "rh_anpvs4";
	_x removePrimaryWeaponItem "optic_nightstalker";
	_x removePrimaryWeaponItem "optic_nvs";
	_x removePrimaryWeaponItem "optic_tws";
	_x removePrimaryWeaponItem "optic_tws_mg";
	_x removePrimaryWeaponItem "rhsusf_acc_anpvs27";
	_x removePrimaryWeaponItem "rhsusf_acc_anpas13gv1";
	_x removePrimaryWeaponItem "rh_peq2_top";
	_x removePrimaryWeaponItem "rh_peq15b_top";
	_x removePrimaryWeaponItem "rh_peq2";
	_x removePrimaryWeaponItem "rh_peq15b";
	_x removePrimaryWeaponItem "rh_peq15";
	_x removePrimaryWeaponItem "ace_acc_pointer_green";
	_x removePrimaryWeaponItem "sma_anpeq15_blk";
	_x removePrimaryWeaponItem "sma_anpeq15_tan";
	_x removePrimaryWeaponItem "rhs_acc_perst3";
	_x removePrimaryWeaponItem "rhs_acc_perst1ik_ris";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq16a_light_top";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq16a_top";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq16a_light";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq16a";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15A";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15_bk_light";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15_bk";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15_light";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15_bk_top";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15side_bk";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15_wmx_light";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15_wmx";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15_top";
	_x removePrimaryWeaponItem "rhsusf_acc_anpeq15side";
	_x removePrimaryWeaponItem "acc_pointer_IR";
	_x removePrimaryWeaponItem "CUP_optic_GOSHAWK";
	_x removePrimaryWeaponItem "CUP_optic_GOSHAWK_RIS";
	_x removePrimaryWeaponItem "CUP_optic_NSPU";
	_x removePrimaryWeaponItem "CUP_optic_AN_PVS_4";
	_x removePrimaryWeaponItem "CUP_optic_AN_PVS_4_M14";
	_x removePrimaryWeaponItem "CUP_optic_AN_PVS_4_M16";
	_x removePrimaryWeaponItem "CUP_optic_AN_PVS_10";
	_x removePrimaryWeaponItem "CUP_optic_AN_PAS_13c1";
	_x removePrimaryWeaponItem "CUP_optic_AN_PAS_13c2";
	_x removePrimaryWeaponItem "CUP_optic_CWS";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Black";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_OD";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Tan_Top";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Black_Top";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_OD_Top";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_camo";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_desert";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_grey";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Black_Top";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_OD_Top";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Coyote_Top";
	_x removePrimaryWeaponItem "CUP_acc_MLPLS_Laser";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Flashlight_Black_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Flashlight_Black_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Flashlight_Coyote_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Flashlight_Coyote_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Flashlight_OD_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_2_Flashlight_OD_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Tan_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Tan_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_OD_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_OD_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Black_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Black_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Top_Flashlight_Tan_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Top_Flashlight_Tan_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Top_Flashlight_OD_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Top_Flashlight_OD_F";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Top_Flashlight_Black_L";
	_x removePrimaryWeaponItem "CUP_acc_ANPEQ_15_Top_Flashlight_Black_F";
	_x removePrimaryWeaponItem "OPTRE_M45_Flashlight";
	_x removePrimaryWeaponItem "OPTRE_M12_Laser";
	_x removePrimaryWeaponItem "OPTRE_M45_Flashlight_red";
	_x removePrimaryWeaponItem "OPTRE_M6C_Laser";
	_x removePrimaryWeaponItem "OPTRE_M6D_Flashlight";
	_x removePrimaryWeaponItem "OPTRE_M6G_Flashlight";
	_x removePrimaryWeaponItem "OPTRE_M7_Flashlight";
	_x removePrimaryWeaponItem "OPTRE_M7_Laser";
	_x removePrimaryWeaponItem "OPTRE_BMR_Laser";
	_x removePrimaryWeaponItem "OPTRE_BMR_Flashlight";
	_x removePrimaryWeaponItem "OPTRE_DMR_Light"																								
	} forEach (nearestObjects [_logic, [
	"Civilian",
	"SoldierGB",
	"SoldierEB",
	"SoldierWB"
	], _AOE]); 


	{
		_unitradio = assignedItems _x select {_x call BIS_fnc_itemType select 1 == "Radio"} param [0, ""];
		_x unassignItem _unitradio;
		_x removeItem _unitradio;
		_x removeWeapon _unitradio;																						
	} forEach (nearestObjects [_logic, [
	"Civilian",
	"SoldierGB",
	"SoldierEB",
	"SoldierWB"
	], _AOE]); 



	sleep 1;

	deleteVehicle _bangsound;
};