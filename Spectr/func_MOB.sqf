//Перчивная установка
G_CampInit = {
	BASEMACHINES = [];
	sleep 1;
	CampEstablished = false;
	remoteExecCall ["L_Bases_Update_PCs", 0];
	{
		_logic = [_x, 1] call G_Signal_CreateEmitter;
		_logic attachTo [_x];
	} forEach AllPlayers;
	PlayerStategems = [];
	[] spawn CSATFORCES_ACCEPTIONS;
	[] spawn G_Base_OpChecks;
	[] spawn strats_equip_backpack;
	PlayersStrategemList = [];
	_notEastUnits = (allUnits inAreaArray TaskTrigger_Finish) select {side _x != east && alive _x};
	_SDG = createGroup EAST;
	{
		[_x] joinSilent _SDG;
	} forEach _notEastUnits;
	{
		_owner = owner _x;
		PlayersStrategemList = missionNamespace getVariable ["PlayersStrategemList",[]];
		PlayersStrategemList pushBackUnique [_owner,[["Призыв","strats_call_Summon",["u","d","r","l","u"]]]];
		missionNamespace setVariable ["PlayersStrategemList", PlayersStrategemList, true];
		publicVariable "PlayersStrategemList";
	} forEach AllPlayers;
	{
		_light = "#lightpoint" createVehicle [(getpos _x select 0),(getpos _x select 1),(getpos _x select 2)];
		_light setLightBrightness 5;
		_light setLightAmbient[0.5,0.75,0.85];
		_light setLightColor[0.5,0.75,0.85];
		_light lightAttachObject [_x, [0,0,0]];	
	} forEach [LightSource_1,LightSource_2,LightSource_3,LightSource_4,LightSource_5,LightSource_6,LightSource_7,LightSource_8,LightSource_9,LightSource_10];
};

//Проверка на наличие взрывчатки поблизости и ее детонация
L_CHECKNEARVIED = {
    params ["_player", "_IEDs", "_distanceThreshold"];
    private _playerPosition = if (vehicle _player == _player) then {
        getPosATL _player
    } else {
        getPosATL (vehicle _player)
    };
    {
        private _IEDpos = getPosATL _x;
        if (_playerPosition distance _IEDpos < _distanceThreshold) exitWith {
            // Если игрок находится ближе, чем на _distanceThreshold метров к IED, детонируйте IED
            _x setDamage 1;
        };
    } forEach _IEDs;
};

//Проверка на события для активации стратагем
L_Strats_Check = {
	params["_player"];
	
	sleep 3;
	
	blockedInput = false;
	_player setVariable ['blockedInput', blockedInput, true];
	_clOwner = owner _player;
	
	strategemList = [
	["Призыв","strats_call_Summon",["u","d","r","l","u"]],
	["Машина: Квадроцикл","strats_call_Vehicle",0,["u","u","u"]],
	["Машина: Буран","strats_call_Vehicle",1,["u","u","d","l","r"]],
	["Машина: Квадра Мститель","strats_call_Vehicle",2,["u","u","l","l","l"]],
	["Машина: Квадра Ктулху","strats_call_Vehicle",3,["u","u","r","r","r"]],
	["Техника: Каратель","strats_call_BattleVehicle",2,["u","u","d","r","r","u"]],
	["Техника: Марид","strats_call_BattleVehicle",3,["u","u","d","r","l","u"]],
	["Техника: БТР-500","strats_call_BattleVehicle",4,["u","u","l","r","l","r","u"]],
	["Техника: РСЗО","strats_call_BattleVehicle",5,["u","u","l","r","l","r","u"]],
	["Техника: САУ","strats_call_BattleVehicle",6,["u","u","l","r","r","d","d"]],
	["Техника: ЗСУ","strats_call_BattleVehicle",7,["u","u","l","l","r","r","u"]],
	["Техника: Т-100","strats_call_BattleVehicle",8,["u","u","d","l","r","d","d"]],
	["Техника: Тайфун","strats_call_BattleVehicle",9,["u","u","d","l","d"]],
	["Техника: Лодка","strats_call_BattleVehicle",10,["u","u","d","d","d"]],
	["Техника: Дрон","strats_call_BattleVehicle",11,["u","u","d","d","d"]],
	["Прототип: Ховер-МРС","strats_call_BattleVehicle",12,["d","d","r","r","u","r","l","r"]],
	["Прототип: Подземник","strats_call_BattleVehicle",13,["d","d","l","l","d","r","r","l"]],
	["Прототип: Мамонт-танк","strats_call_BattleVehicle",14,["d","d","l","r","r","l","d","d"]],
	["Прототип: Мех","strats_call_BattleVehicle",15,["d","d","l","r","l","r","u","u"]],
	["Помощь: Рюкзак связи","strats_call_Equipment",0,["u","d","l","r","r","l"]],
	["Помощь: Джетпак","strats_call_Equipment",1,["u","d","u","u","d"]],
	["Помощь: Антенна слежения","strats_call_Equipment",2,["u","d","l","r","l","u"]],
	["Помощь: Боерипасы","strats_call_Equipment",3,["u","d","l","r","u","u"]],
	["Помощь: Медснабжение","strats_call_Equipment",4,["u","d","u","u","u"]],
	["Помощь: Легкий авто-пулемет","strats_call_Equipment",5,["u","d","r","r","l","u","d"]],
	["Помощь: Тяжелый авто-пулемет","strats_call_Equipment",6,["u","d","r","r","r","d","d"]],
	["Оружие: Разрывная винтовка","strats_call_Equipment",7,["u","d","r","r","r","d","u","d"]],
	["Оружие: Электрошокер","strats_call_Equipment",8,["u","d","l","u","d","r","l","r"]],
	["Оружие: Крупнокалиберка","strats_call_Equipment",9,["u","d","r","r","u","r","d","l"]],
	["Оружие: Гранатомет","strats_call_Equipment",10,["u","d","l","u","r","d","l","r"]],
	["Оружие: Магнитная винтовка","strats_call_Equipment",11,["u","d","r","l","l","r","l","r"]],
	["Оружие: Тяжелый пулемет","strats_call_Equipment",12,["u","d","u","d","u","d","u","d"]],
	["Оружие: Дробовик","strats_call_Equipment",13,["u","d","u","r","r","l","l","d"]],
	["Оружие: Рельсотрон","strats_call_Equipment",14,["u","d","d","d","d","u","u","u"]],
	["Поддержка: Отряд поддержки","strats_call_Support",0,["u","d","l","l","r"]],
	["Поддержка: Вертолетное прикрытие","strats_call_Support",1,["u","d","d","d","l","r","r","l"]],
	["Налет: Кластерные","strats_call_AirStrike",0,["u","r","d","r","r"]],
	["Налет: Бомбы","strats_call_AirStrike",1,["u","r","d","r","u"]],
	["Налет: Шива","strats_call_AirStrike",2,["u","r","d","d","d"]],
	["Налет: Зажигательный","strats_call_AirStrike",3,["u","r","d","l","l"]],
	["Обстрел: 82мм","strats_call_ArtStrike",0,["u","d","l","u"]],
	["Обстрел: 155мм","strats_call_ArtStrike",1,["u","d","l","d","u","r"]],
	["Обстрел: 220мм","strats_call_ArtStrike",2,["u","d","l","r","d","u","r","r"]],
	["Обстрел: 380мм","strats_call_ArtStrike",3,["u","d","l","l","d","d","l","l","l","u"]],
	["Обстрел: Мины","strats_call_ArtStrike",4,["u","d","r","r","r"]],
	["Удар: Ионный","strats_call_OrbitalStrike",0,["r","r","u","d","u","d","l"]],
	["Удар: ЭМИ","strats_call_OrbitalStrike",1,["r","r","l","l","r"]],
	["Удар: Точечный","strats_call_OrbitalStrike",2,["r","r","r"]],
	["Сбор: Контейнер ресурсов","strats_drop_support",0,["d","d","d"]]
	];
	
	sleep 3;
	
	PlayersStrategemList = missionNamespace getVariable ["PlayersStrategemList",[]];
	ActivePlayersOwners = missionNamespace getVariable ["ActivePlayersOwners",[]];
	if (count (ActivePlayersOwners select {_x == _clOwner}) == 0) then
	{
		PlayersStrategemList pushBackUnique [_clOwner,[["Призыв","strats_call_Summon",["u","d","r","l","u"]]]];
		ActivePlayersOwners pushBackUnique _clOwner;
		missionNamespace setVariable ["PlayersStrategemList", PlayersStrategemList, true];
		missionNamespace setVariable ["ActivePlayersOwners", ActivePlayersOwners, true];
		publicVariable "PlayersStrategemList";
		publicVariable "ActivePlayersOwners";
	};
	[_player] spawn Strategem_check;
};

Strategem_check = {
	params["_player"];
	_player addAction
	[
	"Вызов статагем",
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			call L_ShowStrategems;
		},
		nil,		
		0.25,		
		true,		
		false,		
		"",			
		"_originalTarget getVariable['SWA',false]"
	];
	
	_player addEventHandler ["FiredMan", {
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
		if (_ammo == "O_IRStrobe") then {
			_data = _unit getVariable ['activeStrategema',[]];
			_unit addItemToUniform "O_IR_Grenade";
			if (!(_data isEqualTo [])) then {
				[_projectile,_data,_unit] remoteExec ["Stratagem_Processing",2];
				[_projectile] remoteExec ["Stratagem_Processing_FX",0];
			};
		};
	}];
	
	_player addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		[_unit] spawn Strategem_check;
		[_unit] remoteExec ["drop_on_call",2];
	}];	
	
	while {true} do {
		if (((currentThrowable _player) select 0) == "O_IR_Grenade") then {
			_player setVariable ['SWA',true,true];
		}
		else
		{
			_player setVariable ['SWA',false,true];
		};
		sleep 1;
	};
};

Stratagem_Processing_FX = {
	params["_projectile"];
	_raza = "#particlesource" createVehicleLocal (getpos _projectile);
	_raza setParticleCircle [0.1, [0, 0, 0]];
	_raza setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 17, [0, 0, 0], [0, 0, 5], 0, 9, 9, 0, [0.5,0.0], [[1,0,0, 1], [1,0.9,0.5, 1], [1,0.9,0.5,0]],[0.08], 1, 0, "", "", _projectile];
	_raza setDropInterval 0.002;
	
	_li1 = "#lightpoint" createVehicle [(getpos _projectile select 0),(getpos _projectile select 1),(getpos _projectile select 2)];
	_li1 setLightBrightness 2;
	_li1 setLightAmbient[1,0,0];
	_li1 setLightColor[1,0,0];
	_li1 lightAttachObject [_projectile, [0,0,0]];
	sleep 15;
	deleteVehicle _projectile;
	deleteVehicle _raza;
	deleteVehicle _li1;
};

//Функция на обработку стратегемы
Stratagem_Processing = {
	params["_projectile","_data","_player"];
	sleep 5;
	_player addItemToUniform "O_IR_Grenade";
	GlobalTimer = missionNamespace getVariable ["GlobalTimer",1800];
	_inRangeCarrier = ((getPos _projectile) distance2D (getPos SuperCarrier)) <= 1500;
	_checkBackpacks = AllPlayers select {backpack _x == "WINTER_RADIOBAG_HEX"};
	_inRangeBackpacks = count (_checkBackpacks select {((getPos _projectile) distance2D (getPos _x)) <= 500}) > 0;
	_inRangeOsiris = ((getPos _projectile) distance2D (getPos Osiris)) <= 250;
	_carrierOnLowOrbit = GlobalTimer >= 0;
	
	if ((_inRangeOsiris || _inRangeBackpacks || _inRangeCarrier) && _carrierOnLowOrbit) then
	{
		_code = _data select 1;
		_type = _data select 2;
		[(getPos _projectile), _type] remoteExec [_code,2];
		sleep 10;
	} else {
		[[east, "HQ"],"Запрос на поддержку не одобрен. Вы вне зоны наведения капсул."] remoteExec ["sideChat", 0];
	};

	_data = _player setVariable ['activeStrategema',[]];
};

//Принудительное обновление активаторов
L_Bases_Update_PCs = {
	[CentralConsole] remoteExec ["removeAllActions", 0];
	[Osiris] remoteExec ["removeAllActions", 0];
	[OsirisControl] remoteExec ["removeAllActions", 0];
	[OsirisControl, [
		"Добавить стратегемы",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			call L_AddStrategems;
		},
		nil,		
		3,		
		true,		
		false,		
		"",			
		""
	]] remoteExec ["addAction", 0];
	[OsirisControl, [
		"Убрать стратегемы",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			call L_RemoveStrategems;
		},
		nil,		
		3,		
		true,		
		false,		
		"",			
		""
	]] remoteExec ["addAction", 0];
	[OsirisControl, [
		"Просмотр стратегем",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			call L_ShowStrategems;
		},
		nil,		
		3,		
		true,		
		false,		
		"",			
		""
	]] remoteExec ["addAction", 0];
	[OsirisControl, [
		"Переключить магнит",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			[] spawn G_MagnetMode;
		},
		nil,		
		3,		
		true,		
		false,		
		"",			
		""
	]] remoteExec ["addAction", 0];
	[OsirisControl, [
		"Запрос подкреплений",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			call L_Support_Tickets;
		},
		nil,		
		3,		
		true,		
		false,		
		"",			
		""
	]] remoteExec ["addAction", 0];
	[OsirisControl, [
		"Запрос продления",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			call L_Support_Continuation;
		},
		nil,		
		3,		
		true,		
		false,		
		"",			
		""
	]] remoteExec ["addAction", 0];
	[Osiris, [
		"Сброс пода",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			[_caller] remoteExec ["drop_on_call",2];
		},
		nil,		
		3,		
		true,		
		false,		
		"",			
		""
	]] remoteExec ["addAction", 0];
};

