G_ENEMYFORCES_Init = {
ENEMYFACTIONS = [];
	_readyModules = (allMissionObjects "ALL") select {typeOf _x == "ALIVE_mil_OPCOM"};
	{
		_module = _x;
		[_module,1000, 75]  remoteExec ["ENEMYFORCES_createjammer",2];
		_factionsString = _module getVariable ["factions", []];
		_factionsArray = _factionsString splitString ",";
		{
			if (ENEMYFACTIONSEXCL find _x < 0) then {
				ENEMYFACTIONS pushBackUnique [_x,0];
			};
		} forEach _factionsArray;
	} forEach _readyModules;
};

//Генерация и работа с глушилками
ENEMYFORCES_createjammer = {
	params ["_location","_rad","_strength"];
	_flocation = [getPos _location, 0, 1500, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	_jammer = "SatelliteAntenna_01_Black_F" createVehicle _flocation;
	_jammer setDir (random 360);
	_flocation = [_flocation, 0, 50, 10, 0, 20, 0] call BIS_fnc_findSafePos;
	_jammer = "Land_DataTerminal_01_F" createVehicle _flocation;
	_jammer setDir (random 360);
	JamersArray pushbackUnique _jammer;
	_jammer = call ENEMYFORCES_jammerDist;
	_rad = param [1, 1000, [0]];
	_strength = param [2, 50, [0]] - 1; // Minus one so that radio interference never goes below 1 near the edge of the radius (which is the default for TFAR).
	// While the Jamming Vehicle is not destroyed, loop every 5 seconds
	while {alive _jammer} do
	{
		// Set variables
		_dist = player distance _jammer;
		_distPercent = _dist / _rad;
		_interference = 1;
		_sendInterference = 1;

		if (_dist < _rad) then {
			_interference = _strength - (_distPercent * _strength) + 1; // Calculat the recieving interference, which has to be above 1 to have any effect.
			_sendInterference = 1/_interference; //Calculate the sending interference, which needs to be below 1 to have any effect.
		};
		// Set the TF receiving and sending distance multipliers
		player setVariable ["tf_receivingDistanceMultiplicator", _interference];
		player setVariable ["tf_sendingDistanceMultiplicator", _sendInterference];
		
		// Sleep 5 seconds before running again
		sleep 5.0;
		
		//Only run this if there are multiple jammers.
		if (count JamersArray > 1) then {
			//Check if all of the jammers are still alive. If not, remove it from JamersArray.
			{
				if (!alive _x AND count JamersArray > 1) then {JamersArray = JamersArray - [_x]};
			} foreach JamersArray;
		
			//Check for closest jammer
			_jammer = call ENEMYFORCES_jammerDist;
		};
	};

	//Set TFR settings back to normal before exiting the script
	player setVariable ["tf_receivingDistanceMultiplicator", 1];
	player setVariable ["tf_sendingDistanceMultiplicator", 1];
	[_jammer, 1] call Signal_CreateEmitter;
	[
	_jammer,											// Object the action is attached to
	"Выключить терминал",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",						// Condition for the action to be shown
	"_caller distance _target < 3",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		[_target] remoteExec ["ENEMYFORCES_destroyjammer",2];
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS + 50;
		publicVariable "MSQUADSUPPPOINTS";
		[[east, "HQ"],"С.П.Е.К.Т.Р. вы накрыли радиоглушилку."] remoteExec ["sideChat", 0];
	},				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	5,													// Action duration [s]
	0,													// Priority
	false,												// Remove on completion
	false												// Show in unconscious state 
	] remoteExec ["BIS_fnc_holdActionAdd", 0, _jammer];	// MP compatible implementation
	_jammer;
};
ENEMYFORCES_jammerDist = {
	_jammer = objNull;
	_closestDist = 1000000;
	{
		if (_x distance player < _closestdist) then {
			_jammer = _x;
			_closestDist = _x distance player;
		};
	} foreach JamersArray;
	_jammer;
};
ENEMYFORCES_destroyjammer = {
	params ["_jammer"];
	private _jamsource = nearestObject [_jammer,"Land_HelipadEmpty_F"];			//the sound effect source
	private _jamDamage = getDammage _jammer;									//the jammers current damage
	private _jamPos = getPos _jammer;											//jammers position
	private _jamDir = getDir _jammer;
	deleteVehicle _jamsource;													//stops the sound effect
	_jammer setDamage 0.75;														//set damage to trigger L.22 in jammer_Check.sqf
	[_jammer,"green","green","green"] call BIS_fnc_DataTerminalColor;			//aesthetics
	[_jammer,0] call BIS_fnc_dataTerminalAnimate;								//animate the box to Close
	[_jammer,["power_down",25,1]] remoteExec ["say3D",0];						//play the power down sound effect 
	sleep 4;																	//delay script for 4 seconds
	_jamDummy = "Land_DataTerminal_01_F" createVehicle [0,0,0];					//spawn a 'dummy' data terminal
	_jamDummy setDir _jamDir;													//face the dummy in the same direction as jammer
	_jamDummy setPos _jamPos;													//position dummy in jammers spot
	deleteVehicle _jammer;														//delete jammer to stop jamming (dummy in place)

	{
		_x setVariable ["tf_receivingDistanceMultiplicator", 1];
		_x setVariable ["tf_transmittingDistanceMultiplicator", 1];	
	} forEach allPlayers;
};