//Переключение магнита Осириса
G_MagnetMode = {
	_magnetTarget = OSIRIS getVariable ["MagnetState",false];
	if (_magnetTarget) then 
	{
		_target = OSIRIS getVariable ["MagnetObject",objNull];
		OSIRIS setVariable ["MagnetState", false,true];
		OSIRIS setVariable ["MagnetObject", objNull,true];
		_target enableSimulationGlobal true; 
		detach _target;
	} 
	else 
	{
		_target = nearestObjects [MagnetStartPos, ["Air", "Car", "Motorcycle", "Tank"], 10];
		_target = _target select {_x != OSIRIS};
		if (count (_target) > 0) then 
		{
			_targetObject = selectRandom _target;
			_targetObject enableSimulationGlobal false; 
			_pos = [((getPosATL MagnetStartPos) select 0),((getPosATL MagnetStartPos) select 1),((getPosATL MagnetStartPos) select 2) + 3];
			_targetObject setDir (getDir OSIRIS);
			_targetObject setPosATL _pos;
			_targetObject attachTo [OSIRIS];
			OSIRIS setVariable ["MagnetState", true,true];
			OSIRIS setVariable ["MagnetObject", _targetObject,true];
		} 
	};
};

//Выбрать стратагему на добавление
L_AddStrategems = {
	createDialog "CSADialog";
	{
		_strat = _x;
		_name = _strat select 0;
		if (_name != "Призыв") then {
			lbAdd [1502, _name];
		}
	} forEach strategemList;
};

//Добавить стратагему
L_StratagemAdd = {
	_index = (lbCurSel 1502) + 1;
	_clOwner = owner player;
	PlayersStrategemList = missionNamespace getVariable ["PlayersStrategemList",[]];
	{
		_playerComposition = _x;
		_playerId = _playerComposition select 0;
		if (_playerId == _clOwner) then 
		{
			_playerStratsList  = _playerComposition select 1;
			if (count (_playerStratsList) < 5) then {
				_playerComposition deleteAt 1;
				_strategem = strategemList select _index;
				_playerStratsList pushBackUnique _strategem;
				PlayersStrategemList deleteAt (PlayersStrategemList find _playerComposition);
				_playerComposition pushBackUnique _playerStratsList;
				PlayersStrategemList pushBackUnique _playerComposition;
				_name = _strategem select 0;
				missionNamespace setVariable ["PlayersStrategemList", PlayersStrategemList];
				[[east, "HQ"],format ["Принято. Готовим для вас выбранную стратагему:%1. Готово:%2", _name,count(_playerStratsList)-1]] remoteExec ["sideChat", _clOwner];
			} else {
				[[east, "HQ"],"Агент, мы не можем выдать вам больше стратегем."] remoteExec ["sideChat", _clOwner];
			};
		};
	}
	foreach PlayersStrategemList;
};

//Выбрать стратагему на удаление
L_RemoveStrategems = {
	createDialog "CSRDialog";
	_clOwner = owner player;
	{
		_playerComposition = _x;
		_playerId = _playerComposition select 0;
		if (_playerId == _clOwner) then 
		{
			_playerStratsList  = _playerComposition select 1;
			{
				_name = _x select 0;
				if (_name != "Призыв") then {
					lbAdd [1503, _name];
				}
			} forEach _playerStratsList;
		};
	} forEach PlayersStrategemList;
};

//Убрать стратагему
L_StratagemRemove = {
	_index = lbCurSel 1503;
	_clOwner = owner player;
	PlayersStrategemList = missionNamespace getVariable ["PlayersStrategemList",[]];
	{
		_playerComposition = _x;
		_playerId = _playerComposition select 0;
		if (_playerId == _clOwner) then 
		{
			_playerStratsList  = _playerComposition select 1;
			if (count (_playerStratsList) > 1) then {
				_strategem = _playerStratsList select _index;
				_playerComposition deleteAt 1;
				_playerStratsList deleteAt (_playerStratsList find _strategem);
				PlayersStrategemList deleteAt (PlayersStrategemList find _playerComposition);
				_playerComposition pushBackUnique _playerStratsList;
				PlayersStrategemList pushBackUnique _playerComposition;
				_name = _strategem select 0;
				[[east, "HQ"], format ["Принято. Убираем для вас выбранную стратагему:%1. Осталось:%2", _name,count(_playerStratsList)-1]] remoteExec ["sideChat", _clOwner];
				missionNamespace setVariable ["PlayersStrategemList", PlayersStrategemList];
			} else {
				[[east, "HQ"],"Агент, у вас и так нет выбранных стратегем."] remoteExec ["sideChat", _clOwner];
			};
		};
	}
	foreach PlayersStrategemList;
};

//Показ и ввод стратагем
L_ShowStrategems = {
	createDialog "CSSDialog";
	_clOwner = owner player;
	
	InputCode = [];
	foundedCodes = [];
	moduleName_keyDownEHIds	= (findDisplay 46) displayAddEventHandler ["KeyUp", { _this spawn L_Stratagems_AddKey}];
	{
		_playerComposition = _x;
		_playerId = _playerComposition select 0;
		if (_playerId == _clOwner) then 
		{
			_playerStratsList  = _playerComposition select 1;
			_idArray = [1511,1512,1513,1514];
			_index = 0;
			{
				_name = _x select 0;
				_id = _idArray select _index;
				if (_name != "Призыв") then {
					_code = [(_x select (count(_x)-1))] call StrategemCodeProc;
					ctrlSetText [_id, _name];
					ctrlSetText [_id+5, _code];
					_index = _index + 1;
				} else {
					_code = [(_x select (count(_x)-1))] call StrategemCodeProc;
					ctrlSetText [1515, _name];
					ctrlSetText [1520, _code];
				}
			} forEach _playerStratsList;
		};
	} forEach PlayersStrategemList;
};

//Дешивровка кода стратегем
StrategemCodeProc = {
	params["_code"];
	_assemblyString = "";
	{
		switch (_x) do {
			case "u": {_assemblyString = _assemblyString + "↑    ";};
			case "d": {_assemblyString = _assemblyString + "↓    ";};
			case "l": {_assemblyString = _assemblyString + "←    ";};
			case "r": {_assemblyString = _assemblyString + "→    ";};
			default {};
		};
	} forEach _code;
	_assemblyString;
};

//Функция на ввод кода стратегем
L_Stratagems_AddKey = {
	params ["_ctrl", "_dikCode", "_shift", "_ctrlKey", "_alt"];
	private _keyCode = "";

	if (_dikCode == 205) then {_keyCode = "r";};
	if (_dikCode == 203) then {_keyCode = "l";};
	if (_dikCode == 208) then {_keyCode = "d";};
	if (_dikCode == 200) then {_keyCode = "u";};
	
	blockedInput = player getVariable ['blockedInput', false];
	
	if (_keyCode != "" && !blockedInput) then {
		blockedInput = true;
		player setVariable ['blockedInput', blockedInput, true];
		InputCode pushBack _keyCode;
		_keyCode = "";
		
		_playerStratsList = [];
		_clOwner = owner player;
		
		{
			_playerComposition = _x;
			_playerId = _playerComposition select 0;
			if (_playerId == _clOwner) then 
			{
				_playerStratsList  = _playerComposition select 1;
			};
		} forEach PlayersStrategemList;
		foundedCodes = _playerStratsList;
		_tempCodes = [];
		{
			_code = (_x select (count(_x)-1));
			{
				if ((InputCode select [0,count(InputCode)]) isEqualTo (_code select [0,count(InputCode)])) then
				{
					_tempCodes pushBackUnique _code;
				}
			} forEach _code;
		} forEach foundedCodes;
		foundedCodes = _tempCodes;
		{
			_foundedCode = _x;
			_greenCode = _foundedCode select [0,count(InputCode)];
			_lefCode = _foundedCode select [count(InputCode),count(_foundedCode) - count(InputCode)];
			_greenString = [_greenCode] call StrategemCodeProc;
			_leftString = [_lefCode] call StrategemCodeProc;
			_newText = "<t color='#00ff00'>" + _greenString + "</t>" + _leftString;
			_textCodes = [1516,1517,1518,1519,1520];
			{
				_index = _x;
				_code = ctrlText _index;
				if (_code isEqualTo ([_foundedCode] call StrategemCodeProc)) then
				{
					_control = displayCtrl _index;
					_control ctrlSetStructuredText parseText _newText;
				}
			} forEach _textCodes;
			
			if (InputCode isEqualTo _foundedCode) then {
				//Стратегема активна
				(findDisplay 46) displayRemoveEventHandler ["KeyUp", moduleName_keyDownEHIds];
				_textCodes = [1511,1512,1513,1514,1515];
				{
					_index = _x;
					_foundedStratText = ctrlText _index;
					_code = ctrlText (_index + 5);
					_newText = "<t color='#00ff00'>" + _foundedStratText + "</t>";
					if (_code isEqualTo ([_foundedCode] call StrategemCodeProc)) then
					{
						_control = displayCtrl _index;
						_control ctrlSetStructuredText parseText _newText;
						{
							_strat = _x;
							_checkText = _strat select 0;
							if (_foundedStratText == _checkText) then {
								hint _checkText;
								player setVariable ['activeStrategema', _strat, true];
								break;
							};
						} foreach strategemList;
					}
				} forEach _textCodes;
			};
		} forEach foundedCodes;
		
		sleep 0.25;
		
		blockedInput = false;
		player setVariable ['blockedInput', blockedInput, true];
		//Если стратегема вбита вся, активировать ее (установить переменную игрока индекс стратегемы из листа стратегем)
	};
};

//Функция кода вызова поддержки
strats_call_Summon = {
	params ["_pos","_type"];
	_grpToDep = AllPlayers select {[_x] inAreaArray TriggerToDeploy || _x in Osiris};
	[[east, "HQ"],"Запрос на подкрепление одобрен. Готовим поды."] remoteExec ["sideChat", 0];
	{
		_dropPos = [_pos, 10, 15, 1, 0, 20, 0] call BIS_fnc_findSafePos;
		[_dropPos, 0, _x] remoteExec ["StrategemDropProcessing",2];
		sleep 0.5;
	} forEach _grpToDep;
};

//Функция сброса пода при респавне
drop_on_respawn = {
	params ["_unit"];
	sleep 1;
	moveOut _unit;
	sleep 1;
	_dropPos = [getPos Osiris, 10, 15, 1, 0, 20, 0] call BIS_fnc_findSafePos;
	[_dropPos, 0, _unit] remoteExec ["StrategemDropProcessing",2];
};

//Функция сброса пода-эвакуации
drop_on_call = {
	params ["_unit"];
	sleep 1;
	moveOut _unit;
	sleep 2;
	[getPos Osiris, 9, _unit] remoteExec ["StrategemDropProcessing",2];
};

//Функция на группу "Техника и Прототипы"
strats_call_Vehicle = {
	params["_pos","_index"];
	if (MSQUADSUPPPOINTS >= 100) then {
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 100;
		publicVariable "MSQUADSUPPPOINTS";
		_vehType = "";
		switch (_index) do {
				case 0: {_vehType = "QUADBIKE_WINTER_HEX";};
				case 1: {_vehType = "MM_Buran_APC6";};
				case 2: {_vehType = "Quadra_Type_66_Avenger";};
				case 3: {_vehType = "Quadra_Type_66_Cthulhu";};
				default {};
		};
		[_pos,1,_vehType] spawn StrategemDropProcessing;
	} else {
		[[east, "HQ"],"Запрос на технику не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};
};

//Функция на группу "Техника и Прототипы"
strats_call_BattleVehicle = {
	params["_pos","_index"];
	if (MSQUADSUPPPOINTS >= 100) then {
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 100;
		publicVariable "MSQUADSUPPPOINTS";
		_vehType = "";
		switch (_index) do {
				case 0: {_vehType = "QUADBIKE_WINTER_HEX";};
				case 1: {_vehType = "MM_Buran_APC6";};
				case 2: {_vehType = "IFRIT_GMG_WINTER_HEX";};
				case 3: {_vehType = "MSE_MARID_WINTER_HEX";};
				case 4: {_vehType = "CSAT_WINTER_APC";};
				case 5: {_vehType = "TOS_SUN_WINTER_HEX";};
				case 6: {_vehType = "SOCHOR_WINTER_HEX";};
				case 7: {_vehType = "ZSU39_TIGRIS_WINTER_HEX";};
				case 8: {_vehType = "T100_VARSUK_WINTER_HEX";};
				case 9: {_vehType = "TEMPEST_MEDICAL_WINTER_HEX";};
				case 10: {_vehType = "CSAT_WINTER_BOAT";};
				case 11: {_vehType = "K40_ABABIL_WINTER_HEX";};
				case 12: {_vehType = "TG_DevilTongue_NOD_01";};
				case 13: {_vehType = "CSAT_WINTER_PROTO_Hover_01_F";};
				case 14: {_vehType = "HTNK";};
				case 15: {_vehType = "ROM_AWGS_HMCS_Xanthic_X1";};
				default {};
		};
		[_pos,1,_vehType] spawn StrategemDropProcessing;
	} else {
		[[east, "HQ"],"Запрос на технику не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};
};

//Функция на группу "Налет"
strats_call_AirStrike = {
	params ["_targetPos","_type"];
	if (MSQUADSUPPPOINTS > 10) then {
		[[east, "HQ"],"Запрос на бомбежку одобрен, птичка в пути."] remoteExec ["sideChat", 0];
		_SUPPSPAWNPOINT = [_targetPos, 500, 1000, 5, 0, 20, 0] call BIS_fnc_findSafePos;
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 10;
		publicVariable "MSQUADSUPPPOINTS";
		_squadGrp = grpNull;
		_spawnRadius = 1500;
		_planeType = "CSAT_WINTER_PLANE";
		_bombType = "";
		_bombsCount = 1;
		
		switch (_type) do
		{
			case 0 : {_bombType = "DMNS_Bomb_cluster_AP";	_bombsCount = 10;};	
			case 1 : {_bombType = "Bo_GBU12_LGB";	_bombsCount = 10;};	
			case 2 : {_bombType = "DMNS_Shiva_Nuclear";	_bombsCount = 1;};	
			case 3 : {_bombType = "Napalm_GBU12Ammo_F";	_bombsCount = 4;};	
		};
			
		// Генерируем случайную позицию вокруг цели для создания самолета
		private _angle = random 360;
		private _spawnPos = [_targetPos, _spawnRadius, _angle] call BIS_fnc_relPos;
		_spawnPos set [2, 300]; // Высота для самолета

		// Создаем самолет
		_result = [_spawnPos, 0, _planeType, east] call BIS_fnc_spawnVehicle;
		_plane = _result select 0;
		_planeGRP = _result select 2;
		_plane setPos _spawnPos;
		_plane setFuel 1;
		_plane engineOn true;
		_plane setDir (_angle - 180);
		_plane flyInHeight 300;
		_planeGRP setBehaviour "SAFE";
		_planeGRP setCombatBehaviour "CARELESS";
		_planeGRP setCombatMode "BLUE";
		
		// Планирование пути
		private _waypoint = _planeGRP addWaypoint [_targetPos, 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointSpeed "FULL";

		// Когда самолет достигает точки, сбрасываем бомбы
		if (_type == 0) then 
		{
			waitUntil {((getPos _plane) distance2D _targetPos) < 1000};
		}	
		else 
		{
			if (_type == 3) then 
			{
				waitUntil {((getPos _plane) distance2D _targetPos) < 650};
			}	
			else 
			{
				waitUntil {((getPos _plane) distance2D _targetPos) < 750};
			};
		};
		
		for "_i" from 1 to _bombsCount do {
			private _bomb = createVehicle [_bombType, getPos _plane, [], 0, "CAN_COLLIDE"];
			_bomb setDir (getDir _plane);
			_bomb setPos (getPos _plane);
			xForce = (sin getDir _bomb) * 100;
			yForce = (cos getDir _bomb) * 100;
			_bomb SetVelocity [xForce,yForce,-100];
			sleep 0.25/_bombsCount; // Задержка между каждой бомбой
			if (_type == 2) then {
				waitUntil {((getPosATL _bomb) select 2  < 5)};
				[getPosATL _bomb, 0.5, false, true, 1] execVM "freestyleNuke\iniNuke.sqf";
			}
		};

		// Даем самолету новую точку для ухода после бомбардировки
		_targetPos = _targetPos vectorAdd [(_spawnRadius * 2) * cos(_angle), (_spawnRadius * 2) * sin(_angle), 0];
		_waypoint = group _plane addWaypoint [_targetPos, 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointSpeed "FULL";
		
		waitUntil {sleep 1; currentWaypoint _planeGRP == 3};
		
		{deleteVehicle _x } forEach crew _plane;
		deleteVehicle _plane;
	} 
	else 
	{
		[[east, "HQ"],"Запрос на поддержку не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};
};

//Функция на группу "Обстрел"
strats_call_ArtStrike = {
	params ["_pos", "_type"];
	if (MSQUADSUPPPOINTS > 50) then {
		[[east, "HQ"],"Запрос на арт-удар одобрен."] remoteExec ["sideChat", 0];
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 50;
		publicVariable "MSQUADSUPPPOINTS";
		_rounds = 30; 
		_area = 100; 
		_ammo = ""; 
		_del=3;
		switch (_type) do
		{
			case 0 : {_rounds = 30; _area = 50; _ammo = "Sh_82mm_AMOS"; _del=0.5;};	
			case 1 : {_rounds = 40; _area = 75; _ammo = "Sh_155mm_AMOS"; _del=1;};	
			case 2 : {_rounds = 50; _area = 100; _ammo = "OPTRE_Sh_175mm_HE"; _del=1.5;};	 
			case 3 : {_rounds = 60; _area = 125; _ammo = "R_230mm_HE"; _del=2;};	
			case 4 : {_rounds = 20; _area = 25; _ammo = "Mine_155mm_AMOS_range"; _del=0.5;};	
		};
		sleep 10;
		if (_type != 4) then 
		{
			[_pos, _ammo, _area, _rounds, _del, {false}, 0, 500, 300] spawn BIS_fnc_fireSupportVirtual;
		}
		else 
		{
			[_pos, "Mine_155mm_AMOS_range", _area, _rounds, _del,{ false },0,500,300] spawn BIS_fnc_fireSupportVirtual;
			[_pos, "AT_Mine_155mm_AMOS_range", _area, _rounds, _del,{ false },0,500,300] spawn BIS_fnc_fireSupportVirtual;
		}
	} else {
		[[east, "HQ"],"Запрос на арт-удар не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};
};

//Функция на группу "Удар"
strats_call_OrbitalStrike = {
	params["_pos","_type"];
	if (MSQUADSUPPPOINTS > 50) then {
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 100;
		publicVariable "MSQUADSUPPPOINTS";
		[[east, "HQ"],"Запрос на орбитальный удар одобрен."] remoteExec ["sideChat", 0];
		switch (_type) do
		{
			case 0 : {
						_target = "Land_HelipadEmpty_F" createVehicle _pos;
						[_target,[1,0.6,0.2],[0.3,0.27,0.15],true,50,100] remoteExec ["TTS_BEAM_fnc_beam",0]
					};	
			case 1 : {[_pos, "EMP_230mm_Cluster", 0, 1, 1,{ false },0,500,300] spawn BIS_fnc_fireSupportVirtual;};	
			case 2 : {[_pos, "DMNS_B_50mm_HE", 10, 150, 0.1,{ false },0,500,300] spawn BIS_fnc_fireSupportVirtual;};	
		};
	}
	else
	{
		[[east, "HQ"],"Запрос на орбитальный удар не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};
};

//Функция на группу "Поддержка"
strats_call_Support = {
	params["_pos","_type"];
	if (MSQUADSUPPPOINTS > 150) then {
		_SUPPSPAWNPOINT = [_pos, 1000, 1500, 5, 0, 20, 0] call BIS_fnc_findSafePos;
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 150;
		publicVariable "MSQUADSUPPPOINTS";
		_squadGrp = grpNull;
		switch (_type) do {
			[[east, "HQ"],"Запрос на поддержку одобрен. К указанной позиции выдвинулась боевая группа."] remoteExec ["sideChat", 0];
			case 0: {
				_grp = configfile >> "CfgGroups" >> "East" >> "CSAT_Winter" >> "Infantry" >> "VIPER_TEAM_WINTER_HEX";
				_squadGrp = [_SUPPSPAWNPOINT, east, _grp] call BIS_fnc_spawnGroup;
				{
					_dropPos = [_pos, 10, 15, 1, 0, 20, 0] call BIS_fnc_findSafePos;
					[_dropPos, 0, _x] spawn StrategemDropProcessing;
					sleep 0.5;
				} 
				forEach units _squadGrp;
				_newWP = _squadGrp addWayPoint [_pos, 0];
				_newWP setWaypointType "SAD";
			};
			case 1: {
				_grp = configfile >> "CfgGroups" >> "East" >> "CSAT_Winter" >> "Air" >> "MI48_SECTION_HEX";
				_squadGrp = [_SUPPSPAWNPOINT, east, _grp] call BIS_fnc_spawnGroup;
				_newWP = _squadGrp addWayPoint [_pos, 0];
				_newWP setWaypointType "SAD";
			};	
			default {};
		};
	} 
	else 
	{
		[[east, "HQ"],"Запрос на поддержку не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};
};

//Функция на группу "Оружие и экипировка"
strats_call_Equipment = {
	params["_pos","_type"];
	if (MSQUADSUPPPOINTS > 100) then {
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 100;
		publicVariable "MSQUADSUPPPOINTS";
		_content = [];
		switch (_type) do {
				case 0: {_content = ["WINTER_RADIOBAG_HEX"];_type = 5;};
				case 1: {_content = ["OPTRE_S12_SOLA_Jetpack"];_type = 5;};
				case 2: {_content = ["OPTRE_ANPRC_515"];_type = 5;};
				case 3: {_type = 3};
				case 4: {_type = 4};
				case 5: {_content = ["CSAT_WINTER_BACKPACK_HMG_A_HEX","CSAT_WINTER_BACKPACK_AMG_HEX"];_type = 5;};
				case 6: {_content = ["CSAT_WINTER_BACKPACK_GMG_A_HEX","CSAT_WINTER_BACKPACK_AMG_HEX"];_type = 5;};
				case 7: {_content = ["WRS_Weapon_Sniper","WRS_Sniper_Magazine_AP","WRS_Sniper_Magazine_AP","WRS_Sniper_Magazine_AP","WRS_Sniper_Magazine_AP","WRS_Sniper_Magazine_AP"];};
				case 8: {_content = ["WRS_Weapon_ShockGun_NoGLow","WRS_Shockgun_Magazine","WRS_Shockgun_Magazine","WRS_Shockgun_Magazine","WRS_Shockgun_Magazine","WRS_Shockgun_Magazine"];};
				case 9: {_content = ["OPTRE_M99A2S3","OPTRE_7Rnd_20mm_APFSDS_Mag","OPTRE_7Rnd_20mm_APFSDS_Mag","OPTRE_7Rnd_20mm_APFSDS_Mag","OPTRE_7Rnd_20mm_APFSDS_Mag","OPTRE_7Rnd_20mm_APFSDS_Mag"];};
				case 10: {_content = ["TG_GDI_Demolisher","TG_GDI_Scope_03","TG_GDI_Demolisher_Magazine","TG_GDI_Demolisher_Magazine","TG_GDI_Demolisher_Magazine","TG_GDI_Demolisher_Magazine","TG_GDI_Demolisher_Magazine"];};
				case 11: {_content = ["TG_NOD_Ripper_Rifle","TG_NOD_Scope_02","TG_NOD_Ripper_RT_Magazine","TG_NOD_Ripper_RT_Magazine","TG_NOD_Ripper_RT_Magazine","TG_NOD_Ripper_RT_Magazine","TG_NOD_Ripper_RT_Magazine"];};
				case 12: {_content = ["OPTRE_M247H_Shield_Etilka","OPTRE_200Rnd_127x99_M247H_Etilka","OPTRE_200Rnd_127x99_M247H_Etilka","OPTRE_200Rnd_127x99_M247H_Etilka"];};
				case 13: {_content = ["OPTRE_CQS48_Bulldog_Automatic","OPTRE_12Rnd_12Gauge_HE","OPTRE_12Rnd_12Gauge_HE","OPTRE_12Rnd_12Gauge_HE","OPTRE_12Rnd_12Gauge_HE","OPTRE_12Rnd_12Gauge_HE"];};
				case 14: {_content = ["TG_GDI_Railgun_Rifle","TG_GDI_Scope_02","TG_GDI_Railgun_Magazine","TG_GDI_Railgun_Magazine","TG_GDI_Railgun_Magazine","TG_GDI_Railgun_Magazine","TG_GDI_Railgun_Magazine"];};
				default {};
		};
		if (_type != 3 && _type != 4 && _type != 5) then {_type = 2;};
		[_pos, _type, _content] spawn StrategemDropProcessing;
	} 
	else 
	{
		[[east, "HQ"],"Запрос на экипировку не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};	
};

strats_drop_support = {
	params["_pos","_type"];
	[_pos,8,[]] spawn StrategemDropProcessing;
};

//Функция на обработку рюкзаков-БПЛА (точечно раз в 10 секунд шмаляет по противнику на 0.20 урона в радиусе 100м)
strats_equip_backpack = {
	while {true} do {
		{
			_targetPlayer = _x;
			if ("OPTRE_ANPRC_515" == backpack _targetPlayer) then
			{
				// Проверка, что БПЛА кружит на игроком, иначе создать и назначить атакующим дроном
				_targetBPLA = objNull;
				_preDrones = getPos _targetPlayer nearEntities [["DMNS_UAV_01_F"], 100];
				_drones = _preDrones select {_x getVariable ["activePlayer",""] == str(_targetPlayer)};
				if (count (_drones) > 0) then {
					_targetBPLA = selectRandom _drones;
					_targetBPLA flyInHeight [2, true];
				}
				else 
				{
					_targetBPLA = ([getPos _targetPlayer, getDir _targetPlayer, "DMNS_UAV_01_F", EAST] call bis_fnc_spawnvehicle) select 0;
					_makePos = getPosATL _targetPlayer;
					_makePos set [2, (_makePos select 2) + 2];
					_targetBPLA setPosATL _makePos;
					_targetBPLA attachTo [_targetPlayer];
					_targetBPLA setVariable ["activePlayer",str(_targetPlayer),true];
				};
				_targetPreList = getPos _targetBPLA nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"], 100];
				_targetList = _targetPreList select {side _x != east && side _x != civilian && alive _x};
				if (count _targetList > 0 && objNull != _targetBPLA) then {
					_targetToHit = selectRandom _targetList;
					[_targetBPLA,_targetToHit,_targetPlayer] spawn strats_bpla_attack;
				};
			}
			else
			{
				_preDrones = getPos _targetPlayer nearEntities [["DMNS_UAV_01_F"], 1000];
				_drones = _preDrones select {_x getVariable ["activePlayer",""] == str(_targetPlayer)};
				{
					deleteVehicle _x;
				} forEach _drones;
			};
		} forEach AllPlayers;
		sleep 10; 
	};
};

//Функция атаки БПЛА на противинка
strats_bpla_attack = {
	params["_targetBPLA","_targetToHit","_targetPlayer"];
	_timer = 1;
	detach _targetBPLA;
	while {_timer > 0} do {
		_targetBPLA flyInHeight [2, true];
		_pos1 = getPosATL _targetBPLA;
		_pos2 = getPosATL _targetToHit;
		_pos1 set [2, (_pos1 select 2) + 0.1];
		_pos2 set [2, (_pos2 select 2) + 1];
		drawLine3D [_pos1, _pos2, [1,0,0,0.25]];
		sleep 0.01;
		_timer = _timer - 0.01;
		_targetBPLA setDir ([_targetBPLA, _targetToHit] call BIS_fnc_dirTo);
	};
	_makePos = getPosATL _targetPlayer;
	_makePos set [2, (_makePos select 2) + 2];
	_targetBPLA setPosATL _makePos;
	_targetBPLA attachTo [_targetPlayer];
	_targetToHit setDamage ((damage _targetToHit) + 0.2);
};

//Фунцкия обработки падения дроп-пода
StrategemDropProcessing = {
	params["_pos","_type","_content"];
	_pod = "Helldiver_Drop_Pod" createVehicle _pos;
	_pod setVariable ["DOS_P_Pod_Launched", true];
	
	if (_type == 0) then {_content moveInAny _pod};
	
	_pos set [2, 2500]; // Высота для пода
	if (_type == 9) then {_pos set [2, ((getPosASL Osiris) select 2) - 50];};
	_pod setPos _pos;
	
	if (_type == 9) then {_content moveInAny _pod; _type = 0;};

	waitUntil { getPos _pod select 2 > 2000 };
	waitUntil { getPos _pod select 2 < 2000 };

	playSound3D ["A3\Sounds_F\environment\ambient\battlefield\battlefield_explosions5.wss", _pod, false, getPosASL _pod, 4, 4, 0];
	if ((driver _pod isEqualTo player) OR (player in (crew _pod))) then {addCamShake [2,1000,5];};
	_fireball = createVehicle ["test_EmptyObjectForFireBig", [0, 0, 0], [], 0, "CAN_COLLIDE"];
	_fireball attachTo [_pod, [0,0,0]];

	waitUntil { getPos _pod select 2 < 1000 };

	_impact = "Hellpod_ImpactAmmo" createVehicle [0,0,10000];
	_impact attachTo [_pod, [0,0,0], "attach_point"];
	_impact setVectorDirAndUp [[0,0,-1], [-1,0,-1]];
	_impact disableCollisionWith _pod;

	waitUntil { (!alive _impact) || getPosATL _pod select 2 < 1 || isTouchingGround _pod };

	playSound3D ["A3\Sounds_F\sfx\missions\vehicle_collision.wss", _pod];
	_pod setVelocity [0,0,0];
	_pod setVectorUp surfaceNormal position _pod;
	removeAllActions _pod;
	deleteVehicle _fireball;
	_pod setVectorDirAndUp [[0,1,0],[0,0,0]];
	resetCamShake;
	sleep 0.5;
	if (getPosATL _pod select 2 < 0) then { _pod setPosATL [(getPosATL _pod select 0), (getPosATL _pod select 1), 0.2]; };
	
	waitUntil {((count (fullCrew [_pod, "cargo"])) + (count (fullCrew [_pod, "driver"]))) < 1;};
	//Обработка заказа
	switch (_type) do {
			case 0: {moveOut(driver _pod)};
			case 1: {
						_veh = _content createVehicle getPosATL _pod;
						_veh setPosATL (getPosATL _pod);
					};
			case 2: {
						_fromPos =  [(((getPosATL _pod) select 0) - 0.822),(((getPosATL _pod) select 1)),(((getPosATL _pod) select 2) - 3)];
						_toPos =  [((_fromPos select 0) - 0.822),((_fromPos select 1)),((_fromPos select 2) + 3)];
						_ePod = "SESP" createVehicle _fromPos; 
						_ePod setPosATL _fromPos;
						_ePod setDir 0;
						_Pod setDir 0;
						sleep 3;
						{
							_epod addItemCargoGlobal [_x, 1];
						} forEach _content;
						[_ePod,_toPos,1,false] spawn G_MoveObject;
						
					};
			case 3: {
						_fromPos =  [(((getPosATL _pod) select 0)),(((getPosATL _pod) select 1)),(((getPosATL _pod) select 2) - 6)];
						_toPos =  [((_fromPos select 0)),((_fromPos select 1)),((_fromPos select 2) + 6)];
						_ePod = "OPTRE_Ammo_SupplyPod_Empty" createVehicle _fromPos; 
						_ePod enableSimulationGlobal false; 
						[_ePod, false] call ace_dragging_fnc_setDraggable; 
						[_ePod, false] call ace_dragging_fnc_setCarryable; 
						_ePod setPosATL _fromPos;
						_ePod setDir 0;
						_Pod setDir 0;
						sleep 3;
						[_ePod, ["ACE_10Rnd_762x67_Berger_Hybrid_OTM_Mag","ACE_10Rnd_762x67_Mk248_Mod_0_Mag","ACE_10Rnd_762x67_Mk248_Mod_1_Mag","10Rnd_338_Mag","ACE_10Rnd_338_300gr_HPBT_Mag","ACE_10Rnd_338_API526_Mag","130Rnd_338_Mag","WNZ_EMP408_Mag","7Rnd_408_Mag","ACE_7Rnd_408_305gr_Mag","11Rnd_45ACP_Mag","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_Tracer_Green","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow","6Rnd_45ACP_Cylinder","9Rnd_45ACP_Mag","10Rnd_50BW_Mag_F","WNZ_EMP50BW_Mag","OPTRE_1000Rnd_762x51_Box_Tracer","OPTRE_100Rnd_30x06_Mag","OPTRE_100Rnd_30x06_Mag_Tracer","Splits_100Rnd_762x51_Mag","DMNS_100Rnd_762x51_Mag_GPMG","DMNS_100Rnd_762x51_Mag_GPMG_Tracer","DMNS_100Rnd_762x51_AP_Mag_Tracer","Splits_100Rnd_762x51_AP_Mag_Tracer","DMNS_100Rnd_762x51_Mag","DMNS_100Rnd_762x51_Mag_Tracer","Splits_100Rnd_762x51_Mag_Tracer","OPTRE_100Rnd_762x51_Box","OPTRE_100Rnd_762x51_Box_Tracer_Yellow","OPTRE_100Rnd_762x51_Box_Tracer","OPTRE_100Rnd_95x40_Box_Tracer_Yellow","OPTRE_100Rnd_95x40_Box_Tracer","OPTRE_10RND_338_AP","OPTRE_10RND_338_SP","OPTRE_10RND_338_VLD","OPTRE_10Rnd_127x99_noTracer","OPTRE_10Rnd_127x99","OPTRE_10Rnd_127x99_Subsonic_noTracer","OPTRE_10Rnd_127x99_Subsonic","ACE_2Rnd_12Gauge_Pellets_No0_Buck","2Rnd_12Gauge_Pellets","ACE_2Rnd_12Gauge_Pellets_No1_Buck","ACE_2Rnd_12Gauge_Pellets_No2_Buck","ACE_2Rnd_12Gauge_Pellets_No3_Buck","ACE_2Rnd_12Gauge_Pellets_No4_Bird","2Rnd_12Gauge_Slug","ACE_6Rnd_12Gauge_Pellets_No0_Buck","6Rnd_12Gauge_Pellets","ACE_6Rnd_12Gauge_Pellets_No1_Buck","ACE_6Rnd_12Gauge_Pellets_No2_Buck","ACE_6Rnd_12Gauge_Pellets_No3_Buck","ACE_6Rnd_12Gauge_Pellets_No4_Bird","6Rnd_12Gauge_Slug","10Rnd_127x54_Mag","5Rnd_127x108_APDS_Mag","5Rnd_127x108_Mag","ACE_10Rnd_127x99_Mag","ACE_10Rnd_127x99_AMAX_Mag","ACE_5Rnd_127x99_Mag","ACE_5Rnd_127x99_AMAX_Mag","ACE_10Rnd_127x99_API_Mag","ACE_5Rnd_127x99_API_Mag","WNZ_EMP127_Mag","Splits_1200Rnd_762x51_AP_Mag_Tracer","OPTRE_12Rnd_12Gauge_HE","OPTRE_12Rnd_12Gauge_HE_Tracer","OPTRE_12Rnd_12Gauge_Pellets","OPTRE_12Rnd_12Gauge_Pellets_Tracer","OPTRE_12Rnd_12Gauge_Smoke","OPTRE_12Rnd_12Gauge_Smoke_Tracer","OPTRE_12Rnd_127x40_Black_Mag","OPTRE_12Rnd_127x40_Desert_Mag","OPTRE_12Rnd_127x40_Jungle_Mag","OPTRE_12Rnd_127x40_Mag_Black_Tracer","OPTRE_12Rnd_127x40_Mag_Desert_Tracer","OPTRE_12Rnd_127x40_Mag_Jungle_Tracer","OPTRE_12Rnd_127x40_Mag","OPTRE_12Rnd_127x40_Mag_Tracer","12Rnd_8Gauge","OPTRE_12Rnd_8Gauge_HEDP","OPTRE_12Rnd_8Gauge_Pellets","12Rnd_8Gauge_slug","OPTRE_12Rnd_8Gauge_Slugs","12Rnd_8Gauge_slug_tracer","DMNS_150Rnd_30x06_Mag","DMNS_150Rnd_30x06_Mag_Tracer","OPTRE_15Rnd_762x51_AP_Mag","OPTRE_15Rnd_762x51_AP_Mag_Tracer","OPTRE_15Rnd_762x51_Mag","OPTRE_15Rnd_762x51_Mag_Tracer_Yellow","OPTRE_15Rnd_762x51_Mag_Tracer","OPTRE_16Rnd_127x40_Black_Mag","OPTRE_16Rnd_127x40_Desert_Mag","OPTRE_16Rnd_127x40_Jungle_Mag","OPTRE_16Rnd_127x40_Mag_Black_Tracer","OPTRE_16Rnd_127x40_Mag_Desert_Tracer","OPTRE_16Rnd_127x40_Mag_Jungle_Tracer","OPTRE_16Rnd_127x40_Mag","OPTRE_16Rnd_127x40_Mag_Tracer","16Rnd_10mm_AP","16Rnd_10mm_Ball","1Rnd_Repulsor_Magazine","1Rnd_Salvo_Magazine","DMNS_200Rnd_762x51_Mag_GPMG","DMNS_200Rnd_762x51_Mag_GPMG_Tracer","DMNS_200Rnd_762x51_AP_Mag_Tracer","Splits_200Rnd_762x51_AP_Mag_Tracer","Splits_200Rnd_762x51_Mag","DMNS_200Rnd_762x51_Mag_Tracer","Splits_200Rnd_762x51_Mag_Tracer","OPTRE_200Rnd_95x40_Box","OPTRE_200Rnd_95x40_Box_Tracer_Yellow","OPTRE_200Rnd_95x40_Box_Tracer","OPTRE_200Rnd_127x99_M247H_Etilka_Ball","OPTRE_200Rnd_127x99_M247H_Etilka","Command_20Rnd_65_TracerR_Mag","Commando_20Rnd_65_ReloadR_Mag","Commando_20Rnd_65_ReloadY_Mag","Commando_20Rnd_65_Mag","vil_3Rnd_M41","vil_3Rnd_HE_M41","OPTRE_25Rnd_762x51_AP_Mag","OPTRE_25Rnd_762x51_Mag","OPTRE_25Rnd_762x51_Mag_Tracer_Yellow","OPTRE_25Rnd_762x51_Mag_Tracer","WRS_Ar_Magazine","32Rnd_762x51_MA5_AP","32Rnd_762x51_MA5_AP_tracer","32Rnd_762x51_MA5","32Rnd_762x51_MA5_tracer","OPTRE_32Rnd_762x51_Mag_Tracer_Yellow","OPTRE_32Rnd_762x51_Mag_Tracer","OPTRE_32Rnd_762x51_Mag_UW","32Rnd_10mm_Ball","vil_8Rnd_FRAG_M92","vil_8Rnd_HE_M92","36Rnd_95x40_ap_br_55","36Rnd_95x40_ap_br_55_tracer","36Rnd_95x40_br_55","36Rnd_95x40_br_55_tracer","36Rnd_95x40_slap_br_55","36Rnd_95x40_slap_br_55_tracer","OPTRE_36Rnd_95x40_Mag","OPTRE_36Rnd_95x40_Mag_Tracer_Yellow","OPTRE_36Rnd_95x40_Mag_Tracer","3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareCIR_F","3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareWhite_F","3Rnd_UGL_FlareYellow_F","OPTRE_3Rnd_SmokeBlue_Grenade_shell","OPTRE_3Rnd_SmokeGreen_Grenade_shell","OPTRE_3Rnd_SmokeOrange_Grenade_shell","OPTRE_3Rnd_SmokePurple_Grenade_shell","OPTRE_3Rnd_Smoke_Grenade_shell","OPTRE_3Rnd_SmokeYellow_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell","3Rnd_SmokeGreen_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell","3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeRed_Grenade_shell","3Rnd_SmokeYellow_Grenade_shell","WRS_Sniper_Magazine","WRS_Sniper_Magazine_AP","3Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","DMNS_400Rnd_762x51_Mag_GPMG","DMNS_400Rnd_762x51_Mag_GPMG_Tracer","DMNS_400Rnd_762x51_AP_Mag_Tracer","DMNS_400Rnd_762x51_Mag","Splits_400Rnd_762x51_Mag","Splits_400Rnd_762x51_Mag_Tracer","DMNS_400Rnd_762x51_Mag_Tracer","OPTRE_400Rnd_762x51_Box_Tracer","WNZ_EMP40mm_3GL_Grenade_Magazine","WNZ_EMP40mm_Grenade_Magazine","OPTRE_40Rnd_30x06_Mag","OPTRE_40Rnd_30x06_Mag_Tracer","WRS_Ar1_Magazine","DMNS_42Rnd_762x54_Mag","DMNS_42Rnd_762x54_Mag_Tracer","OPTRE_42Rnd_95x40_Mag","OPTRE_42Rnd_95x40_Mag_Tracer","OPTRE_42Rnd_95x40_Mag_Tracer_Yellow","OPTRE_48Rnd_5x23mm_FMJ_Mag","OPTRE_48Rnd_5x23mm_JHP_Mag","OPTRE_48Rnd_5x23mm_Mag","OPTRE_48Rnd_5x23mm_Mag_tracer_yellow","OPTRE_48Rnd_5x23mm_Mag_tracer","4Rnd_454Casull","OPTRE_4Rnd_145x114_APFSDS_Mag","OPTRE_4Rnd_145x114_APFSDS_Mag_D","OPTRE_4Rnd_145x114_HEDP_Mag","OPTRE_4Rnd_145x114_HVAP_Mag","OPTRE_4Rnd_145x114_HVAP_Mag_D","30Rnd_545x39_Mag_Green_F","30Rnd_545x39_Mag_F","30Rnd_545x39_Mag_Tracer_Green_F","30Rnd_545x39_Mag_Tracer_F","150Rnd_556x45_Drum_Green_Mag_F","150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Sand_Mag_F","150Rnd_556x45_Drum_Green_Mag_Tracer_F","150Rnd_556x45_Drum_Mag_Tracer_F","150Rnd_556x45_Drum_Sand_Mag_Tracer_F","200Rnd_556x45_Box_Red_F","200Rnd_556x45_Box_F","200Rnd_556x45_Box_Tracer_Red_F","200Rnd_556x45_Box_Tracer_F","20Rnd_556x45_UW_mag","ACE_30Rnd_556x45_Stanag_M995_AP_mag","ACE_30Rnd_556x45_Stanag_Mk262_mag","ACE_30Rnd_556x45_Stanag_Mk318_mag","30Rnd_556x45_Stanag_green","30Rnd_556x45_Stanag_Sand_green","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_Sand_red","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Sand","30Rnd_556x45_Stanag_Tracer_Green","30Rnd_556x45_Stanag_Sand_Tracer_Green","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Sand_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_556x45_Stanag_Sand_Tracer_Yellow","ACE_30Rnd_556x45_Stanag_Tracer_Dim","200Rnd_556x45_Box_Mixed_Tracer_Blue_F","200Rnd_556x45_Box_Tracer_Blue_F","30Rnd_556x45_Stanag_Tracer_Blue","50Rnd_570x28_SMG_03","50Rnd_570x28_SMG_03_tracer_blue","100Rnd_580x42_ghex_Mag_F","100Rnd_580x42_hex_Mag_F","100Rnd_580x42_Mag_F","100Rnd_580x42_ghex_Mag_Tracer_F","100Rnd_580x42_hex_Mag_Tracer_F","100Rnd_580x42_Mag_Tracer_F","30Rnd_580x42_Mag_F","30Rnd_580x42_Mag_Tracer_F","ACE_10Rnd_580x42_DBP88_Mag","DMNS_500Rnd_127x99_Mag_Tracer","DMNS_500Rnd_127x99_HE_Mag_Tracer","OPTRE_500Rnd_762x51_Box_Tracer","WRS_Ar2_Magazine","WRS_Boomslang_Magazine","OPTRE_5Rnd_127x99_noTracer","OPTRE_5Rnd_127x99","OPTRE_5Rnd_127x99_Subsonic_noTracer","OPTRE_5Rnd_127x99_Subsonic","100Rnd_65x39_caseless_black_mag","100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_black_mag_tracer","100Rnd_65x39_caseless_mag_Tracer_Blue","ACE_100Rnd_65x39_caseless_mag_Tracer_Dim","100Rnd_65x39_caseless_khaki_mag_tracer","100Rnd_65x39_caseless_mag_Tracer","200Rnd_65x39_cased_Box","200Rnd_65x39_cased_Box_Tracer_Blue","ACE_200Rnd_65x39_cased_Box_Tracer_Dim","200Rnd_65x39_cased_Box_Tracer","200Rnd_65x39_cased_Box_Red","20Rnd_650x39_Cased_Mag_F","30Rnd_65x39_caseless_black_mag","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_khaki_mag","30Rnd_65x39_caseless_msbs_mag","30Rnd_65x39_caseless_msbs_mag_Tracer","30Rnd_65x39_caseless_mag","30Rnd_65x39_Katiba_caseless_mag_Tracer_Blue","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_black_mag_Tracer","30Rnd_65x39_caseless_mag_Tracer_Blue","ACE_30Rnd_65x39_caseless_mag_Tracer_Dim","ACE_30Rnd_65x39_caseless_green_mag_Tracer_Dim","30Rnd_65x39_caseless_mag_Tracer","ACE_20Rnd_65_Creedmor_mag","ACE_30Rnd_65_Creedmor_black_mag","ACE_30Rnd_65_Creedmor_khaki_mag","ACE_30Rnd_65_Creedmor_msbs_mag","ACE_30Rnd_65_Creedmor_mag","200Rnd_65x39_cased_Box_Tracer_Red","ACE_20Rnd_65x47_Scenar_mag","ACE_30Rnd_65x47_Scenar_black_mag","ACE_30Rnd_65x47_Scenar_khaki_mag","ACE_30Rnd_65x47_Scenar_msbs_mag","ACE_30Rnd_65x47_Scenar_mag","60Rnd_5x23_m7_fmj","60Rnd_5x23_m7_fmj_tracer","OPTRE_60Rnd_5x23mm_Mag","OPTRE_60Rnd_5x23mm_Mag_tracer_yellow","OPTRE_60Rnd_5x23mm_Mag_tracer","OPTRE_60Rnd_762x51_Mag","OPTRE_60Rnd_762x51_Mag_Tracer_Yellow","OPTRE_60Rnd_762x51_Mag_Tracer","OPTRE_64Rnd_57x31_Mag","OPTRE_64Rnd_57x31_Mag_Tracer_Yellow","OPTRE_64Rnd_57x31_Mag_Tracer","WRS_Revolver_Magazine","OPTRE_6Rnd_8Gauge_Pellets","OPTRE_6Rnd_8Gauge_Slugs","6Rnd_GreenSignal_F","6Rnd_RedSignal_F","10Rnd_762x54_Mag","10Rnd_762x51_Mag","ACE_10Rnd_762x51_Mag_Tracer_Dim","ACE_10Rnd_762x51_M118LR_Mag","ACE_10Rnd_762x51_M993_AP_Mag","ACE_10Rnd_762x51_Mk316_Mod_0_Mag","ACE_10Rnd_762x51_Mk319_Mod_0_Mag","ACE_10Rnd_762x51_Mag_SD","ACE_10Rnd_762x51_Mag_Tracer","10Rnd_Mk14_762x51_Mag","150Rnd_762x54_Box","150Rnd_762x51_Box","150Rnd_762x51_Box_Tracer","20Rnd_762x51_Mag","ACE_20Rnd_762x51_Mag_Tracer_Dim","ACE_20Rnd_762x51_M118LR_Mag","ACE_20Rnd_762x51_M993_AP_Mag","ACE_20Rnd_762x51_Mk316_Mod_0_Mag","ACE_20Rnd_762x51_Mk319_Mod_0_Mag","ACE_20Rnd_762x51_Mag_SD","ACE_20Rnd_762x51_Mag_Tracer","30rnd_762x39_AK12_Lush_Mag_F","30Rnd_762x39_AK12_Mag_F","30rnd_762x39_AK12_Arid_Mag_F","30rnd_762x39_AK12_Lush_Mag_Tracer_F","30Rnd_762x39_AK12_Mag_Tracer_F","30rnd_762x39_AK12_Arid_Mag_Tracer_F","30Rnd_762x39_Mag_F","30Rnd_762x39_Mag_Tracer_Green_F","30Rnd_762x39_Mag_Tracer_F","75rnd_762x39_AK12_Arid_Mag_F","75rnd_762x39_AK12_Lush_Mag_F","75rnd_762x39_AK12_Mag_F","75rnd_762x39_AK12_Arid_Mag_Tracer_F","75rnd_762x39_AK12_Mag_Tracer_F","75Rnd_762x39_Mag_F","75Rnd_762x39_Mag_Tracer_F","150Rnd_762x51_Box_Mixed_Tracer_Blue","150Rnd_762x51_Box_Tracer_Blue","20Rnd_762x51_Mag_Tracer_Blue","ACE_10Rnd_762x54_Tracer_mag","TG_FORG_Deagle_Magazine","TG_FORG_Deagle_RT_Magazine","TG_FORG_Deagle_T_Magazine","OPTRE_7Rnd_20mm_APFSDS_Mag","OPTRE_7Rnd_20mm_HEDP_Mag","OPTRE_8Rnd_127x40_AP_Mag","OPTRE_8Rnd_127x40_Mag","OPTRE_8Rnd_127x40_Mag_Tracer","8Rnd_10mm_EXP","10Rnd_9x21_Mag","16Rnd_9x21_red_Mag","16Rnd_9x21_yellow_Mag","16Rnd_9x21_Mag","30Rnd_9x21_Mag","30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Green_Mag","30Rnd_9x21_Red_Mag","30Rnd_9x21_Mag_SMG_02_Tracer_Red","30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Yellow_Mag","10Rnd_93x64_DMR_05_Mag","150Rnd_93x64_Mag","Vorona_HE","Vorona_HEAT","ACE_16Rnd_9x19_mag","OPTRE_csw_100Rnd_762x51","OPTRE_csw_100Rnd_762x51_Tracer_Yellow","OPTRE_CSW_10Rnd_122mm_Mo_Flare_white","OPTRE_CSW_10Rnd_122mm_Mo_guided","OPTRE_CSW_10Rnd_122mm_Mo_shells","OPTRE_CSW_10Rnd_122mm_Mo_LG","OPTRE_CSW_10Rnd_122mm_SABOT_81mm_Mo_shells","OPTRE_CSW_10Rnd_122mm_Mo_Smoke_white","ace_csw_50Rnd_127x108_mag","ace_csw_100Rnd_127x99_mag","ace_csw_100Rnd_127x99_mag_green","ace_csw_100Rnd_127x99_mag_red","ace_csw_100Rnd_127x99_mag_yellow","OPTRE_csw_200Rnd_127x99","ace_csw_20Rnd_20mm_G_belt","OPTRE_csw_400Rnd_762x51","OPTRE_CSW_5Rnd_122mm_Mo_Cluster_HE","OPTRE_CSW_5Rnd_122mm_Mo_LG_SABOT","ACE_1Rnd_82mm_Mo_HE_Guided","ACE_1Rnd_82mm_Mo_HE","ACE_1Rnd_82mm_Mo_Illum","ACE_1Rnd_82mm_Mo_HE_LaserGuided","ACE_1Rnd_82mm_Mo_Smoke","vil_SadarmagIRL","TG_CAB_AR_Magazine","TG_CAB_AR_RT_Magazine","TG_CAB_AR_T_Magazine","TG_CAB_Scorpion_Magazine","Laserbatteries","vil_flamethrower_mag","TG_NOD_Flamethrower_Magazine","FlareGreen_F","FlareWhite_F","FlareYellow_F","UGL_FlareGreen_F","UGL_FlareCIR_F","UGL_FlareRed_F","UGL_FlareWhite_F","UGL_FlareYellow_F","OPTRE_signalSmokeB","OPTRE_signalSmokeG","OPTRE_signalSmokeO","OPTRE_signalSmokeP","OPTRE_signalSmokeR","OPTRE_signalSmokeY","TG_GDI_Sirius_Magazine","TG_GDI_Sirius_RT_Magazine","TG_GDI_AR_Magazine","TG_GDI_AR_RT_Magazine","TG_GDI_AR_T_Magazine","TG_GDI_Demolisher_Magazine","TG_GDI_Railgun_Magazine","TG_GDI_Dominator_Magazine","vil_Sadarmag","OPTRE_1Rnd_SmokeBlue_Grenade_shell","OPTRE_1Rnd_SmokeGreen_Grenade_shell","OPTRE_1Rnd_SmokeOrange_Grenade_shell","OPTRE_1Rnd_SmokePurple_Grenade_shell","OPTRE_1Rnd_SmokeRed_Grenade_shell","OPTRE_1Rnd_Smoke_Grenade_shell","OPTRE_1Rnd_SmokeYellow_Grenade_shell","vil_smg39_box","vil_95rnd_m41","vil_10x55_SNPR_MAG","vil_10x55_SCP_MAG","DMNS_M96_HEAT","OPTRE_M41_Twin_HE_Thermal_ProximityFuse","OPTRE_M41_Twin_HE_SACLOS_ProximityFuse","OPTRE_M41_Twin_HE_SALH_ProximityFuse","OPTRE_M41_Twin_HE","OPTRE_M41_Twin_HEAP","OPTRE_M41_Twin_HEAT_Thermal","OPTRE_M41_Twin_HEAT_G","OPTRE_M41_Twin_HEAT_SACLOS","OPTRE_M41_Twin_HEAT_SALH","OPTRE_M41_Twin_HEAT","OPTRE_M41_Twin_Smoke_B","OPTRE_M41_Twin_Smoke_G","OPTRE_M41_Twin_Smoke_P","OPTRE_M41_Twin_Smoke_R","OPTRE_M41_Twin_Smoke_W","OPTRE_M41_Twin_Smoke_Y","M319_Buckshot","M319_HE_Grenade_Shell","M319_HEDP_Grenade_Shell","M319_Smoke","M319_Smoke_Orange","M319_Smoke_Red","ACE_40mm_Flare_white","OPTRE_SpLaser_Battery_Launcher","ACE_40mm_Flare_green","ACE_40mm_Flare_red","ACE_40mm_Flare_ir","WNZ_EMP_MAAWS_Mag","MRAWS_HE_F","MRAWS_HEAT55_F","MRAWS_HEAT_F","TG_NOD_Ripper_Magazine","TG_NOD_Ripper_RT_Magazine","TG_NOD_Ripper_T_Magazine","TG_NOD_Purge_Magazine","TG_NOD_Purge_RT_Magazine","TG_NOD_Purge_T_Magazine","TG_NOD_AR2_Magazine","TG_NOD_AR2_RT_Magazine","TG_NOD_AR2_T_Magazine","TG_NOD_AR_Magazine","TG_NOD_SMG_Magazine","TG_NOD_SMG_RT_Magazine","TG_NOD_AR_T_Magazine","TG_NOD_SMG_T_Magazine","TG_NOD_Justice_Magazine","TG_NOD_Justice_RT_Magazine","TG_NOD_Justice_T_Magazine","TG_NOD_LMG_Magazine","TG_NOD_LMG_RT_Magazine","TG_NOD_LMG_T_Magazine","TG_NOD_Inquisition_Magazine","TG_NOD_RocketLauncher_Magazine","vil_p4a1_MAG","NLAW_F","WNZ_EMP_RPG7_Mag","RPG7_F","vil_rail_box","WRS_Shockgun_Magazine","RPG32_HE_F","RPG32_F","WNZ_EMP_RPG32_Mag","dev_magazine_scannerBattery","vil_shotgun_box","vil_smart_box","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","vil_SadarmagTHE","Titan_AA","Titan_AP","Titan_AT","OPTRE_3Rnd_MasterKey_Pellets","OPTRE_1Rnd_MasterKey_Slugs","OPTRE_3Rnd_MasterKey_Slugs","vil_vp70_MAG","vil_SadarmagWPR","X26_Cartridge","X26_Cartridge_Yellow","X26_Cartridge_Blank","X26_Cartridge_Blank_Yellow","OPTRE_1Rnd_MasterKey_Pellets","TG_NOD_AR_RT_Magazine","M319_Smoke_Green","OPTRE_M41_Twin_Smoke_O","ACE_HuntIR_M203","TG_GDI_Sirius_T_Magazine","FlareRed_F","30Rnd_9x21_Mag_SMG_02_Tracer_Green","75rnd_762x39_AK12_Lush_Mag_Tracer_F","30Rnd_762x39_Mag_Green_F","16Rnd_9x21_green_Mag","150Rnd_762x54_Box_Tracer","OPTRE_6Rnd_8Gauge_HEDP","30Rnd_65x39_caseless_khaki_mag_Tracer","100Rnd_65x39_caseless_khaki_mag","OPTRE_4Rnd_145x114_HEDP_Mag_D","3Rnd_Smoke_Grenade_shell","OPTRE_3Rnd_SmokeRed_Grenade_shell","OPTRE_32Rnd_762x51_Mag","OPTRE_25Rnd_762x51_AP_Mag_Tracer","Commando_20Rnd_65_TracerY_Mag","DMNS_200Rnd_762x51_Mag","1Rnd_Buckshot_Magazine","ACE_6Rnd_12Gauge_Pellets_No4_Buck","ACE_2Rnd_12Gauge_Pellets_No4_Buck","OPTRE_100Rnd_95x40_Box","G_O_Diving","WNZ_EMP408_Mag","WNZ_EMP50BW_Mag","WNZ_EMP127_Mag","WNZ_EMP40mm_3GL_Grenade_Magazine","WNZ_EMP40mm_Grenade_Magazine","WNZ_EMP_MAAWS_Mag","WNZ_EMP_RPG7_Mag","WNZ_EMP_RPG32_Mag","WNZ_EMPATMine_Range_Mag","TG_EMP_Mine_Magazine","WNZ_EMPSatchelCharge_Remote_Mag","WNZ_EMPGrenade","WNZ_EMPImpactGrenade","G_AirPurifyingRespirator_02_olive_F","optic_Nightstalker","optic_SOS","optic_MRCO","optic_Arco_blk_F","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Hamr","optic_Holosight_blk_F","optic_DMS","optic_DMS_weathered_Kir_F","optic_LRPS","optic_AMS","optic_KHS_blk","optic_ERCO_blk_F","optic_Yorris","ACE_optic_MRCO_2D","acc_flashlight","acc_pointer_IR","ACE_acc_pointer_green","30Rnd_762x39_AK12_Mag_F","30Rnd_762x39_AK12_Mag_Tracer_F","75rnd_762x39_AK12_Mag_F","75rnd_762x39_AK12_Mag_Tracer_F","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_green","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Green","30Rnd_556x45_Stanag_Tracer_Yellow","ACE_30Rnd_556x45_Stanag_M995_AP_mag","ACE_30Rnd_556x45_Stanag_Mk262_mag","ACE_30Rnd_556x45_Stanag_Mk318_mag","ACE_30Rnd_556x45_Stanag_Tracer_Dim","150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Mag_Tracer_F","10Rnd_338_Mag","ACE_10Rnd_338_300gr_HPBT_Mag","ACE_10Rnd_338_API526_Mag","optic_Holosight_smg_blk_F","optic_DMS_weathered_F","ACE_optic_SOS_2D","optic_MRD_black","acc_flashlight_pistol","acc_esd_01_flashlight","muzzle_snds_93mmg","ACE_muzzle_mzls_93mmg","muzzle_snds_B","ACE_muzzle_mzls_B","muzzle_snds_H","muzzle_snds_65_TI_blk_F","ACE_muzzle_mzls_H","muzzle_snds_L","ACE_muzzle_mzls_smg_02","muzzle_antenna_01_f","muzzle_antenna_02_f","muzzle_antenna_03_f","10Rnd_127x54_Mag","10Rnd_93x64_DMR_05_Mag","75Rnd_762x39_Mag_F","75Rnd_762x39_Mag_Tracer_F","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","UGL_FlareRed_F","UGL_FlareYellow_F","UGL_FlareCIR_F","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","ACE_HuntIR_M203","ACE_40mm_Flare_white","ACE_40mm_Flare_red","ACE_40mm_Flare_green","ACE_40mm_Flare_ir","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","ACE_5Rnd_127x99_Mag","ACE_5Rnd_127x99_API_Mag","ACE_5Rnd_127x99_AMAX_Mag","150Rnd_762x54_Box","150Rnd_762x54_Box_Tracer","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_Tracer","ACE_30Rnd_65x39_caseless_green_mag_Tracer_Dim","10Rnd_50BW_Mag_F","RPG7_F","Vorona_HEAT","Vorona_HE","RPG32_F","RPG32_HE_F","Titan_AT","Titan_AP","Titan_AA","16Rnd_9x21_Mag","16Rnd_9x21_green_Mag","30Rnd_9x21_Mag","30Rnd_9x21_Green_Mag","10Rnd_9x21_Mag","6Rnd_45ACP_Cylinder","dev_magazine_scannerBattery","WINTER_BALACLAVA_HEX_CG","WINTER_BALACLAVA_HEX_LPG","WINTER_BALACLAVA_HEX","G_Aviator","G_Combat","G_Combat_Goggles_tna_F","G_Lady_Blue","G_Lowprofile","G_Shades_Black","G_Shades_Blue","G_Sport_Blackyellow","G_Sport_BlackWhite","G_Sport_Checkered","G_Sport_Blackred","G_Sport_Greenblack","G_Squares_Tinted","G_Squares","G_Spectacles","G_Shades_Red","G_Shades_Green","G_Sport_Red","G_Tactical_Clear","G_Tactical_Black","G_Spectacles_Tinted","G_Goggles_VR","G_WirelessEarpiece_F","WINTER_NVG_TI_GOOGLES","Binocular","Laserdesignator_03","Rangefinder","ItemMap","ItemCompass","TFAR_anprc148jem","ACE_Altimeter","TFAR_microdagr","ItemGPS","O_UavTerminal","ACE_M14","ACE_Chemlight_HiBlue","ACE_Chemlight_HiGreen","ACE_Chemlight_HiRed","ACE_Chemlight_HiWhite","ACE_Chemlight_HiYellow","ACE_Chemlight_IR","ACE_CTS9","O_IR_Grenade","SmokeShellBlue","SmokeShellGreen","SmokeShellOrange","SmokeShellPurple","SmokeShellRed","SmokeShellYellow","MiniGrenade","HandGrenade","APERSMineDispenser_Mag","IEDLandBig_Remote_Mag","DemoCharge_Remote_Mag","SatchelCharge_Remote_Mag","ClaymoreDirectionalMine_Remote_Mag","ATMine_Range_Mag","APERSMine_Range_Mag","APERSTripMine_Wire_Mag","ACE_RangeTable_82mm","AnomalyDetector","ACE_CableTie","ACE_DAGR","ACE_DeadManSwitch","ACE_EarPlugs","ACE_DefusalKit","ACE_EntrenchingTool","ACE_Fortify","ACE_Humanitarian_Ration","ACE_IR_Strobe_Item","ACE_Kestrel4500","ACE_Flashlight_KSF1","ACE_M26_Clacker","ACE_Flashlight_XL50","ACE_MapTools","MineDetector","ACE_microDAGR","ACE_MRE_BeefStew","ACE_MRE_ChickenTikkaMasala","ACE_MRE_ChickenHerbDumplings","ACE_MRE_CreamChickenSoup","ACE_MRE_CreamTomatoSoup","ACE_MRE_LambCurry","ACE_MRE_MeatballsPasta","ACE_MRE_SteakVegetables","ACE_SpottingScope","ACE_Tripod","ToolKit","ACE_tourniquet","ACE_wirecutter","ACE_UAVBattery","16Rnd_9x21_red_Mag","16Rnd_9x21_yellow_Mag","30Rnd_9x21_Red_Mag","30Rnd_9x21_Yellow_Mag","30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Mag_SMG_02_Tracer_Red","30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02_Tracer_Green","150Rnd_93x64_Mag","9Rnd_45ACP_Mag","11Rnd_45ACP_Mag","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_Tracer_Green","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow","X26_Cartridge","X26_Cartridge_Blank","muzzle_snds_338_black","muzzle_snds_acp","ACE_muzzle_mzls_smg_01","muzzle_snds_M","ACE_muzzle_mzls_L","optic_tws","optic_tws_mg","ACE_optic_Hamr_2D","ACE_optic_Hamr_PIP","ACE_optic_SOS_PIP","muzzle_snds_338_green","muzzle_snds_65_TI_hex_F","muzzle_snds_65_TI_ghex_F","30Rnd_762x39_Mag_F","30Rnd_762x39_Mag_Green_F","30Rnd_762x39_Mag_Tracer_F","30Rnd_762x39_Mag_Tracer_Green_F","150Rnd_556x45_Drum_Green_Mag_F","150Rnd_556x45_Drum_Green_Mag_Tracer_F","ACE_10Rnd_762x67_Mk248_Mod_0_Mag","ACE_10Rnd_762x67_Mk248_Mod_1_Mag","ACE_10Rnd_762x67_Berger_Hybrid_OTM_Mag","X26_Cartridge_Yellow","X26_Cartridge_Blank_Yellow","30Rnd_545x39_Mag_F","30Rnd_545x39_Mag_Green_F","30Rnd_545x39_Mag_Tracer_F","30Rnd_545x39_Mag_Tracer_Green_F","optic_Arco_AK_blk_F","bipod_02_F_blk","WRS_Sniper_Magazine","WRS_Sniper_Magazine_AP","WRS_Ar_Magazine","WRS_Ar1_Magazine","WRS_Ar2_Magazine","WRS_Boomslang_Magazine","WRS_Revolver_Magazine","TG_FORG_Deagle_T_Magazine","TG_FORG_Deagle_RT_Magazine","TG_FORG_Deagle_Magazine","1Rnd_Salvo_Magazine","1Rnd_Repulsor_Magazine","1Rnd_Buckshot_Magazine","TG_CAB_AR_Magazine","TG_CAB_AR_RT_Magazine","TG_CAB_AR_T_Magazine","TG_CAB_Scorpion_Magazine","TG_NOD_Flamethrower_Magazine","TG_GDI_Sirius_Magazine","TG_GDI_Sirius_RT_Magazine","TG_GDI_Sirius_T_Magazine","TG_GDI_AR_Magazine","TG_GDI_AR_RT_Magazine","TG_GDI_AR_T_Magazine","TG_GDI_Demolisher_Magazine","TG_GDI_Railgun_Magazine","TG_GDI_Dominator_Magazine","TG_NOD_Ripper_Magazine","TG_NOD_Ripper_RT_Magazine","TG_NOD_Ripper_T_Magazine","TG_NOD_Purge_Magazine","TG_NOD_Purge_RT_Magazine","TG_NOD_Purge_T_Magazine","TG_NOD_AR2_Magazine","TG_NOD_AR2_RT_Magazine","TG_NOD_AR2_T_Magazine","TG_NOD_AR_Magazine","TG_NOD_SMG_Magazine","TG_NOD_SMG_RT_Magazine","TG_NOD_AR_RT_Magazine","TG_NOD_AR_T_Magazine","TG_NOD_SMG_T_Magazine","TG_NOD_Justice_Magazine","TG_NOD_Justice_RT_Magazine","TG_NOD_Justice_T_Magazine","TG_NOD_LMG_Magazine","TG_NOD_LMG_RT_Magazine","TG_NOD_LMG_T_Magazine","TG_NOD_Inquisition_Magazine","TG_NOD_RocketLauncher_Magazine","WRS_Shockgun_Magazine","150Rnd_762x51_Box_Mixed_Tracer_Blue","150Rnd_762x51_Box_Tracer_Blue","20Rnd_762x51_Mag_Tracer_Blue","ACE_10Rnd_762x54_Tracer_mag","OPTRE_7Rnd_20mm_APFSDS_Mag","OPTRE_7Rnd_20mm_HEDP_Mag"]] remoteExecCall ["ace_arsenal_fnc_initBox", 0]; 
						[_ePod,_toPos,1,false] spawn G_MoveObject;
					};
			case 4: {
						_fromPos =  [(((getPosATL _pod) select 0)),(((getPosATL _pod) select 1)),(((getPosATL _pod) select 2) - 6)];
						_toPos =  [((_fromPos select 0)),((_fromPos select 1)),((_fromPos select 2) + 6)];
						_ePod = "OPTRE_Ammo_SupplyPod_Medical" createVehicle _fromPos;
						_ePod enableSimulationGlobal false; 
						[_ePod, false] call ace_dragging_fnc_setDraggable; 
						[_ePod, false] call ace_dragging_fnc_setCarryable; 
						_ePod setPosATL _fromPos;
						_ePod setDir 0;
						_Pod setDir 0;	
						clearItemCargoGlobal _epod;					
						sleep 3;	
						_epod addItemCargoGlobal ["DMNS_Biofoam", 4];
						_epod addItemCargoGlobal ["ACE_adenosine", 1];
						_epod addItemCargoGlobal ["ACE_fieldDressing", 40];
						_epod addItemCargoGlobal ["ACE_elasticBandage", 20];
						_epod addItemCargoGlobal ["ACE_packingBandage", 20];
						_epod addItemCargoGlobal ["ACE_quikclot", 10];
						_epod addItemCargoGlobal ["OPTRE_Biofoam", 4];
						_epod addItemCargoGlobal ["ACE_bloodIV", 2];
						_epod addItemCargoGlobal ["ACE_bloodIV_250", 8];
						_epod addItemCargoGlobal ["ACE_bloodIV_500", 4];
						_epod addItemCargoGlobal ["dev_enzymeCapsule", 5];
						_epod addItemCargoGlobal ["dev_enzymeCapsule_refined", 2];
						_epod addItemCargoGlobal ["ACE_epinephrine", 10];
						_epod addItemCargoGlobal ["ACE_morphine", 2];
						_epod addItemCargoGlobal ["OPTRE_Medigel", 1];
						_epod addItemCargoGlobal ["ACE_personalAidKit", 1];
						_epod addItemCargoGlobal ["ACE_splint", 4];
						_epod addItemCargoGlobal ["ACE_surgicalKit", 1];
						_epod addItemCargoGlobal ["ACE_suture", 10];
						_epod addItemCargoGlobal ["ACE_painkillers", 10];		
						[_ePod,_toPos,1,false] spawn G_MoveObject;
					};
			case 5: {
						_fromPos =  [(((getPosATL _pod) select 0) - 0.822),(((getPosATL _pod) select 1)),(((getPosATL _pod) select 2) - 3)];
						_toPos =  [((_fromPos select 0) - 0.822),((_fromPos select 1)),((_fromPos select 2) + 3)];
						_ePod = "SESP" createVehicle _fromPos; 
						_ePod setPosATL _fromPos;
						_ePod setDir 0;
						_Pod setDir 0;
						sleep 3;
						{
							_epod addBackpackCargoGlobal [_x, 1];
						} forEach _content;
						[_ePod,_toPos,1,false] spawn G_MoveObject;
					};
			case 6: {
						_fromPos =  [(((getPosATL _pod) select 0)),(((getPosATL _pod) select 1)),(((getPosATL _pod) select 2) - 3)];
						_toPos =  [((_fromPos select 0)),((_fromPos select 1)),((_fromPos select 2) + 3)];
						_ePod = "OPTRE_RS_ConsoleDoor" createVehicle _fromPos; 
						_ePod enableSimulationGlobal false;  
						_ePod setPosATL _fromPos;
						_ePod setDir 0;
						_Pod setDir 0;
						sleep 3;
						[_ePod,_toPos,1,false] spawn G_MoveObject;
						_raza = "#particlesource" createVehicleLocal (getpos _ePod);
						_raza setParticleCircle [0.1, [0, 0, 0]];
						_raza setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 17, [0, 0, 0], [0, 0, 5], 0, 9, 9, 0, [0.5,0.0], [[0,1,0, 1], [1,0.9,0.5, 1], [1,0.9,0.5,0]],[0.08], 1, 0, "", "", _ePod];
						_raza setDropInterval 0.002;
						
						_li1 = "#lightpoint" createVehicle [(getpos _ePod select 0),(getpos _ePod select 1),(getpos _ePod select 2)];
						_li1 setLightBrightness 2;
						_li1 setLightAmbient[0,1,0];
						_li1 setLightColor[0,1,0];
						_li1 lightAttachObject [_ePod, [0,0,0]];
						
						_evacMarker = createMarker ["evacMarker", _ePod]; 
						"evacMarker" setMarkerText "Эвакуация";
						"evacMarker" setMarkerType "mil_pickup_noShadow";
						[[east, "HQ"],"Мы отметили позицию приземления маяка для эвакуации на карте."] remoteExec ["sideChat", 0];
						
						[_ePod,												// Object the action is attached to
						"Вызвать шатл",										// Title of the action
						"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Idle icon shown on screen
						"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Progress icon shown on screen
						"_this distance _target < 2",						// Condition for the action to be shown
						"_caller distance _target < 2",						// Condition for the action to progress
						{},													// Code executed when action starts
						{},													// Code executed on every progress tick
						{
							[getPos _target] remoteExec ["G_Call_Evac_Shuttle",2];
						},													// Code executed on completion
						{},													// Code executed on interrupted
						[],													// Arguments passed to the scripts as _this select 3
						10,													// Action duration [s]
						0,													// Priority
						true,												// Remove on completion
						false												// Show in unconscious state 
						] remoteExec ["BIS_fnc_holdActionAdd", 0, _ePod];
					};
			case 7: {
						_fromPos =  [(((getPosATL _pod) select 0)),(((getPosATL _pod) select 1)),(((getPosATL _pod) select 2) - 6)];
						_toPos =  [((_fromPos select 0)),((_fromPos select 1)),((_fromPos select 2) + 6)];
						_ePod = "Land_OPTRE_mil_antenna_mast" createVehicle _fromPos; 
						_ePod enableSimulationGlobal false;  
						_ePod setPosATL _fromPos;
						_ePod setDir 0;
						_Pod setDir 0;
						sleep 3;
						[_ePod,_toPos,1,false] spawn G_MoveObject;
						_raza = "#particlesource" createVehicleLocal (getpos _ePod);
						_raza setParticleCircle [0.1, [0, 0, 0]];
						_raza setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 17, [0, 0, 0], [0, 0, 5], 0, 9, 9, 0, [0.5,0.0], [[0,0,1, 1], [1,0.9,0.5, 1], [1,0.9,0.5,0]],[0.08], 1, 0, "", "", _ePod];
						_raza setDropInterval 0.002;
						
						_li1 = "#lightpoint" createVehicle [(getpos _ePod select 0),(getpos _ePod select 1),(getpos _ePod select 2)];
						_li1 setLightBrightness 2;
						_li1 setLightAmbient[0,0,1];
						_li1 setLightColor[0,0,1];
						_li1 lightAttachObject [_ePod, [0,0,0]];
						
						_evacMarker = createMarker ["evacMarker", _ePod]; 
						"evacMarker" setMarkerText "Эвакуация";
						"evacMarker" setMarkerType "mil_pickup_noShadow";
						[[east, "HQ"],"Мы отметили позицию приземления маяка для эвакуации на карте."] remoteExec ["sideChat", 0];
						
						[getPos _ePod] remoteExec ["G_Call_Evac_Shuttle",2];
					};
			case 8: {
						_fromPos =  [(((getPosATL _pod) select 0)),(((getPosATL _pod) select 1)),(((getPosATL _pod) select 2) - 6)];
						_toPos =  [((_fromPos select 0)),((_fromPos select 1)),((_fromPos select 2) + 6)];
						_ePod = "Land_OPTRE_mil_antenna_mast" createVehicle _fromPos; 
						_ePod enableSimulationGlobal false;  
						_ePod setPosATL _fromPos;
						_ePod setDir 0;
						_Pod setDir 0;
						sleep 3;
						[_ePod,_toPos,1,false] spawn G_MoveObject;
						_raza = "#particlesource" createVehicleLocal (getpos _ePod);
						_raza setParticleCircle [0.1, [0, 0, 0]];
						_raza setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 17, [0, 0, 0], [0, 0, 5], 0, 9, 9, 0, [0.5,0.0], [[0,0,1, 1], [1,0.9,0.5, 1], [1,0.9,0.5,0]],[0.08], 1, 0, "", "", _ePod];
						_raza setDropInterval 0.002;
						
						_li1 = "#lightpoint" createVehicle [(getpos _ePod select 0),(getpos _ePod select 1),(getpos _ePod select 2)];
						_li1 setLightBrightness 2;
						_li1 setLightAmbient[0,0,1];
						_li1 setLightColor[0,0,1];
						_li1 lightAttachObject [_ePod, [0,0,0]];
												
						_resourceDepot = (nearestObjects [_ePod, [], 50]) select {["_Tiberium", typeOf _x] call BIS_fnc_inString};
						{
							sleep 30;
							_Crystals = [["Green", 40],["Blue", 135],["Purple", 80],["Red", 230]];
							{
								_text = _x select 0;
								_text = "TG_Tiberium" + _text;
								if (_text in (typeOf (_unit))) then 
								{
									_value = _value + (_x select 1);
									deleteVehicle _unit;
								};
							} forEach _Crystals;
							if (_value > 0) then {
								MSQUADSUPPPOINTS = MSQUADSUPPPOINTS + _value; 
								publicVariable "MSQUADSUPPPOINTS";
								[[east, "HQ"], "С.П.Е.К.Т.Р. мы извлекли ресурсы, средства перечислены на ваш счет."] remoteExec ["sideChat", 0];
							};
							deleteVehicle _x;
						} forEach _resourceDepot;
					};
			default {};
	};
	
	_crashpod = createVehicle ["H_Drop_Pod_Wreck", [(position _pod select 0), (position _pod select 1), (position _pod select 2)], [], 0, "CAN_COLLIDE"];
	_crashpod setVectorDirAndUp [vectorDir _pod, vectorUp _pod];
	deleteVehicle _pod;
	sleep 600;
	deleteVehicle _crashpod;
};

//Время на выполнение орпеации
G_Mission_Begin = {
	GlobalTimer = 3600;
	publicVariable "GlobalTimer";
	missionNamespace setVariable ["GlobalTimer", GlobalTimer, true];
	[[east, "HQ"],"Командование будет держать крейсер на низкой орбите в течении часа."] remoteExec ["sideChat", 0];
	sleep 1;
	while {GlobalTimer > -2} do {
		GlobalTimer = GlobalTimer - 1;
		sleep 1;
		if (GlobalTimer == 1800 ) then {[[east, "HQ"],"Командование cможет держать крейсер на низкой орбите еще в течении 30 минут."] remoteExec ["sideChat", 0];};
		if (GlobalTimer == 600) then {[[east, "HQ"],"Командование cможет держать крейсер на низкой орбите еще в течении 10 минут."] remoteExec ["sideChat", 0];};
		if (GlobalTimer == 300) then {[[east, "HQ"],"Командование cможет держать крейсер на низкой орбите еще в течении 5 минут."] remoteExec ["sideChat", 0];};
		if (GlobalTimer == 120) then {[[east, "HQ"],"Командование cможет держать крейсер на низкой орбите еще в течении 2 минут."] remoteExec ["sideChat", 0];};
		if (GlobalTimer == 60) then {[[east, "HQ"],"Командование cможет держать крейсер на низкой орбите еще в течении 1 минуты."] remoteExec ["sideChat", 0];};
		if (GlobalTimer == 0) then {
			[[east, "HQ"],"Суперкрейсер покидает зону операции, стратегемы не доступны, готовы выслать вам шатл."] remoteExec ["sideChat", 0];
			[true] remoteExec ["G_Evac_Procedure", 2];
		};
	}
};

//Фукнция вызова шатла эвакуации
G_Evac_Procedure = {
	params ["_forced"];
	_dropPos = [getPos SuperCarrier, 500, 1000, 5, 0, 0.1, 0] call BIS_fnc_findSafePos;
	if (_forced) then {[_dropPos,6,[]] spawn StrategemDropProcessing;}
	else {[_dropPos,7,[]] spawn StrategemDropProcessing;};
};
	
//Фукнция подлета шатла
G_Call_Evac_Shuttle = {
	params ["_evacPos"];
	AllEnemies = AllUnits select {side _x != east && side _x != civilian};
	AllEG = [];
	{
		AllEG pushBackUnique (group _x);
	} forEach AllEnemies;
	{
		_newWP = _x addWayPoint [_evacPos, 0];
		_newWP setWaypointType "SAD";
	} forEach AllEG;
	[[east, "HQ"],"Мы отправили вам шаттл. Время прибытия - 3 минуты."] remoteExec ["sideChat", 0];
	sleep 60;
	[[east, "HQ"],"Две минуты до прибытия шаттла."] remoteExec ["sideChat", 0];
	sleep 60;
	[[east, "HQ"],"Минута до прибытия шаттла."] remoteExec ["sideChat", 0];	
	EvacShuttleCalled = true;
	publicVariable "EvacShuttleCalled";
	sleep 60;
	[[east, "HQ"],"Шатл двигается к точке эвакуации."] remoteExec ["sideChat", 0];
	private _spawnPos = [_evacPos, 1500, (random 360)] call BIS_fnc_relPos;
	_evacShuttleResult = [_spawnPos, 0, "OPTRE_Pelican_armed_70mm_ins", east] call BIS_fnc_spawnVehicle;
	_evacShuttle = _evacShuttleResult select 0;
	_evacShuttleGrp = _evacShuttleResult select 2;
	_evacShuttleGrp setBehaviour "SAFE";
	_evacShuttleGrp setCombatBehaviour "CARELESS";
	_evacShuttleGrp setCombatMode "BLUE";
		
	_evacPos = [_evacPos, 0, 100, 6, 0, 1, 0] call BIS_fnc_findSafePos;
	
	_evacLand = "Land_HelipadEmpty_F" createVehicle _evacPos;
	_evacLand allowDamage false;
	
	_waypoint = _evacShuttleGrp addWaypoint [_evacPos, 0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointSpeed "FULL";

	waitUntil {sleep 1; currentWaypoint _evacShuttleGrp == 2};
	
	_evacShuttle land "LAND";
	_timer = 120;
	[[east, "HQ"],"Шатл прибыл, у вас две минуты на эвакуацию."] remoteExec ["sideChat", 0];
	while {_timer>0} do {
		_timer = _timer - 1;
		_playersToEvac = AllPlayers select {((getPos _x distance2D getPos _evacShuttle) < 500) && (!(_x in _evacShuttle))};
		if (count (_playersToEvac) == 0) then {[[east, "HQ"],"Шатл улетает, в зоне действия нет активных агентов."] remoteExec ["sideChat", 0];break;};
		_playersToEmbark = AllPlayers select {(getPos _x distance2D getPos _evacShuttle) < 5};
		if (count (_playersToEvac) > 0) then {{_x moveIncargo _evacShuttle} forEach _playersToEmbark};
		if (_timer == 60) then {[[east, "HQ"],"60 секунд до вылета, поторопитесь."] remoteExec ["sideChat", 0];};
		if (_timer == 10) then {[[east, "HQ"],"10 секунд до вылета, поспешите на шатл."] remoteExec ["sideChat", 0];};
		if (_timer == 0) then {[[east, "HQ"],"Шатл улетает на корабль."] remoteExec ["sideChat", 0];};
		sleep 1;
	};
	
	_waypoint = _evacShuttleGrp addWaypoint [SuperCarrier, 0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointSpeed "FULL";	
	
	sleep 15;
	
	[[ "", "BLACK OUT", 1 ]] remoteExec ["titleCut", 0,true];
	sleep 2;
	
	{
		deleteVehicle _x;
	}forEach units _evacShuttleGrp;
	
	{
		moveOut _x;
		_x MoveInCargo EvacPelican;
	} forEach crew _evacShuttle;
	
	deleteVehicle _evacShuttle;
	_safePlayers1 = AllPlayers select {_x in EvacPelican};
	_safePlayers2 = AllPlayers select {_x in OSIRIS};
	_safePlayers2 = AllPlayers select {_x inArea TaskTrigger_Finish};
	{
		if (!(_x in _safePlayers1 || _x in _safePlayers2 || _x in _safePlayers3)) then {
			_x setDamage 1;
		};
	};
	[[ "", "BLACK IN", 5 ]] remoteExec ["titleCut", 0,true];
	
};

//Добавление времени на операцию
L_Support_Continuation = {
	if (MSQUADSUPPPOINTS > 250) then {
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 250;
		publicVariable "MSQUADSUPPPOINTS";
		GlobalTimer = GlobalTimer + 1800;
		GlobalTimer = missionNamespace setVariable ["GlobalTimer",GlobalTimer, true];
		publicVariable "GlobalTimer";
		[[east, "HQ"],"Командование согласно держать крейсер в зоне операции еще тридцать минут."] remoteExec ["sideChat", 0];
	} else {
		[[east, "HQ"],"Вам не хватает ресурсов для продления пребывания крейсера в зоне операции."] remoteExec ["sideChat", 0];
	}
};

//Добавление респаунов
L_Support_Tickets = {
	if (MSQUADSUPPPOINTS > 250) then {
		MSQUADSUPPPOINTS = MSQUADSUPPPOINTS - 250;
		publicVariable "MSQUADSUPPPOINTS";
		[east, 10] call BIS_fnc_respawnTickets;
		[[east, "HQ"],"Запрос на подкрепления одобрен. Количество агентов в резерве увеличено на 5."] remoteExec ["sideChat", 0];
	} else {
		[[east, "HQ"],"Запрос подкрепления не одобрен. Мы испытываем нехватку ресурсов."] remoteExec ["sideChat", 0];
	};
};

//Движение статики
G_MoveObject = {
	private _object = _this select 0; // Объект, который вы хотите переместить
	private _startPos = getPos _object; // Начальная позиция объекта
	private _endPos = _this select 1; // Конечная позиция объекта
	private _time = _this select 2; // Время перемещения в секундах
	private _rotate = _this select 3; // Нужно ли вращать объект

	private _step = [(_endPos select 0) - (_startPos select 0), (_endPos select 1) - (_startPos select 1), (_endPos select 2) - (_startPos select 2)] vectorMultiply (1 / _time); // Вычисляем вектор шага

	private _startTime = time;
	while {time - _startTime < _time} do {
		private _t = time - _startTime;
		private _newPos = _startPos vectorAdd (_step vectorMultiply _t);
		_object setPos _newPos;

		if (_rotate) then {
			private _direction = _newPos getDir _endPos; // Рассчитываем направление к конечной точке
			_object setDir _direction; // Устанавливаем это направление для объекта
		};

		sleep 0.01; // Задержка между каждым кадром - можно увеличить для уменьшения нагрузки на процессор
	};
	_object setPos _endPos; // Установите конечную позицию точно, чтобы убедиться, что объект окажется там, куда вы хотели
};

//Создание сигналов
G_Signal_CreateEmitter = {
	params ["_signalEmmiter","_AntennaType"];
	_pos = getPos _signalEmmiter;
	_signalFreq = random [0, 0, 0];
	_EMin = 161;
	_MMin = 101;
	_JMin = 220;
	switch (_AntennaType) do
	{
		case 0 : {_signalFreq = random (60) + _EMin;};
		case 1 : {_signalFreq = random (60) + _MMin;};	
		case 2 : {_signalFreq = random (60) + _JMin;};	
	};
	_signalFreq = round(_signalFreq);
	_moduleGroup = createGroup sideLogic;
	_signalRange = 2000;
	_signalMPos = createVehicle [ "Land_HelipadEmpty_F", _pos, [], 0, "CAN_COLLIDE"];
	_signalEnd = false;
	"spectrumDeviceFunctionality_signalSource" createUnit [
		_pos,
		_moduleGroup,
		"this setVariable ['BIS_fnc_initModules_disableAutoActivation', true, true]; logic = this;"
	];
	logic setVariable ["spectrumDevice_signalSource_Source",str(_signalEmmiter)];
	logic setVariable ["specDev_signalRange",_signalRange];
	logic setVariable ["specDev_signalFrequency",_signalFreq];
	logic setVariable ["specDev_endAction",_signalEnd];
	_signalMPos synchronizeObjectsAdd [logic];
	logic synchronizeObjectsAdd [_signalMPos];
	logic setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];
	logic
};

// Функция передвижение самолета с грузом
G_PlaneMove = {
	params ["_object", "_startPos", "_dropPos", "_endPos"];
	_time = 30;
	_sleep = 0.01;
	private _step = [(_endPos select 0) - (_startPos select 0), (_endPos select 1) - (_startPos select 1), (_endPos select 2) - (_startPos select 2)] vectorMultiply (1 / _time);
	private _sStep = 1500;
	private _vStep = _sStep;
	private _startTime = time;
	_newPos = _startPos;
	_pitchEnd = 30;
	_pitchNeutral = 0;
	_pitchStart = -30;
	_pitch = _pitchStart;
	_coef = 2.8;
	[_object, 0, 0] call BIS_fnc_setPitchBank;
	_incremental = 0;
	while {time - _startTime < _time} do {
		_oldPos = _newPos;
		private _t = time - _startTime;
		_vStep = _vStep - (_sStep/_time*_sleep*_coef);
		private _prePos = _startPos vectorAdd (_step vectorMultiply _t);
		private _newPos = [_prePos, _vStep] call G_CalculateParabolaZ;
		_newPos = [(_newPos select 0), (_newPos select 1), 25 + (_newPos select 2)];
		_object setPosASL _newPos;
		_pitchStep = 0;
		//_pitch = (_pitchStep * (_t - _time));
		if (_vStep < 0 && _vStep > -500) then {
			_timer = _t - 5;
			_pitchStep = (_pitchEnd - _pitchNeutral)/_time*1.3;
			_pitch = _pitchStart + (_pitchStep * _incremental*0.05);
			_incremental = _incremental + 1;
			// Загрузка эффекта частиц (пламени ракеты)
			_particleEffect = "FireBallSmall" createVehicle getPos _object;

			// Установка позиции и направления эффекта частиц
			_particleEffect attachTo [_object]; // Установите позицию эффекта на ракете
			_particleEffect setVectorDirAndUp vectorDir _object; // Установите направление эффекта в направлении ракеты

			// Устанавливаем продолжительность жизни эффекта (в секундах)
			_particleEffect setParticleParams [["\A3\Weapons_F\Explosion\incendiary_02.p3d", 15, 15, 1], [], "Billboard", 1, 0, [0, 0, 0], [0, 0, 0], 0, 0, 0, [0, 0, 0], [0, 0, 0], [0, 0, 0]];

		};
		if (_vStep > 0 && _vStep < 750) then {
			_timer = _t - 5;
			_pitchStep = (_pitchStart - _pitchNeutral)/_time*1.3;
			_pitch = _pitchStart - (_pitchStep * _incremental*0.05);
			_incremental = _incremental + 1;
		};
		if (_vStep == 0) then {_incremental = 0;};
		[_object, _pitch, 0] call BIS_fnc_setPitchBank;
		sleep _sleep;
	};

	// Установите объект на конечную позицию, чтобы избежать неточностей
	deleteVehicle _object;
};

// Функция для вычисления Z на параболе по коэффициентам
G_CalculateParabolaZ = {
    params ["_point", "_inX"];

    _x = _point select 0;
    _y = _point select 1;  
    
	// Расчет Z по коэффициентам
    _z = 0.0005 * _inX ^ 2;
    [_x, _y, _z];
};

//Проверка на эффекты кристаллов
L_CheckCrystals = {
	while {true} do {
		_nearObjs = (player nearObjects 5) select {_x in REDCRYSTS || _x in BLUECRYSTS || _x in GREENCRYSTS || _x in PURPLECRYSTS};
		{
			if (typeOf(_x) in REDCRYSTS) then	{
				inf = player getVariable ['infected', -1];
				player setVariable ['infected',inf+10 , true];
			};
			if (typeOf(_x) in BLUECRYSTS) then {
				_slocation = [getPos _x, 0, 5, 0.1, 0, 20, 0] call BIS_fnc_findSafePos;
				_flocation = [(_slocation select 0),(_slocation select 1),0];
				_tempTarget = createSimpleObject ["Land_HelipadEmpty_F", _flocation];
				[_tempTarget, nil, true] spawn BIS_fnc_moduleLightning;
				deleteVehicle _tempTarget;
			};
			if (typeOf(_x) in GREENCRYSTS) then {
				[_x, 1, "body", "stab"] remoteExec ["ace_medical_fnc_addDamageToUnit", 0];
			};
			if (typeOf(_x) in PURPLECRYSTS) then {
				if (speed _x > 10) then {
					_scriptedCharge = "DemoCharge_Remote_Ammo_Scripted" createVehicle (getPos _x);
					_scriptedCharge setDamage 1;
				};
			};
		} forEach _nearObjs;
		sleep 30;
	};
};

//Проверка на выполнение тасков
G_Base_OpChecks = {
	completedTasks = [];
	while {true} do {
		_allGettedTasks = [];
		{
			_allTasks = _x call BIS_fnc_tasksUnit;
			_allGettedTasks pushBackUnique _allTasks;
		} forEach allPlayers;
		{
			_task = _x;
			_taskState = _task call BIS_fnc_taskCompleted;
			_index = completedTasks find _task;
			if (_index == -1 && _taskState) then {
				completedTasks pushBackUnique _task;
				MSQUADSUPPPOINTS = MSQUADSUPPPOINTS + 250;
				publicVariable "MSQUADSUPPPOINTS";
				[[east, "HQ"],Format ["Отряд, командование увеличило доступные на операцию ресурсы. У вас на счету: %1", MSQUADSUPPPOINTS]] remoteExec ["sideChat", 0];
			};
		} forEach _allGettedTasks;
		sleep 30;
	};
};

//Эвакуация трофейной техники и солдат
CSATFORCES_ACCEPTIONS = {
	_Acceptions = [["Men", 150],["Car", 500],["Air", 2000],["Armored", 1500]];
	_Crystals = [["Green", 50],["Blue", 150],["Purple", 100],["Red", 250]];
	_value = 0;
	While {true} do {
		_getUnits = allUnits inAreaArray AcceptUnitTrigger;
		//Поиск класса предмета
		{
			_unit = _x;
			_type = getText (configfile >> "CfgVehicles" >> typeOf (_unit) >> "vehicleClass");
			_fact = getText (configfile >> "CfgVehicles" >> typeOf (_unit) >> "faction");
			if (_fact != "CIV_F" && _fact != "CSAT_Winter" && _fact != "Default") then 
			{
				{
					_ctype = _x select 0;
					if (_type == _ctype) then 
					{
						_value = _value + (_x select 1);
						deleteVehicle _unit;
					};
				} forEach _Acceptions;
				{
					_text = _x select 0;
					_text = "TG_Tiberium" + _text;
					if (_text in (typeOf (_unit))) then 
					{
						_value = _value + (_x select 1);
						deleteVehicle _unit;
					};
				} forEach _Crystals;
			}
		} forEach _getUnits;
		//Если не найден, то поиск в слове
		if (_value > 0) then {
			MSQUADSUPPPOINTS = MSQUADSUPPPOINTS + _value; 
			publicVariable "MSQUADSUPPPOINTS";
			[[east, "HQ"], "С.П.Е.К.Т.Р. мы приняли посылку от вас, средства перечислены на ваш счет."] remoteExec ["sideChat", 0];
		};
		sleep 5;
	};
};