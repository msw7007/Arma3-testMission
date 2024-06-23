UNDERCOVER_Init = {
	AI_GlobalWarning = 0;
	AI_METHODS = ["SUCCESS","REMEMBERED","ARRESTED","OVERT"];
	PlayersSide = east;
	PlayerGroup = group (selectRandom AllPlayers);
	CurrentCheck = false;
	U_UNSUSWEAPON = ["WBK_axe","ACE_Flashlight_Maglite_ML300L","Shovel_Russian_Rotated","Shovel_Russian","Axe","WBK_SmallHammer","hgun_esd_01_F"];
	//Получить список вражеских фракций
	//Для каждой фракции получить шмот
	U_FACTIONEQ = [];
	CHECKFACTIONS = [];
	player setVariable ["CURRENT_FACTION", "PlayerGroup", true];
	player setVariable ["UnderCoverSpot",0,true];
	ENEMYONLYFACTIONS = missionNamespace getVariable ["ENEMYFACTIONS",[]];
	{
		CHECKFACTIONS pushBackUnique (_x select 0);
	} forEach ENEMYONLYFACTIONS;
	CHECKFACTIONS pushbackUnique "CIV_F";
	{
		_itemsFaction = [_x] call UNDERCOVER_Init_GetAllowedArray;
		U_FACTIONEQ pushbackUnique _itemsFaction;
	} forEach CHECKFACTIONS;
	ForbidenEq = ["CSAT_Winter"] call UNDERCOVER_Init_GetForbidenArray;
	player addAction ["Взять униформу", {
		_target = cursorTarget;
		if (_target isKindOf "Man" && !alive _target && (side _target) != side player && (uniform _target) != "") then {
			player forceAddUniform (uniform _target);
			removeUniform _target;
			hint "Вы взяли униформу противника";
		} else {
			hint "Вокруг нет противника с униформой";
		}
	}, [], 1.5, false, true, "", "cursorTarget isKindOf 'Man' && !alive cursorTarget && (side cursorTarget) != side player && (uniform cursorTarget) != ''"];
	while {true} do {
		_eSides = PlayersSide call BIS_fnc_enemySides;
		_AIlist = AllUnits select {side _x in _eSides && _x getVariable ["checkBlocked", 0] > 0};
		{
			_AIBlocked = _x getVariable ["checkBlocked",0];
			_AIBlocked = _AIBlocked - 1; 
			_x setVariable ["checkBlocked", _AIBlocked, true];
		} foreach _AIlist;
		sleep 1;
	};
};
UNDERCOVER_Init_GetAllowedArray = {
	params ["_faction"];
	waitUntil {!(isNil "_faction")};
	_codeSide = getNumber(configfile >> "CfgFactionClasses" >> _faction >> "side");
	_efs = "getNumber (_x >> 'side') == _codeSide && getText (_x >> 'faction') == _faction && getText (_x >> 'vehicleClass') ==  'Men'" configClasses (configfile >> "CfgVehicles");
	_allowedEquipment = []; 
	 { 
	  _unit = configName _x; 
	  _unitItems = getArray (configfile >> "CfgVehicles" >> _unit >> "linkedItems"); 
	  _unitWeapons = getArray (configfile >> "CfgVehicles" >> _unit >> "weapons"); 
	  _uniformClass = getText (configfile >> "CfgVehicles" >> _unit >> "uniformClass"); 
	  { 
		_allowedEquipment pushbackUnique _x; 
	  } forEach _unitItems; 
	  { 
		_allowedEquipment pushbackUnique _x; 
	  } forEach _unitWeapons; 
	  _allowedEquipment pushbackUnique _uniformClass; 
	 } forEach _efs; 
	 [_faction,_allowedEquipment];
};
UNDERCOVER_Init_GetForbidenArray = {
	params ["_faction"];
	waitUntil {!(isNil "_faction")};
	_codeSide = getNumber(configfile >> "CfgFactionClasses" >> _faction >> "side");
	_efs = "getNumber (_x >> 'side') == _codeSide && getText (_x >> 'vehicleClass') ==  'Men'" configClasses (configfile >> "CfgVehicles");
	_Equipment = []; 
	 { 
	  _unit = configName _x; 
	  _unitItems = getArray (configfile >> "CfgVehicles" >> _unit >> "linkedItems"); 
	  _unitWeapons = getArray (configfile >> "CfgVehicles" >> _unit >> "weapons"); 
	  _uniformClass = getText (configfile >> "CfgVehicles" >> _unit >> "uniformClass"); 
	  { 
		_Equipment pushbackUnique _x; 
	  } forEach _unitItems; 
	  { 
		_Equipment pushbackUnique _x; 
	  } forEach _unitWeapons;
	  if (_uniformClass != "") then {
		_Equipment pushbackUnique _uniformClass;
	  };
	 } forEach _efs; 
	 _Equipment;
};
UNDERCOVER_CheckItemSide = {
	params ["_clothType", "_faction"];
	_isCiv = 0;
	_allowedEq = [];
	{ 
	  _side = _x select 0; 
	  if (_side == _faction) then  { 
	   _allowedEq = _x select 1; 
	   if (_allowedEq find _clothType >= 0 || _clothType == "") then {_isCiv = 1;}; 
	   if (U_UNSUSWEAPON find _clothType >= 0 || _clothType == "")then {_isCiv = 1;}; 
	   if (ForbidenEq find _clothType >= 0) then {_isCiv = -1;};  
	  }; 
	} forEach U_FACTIONEQ; 
	_isCiv
};
UNDERCOVER_getMaskedPlayerData = {
	params ["_faction"];
	_maskPoint = 0;
	//Получить данные по униформе
	if ([uniform player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 4;};
	if ([uniform player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 4;};
	//Получить данные по желету
	if ([vest player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 2;};
	if ([vest player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 2;};
	//Получить данные по рюкзаку
	if ([backpack player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 2;};
	if ([backpack player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 2;};
	//Получить данные по шлему
	if ([headgear player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 3;};
	if ([headgear player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 3;};
	//Получить даныне по ПНВ
	if ([hmd player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 2;};
	if ([hmd player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 2;};
	//Получить данные по оружию
	if ([primaryWeapon player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 4;};
	if ([primaryWeapon player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 4;};
	//Получить данные по пистолетам
	if ([handgunWeapon player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 3;};
	if ([handgunWeapon player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 3;};
	//Получить данные по установкам
	if ([secondaryWeapon player, _faction] call UNDERCOVER_CheckItemSide == 1) then {_maskPoint = _maskPoint + 5;};
	if ([secondaryWeapon player, _faction] call UNDERCOVER_CheckItemSide == -1) then {_maskPoint = _maskPoint - 5;};
	_maskPoint;
};
UNDERCOVER_getWatchedPlayerData = {
	params ["_faction"];
	_stance = stance Player;
	_watched = player getVariable ["UnderCoverSpot",0];
	AI_GlobalWarning = missionNamespace getVariable ["AI_GlobalWarning", AI_GlobalWarning];
	{ 
		{
			_commander = _x;
			_side = _commander select 0; 
			if (_side == _faction) then {
				_aiW = _commander select 1; 
				AI_GlobalWarning = AI_GlobalWarning + _aiW;
			};
		} forEach ENEMYFACTIONS;
	} forEach U_FACTIONEQ;
	_watched = _watched + AI_GlobalWarning;
	publicVariable "AI_GlobalWarning";
	_vehicle = vehicle player;
	_nearObjects = player nearObjects 5;
	_nearCorpses = _nearObjects select {!alive _x};
	_nearExplosives = _nearObjects select {getNumber (configfile >> "CfgAmmo" >> typeOf _x >> "explosive") == 1};
	//игрок ползает?
	if (stance player == "CROUCH") then {_watched = _watched + 2;};
	//игрок присел?
	if (stance player == "PRONE") then {_watched = _watched + 4;};
	//игрок бежит?
	if (speed player > 17 && _vehicle == player) then {_watched = _watched + 3;};
	//игрок быстро двигается по земле?
	if (speed _vehicle > 40 && _vehicle != player) then {_watched = _watched - 10;};
	//игрок не в гражданской машине или в машине, не принадлежащей мониторящей фракции?
	if (getNumber(configFile >> "CfgVehicles" >> typeOf _vehicle >> "side") != 3 && getText(configFile >> "CfgVehicles" >> typeOf _vehicle >> "faction") != _faction && _vehicle != player) then {_watched = _watched + 24;};
	//игрок кидает стреляет?
	if (player getVariable ("shooted")) then {_watched = _watched + 20;};
	//игрок рядом с трупом?
	if (count _nearCorpses > 0) then {_watched = _watched + 2;};
	//игрок рядом со взрывчаткой?
	if (count _nearExplosives > 0) then {_watched = _watched + 5;};	
	//Расчитать итоговое значение
	_watched
};
UNDERCOVER_getFactionValue = {
	params ["_faction"];
	_val = 0;
	{
		if (_x == _faction) then {
			_val = ([_x] call UNDERCOVER_getMaskedPlayerData) - ([_x] call UNDERCOVER_getWatchedPlayerData);
		};
	} forEach CHECKFACTIONS;
	_val
};
UNDERCOVER_PlayerDetected = {
	params ["_faction"];
	CFEQ = [];
	CF = "";
	Index = 0;
	{
		if (_x select 0 == _faction) then  {
			Index = CHECKFACTIONS find _x;
			CF = _x select 0;
			CFEQ = _x select 1;
			
		};
	} forEach CHECKFACTIONS;
	AI_GlobalWarning = missionNamespace getVariable ["AI_GlobalWarning",AI_GlobalWarning];
	{ 
		{
			_commander = _x;
			_side = _commander select 0; 
			if (_side == _faction) then {
				_aiW = _commander select 7; 
				AI_GlobalWarning = AI_GlobalWarning + _aiW + 1;
			};
		} forEach ENEMYFACTIONS;
	} forEach U_FACTIONEQ;
	AI_GlobalWarning = AI_GlobalWarning + 1;
	U_FACTIONEQ pushBackUnique [_faction,AI_GlobalWarning];
	publicVariable "U_FACTIONEQ";
	CFEQ deleteAt (CFEQ find uniform player);
	CFEQ deleteAt (CFEQ find vest player);
	CFEQ deleteAt (CFEQ find backpack player);
	CFEQ deleteAt (CFEQ find headgear player);
	_UnderCoverSpot = player getVariable ["UnderCoverSpot",0];
	_UnderCoverSpot = _UnderCoverSpot + 1; 
	CHECKFACTIONS deleteAt Index;
	CHECKFACTIONS pushBackUnique [CF,CFEQ];
	player setVariable ["UnderCoverSpot", _UnderCoverSpot, true];
};
UNDERCOVER_getPlayerDetectionData = {
	params ["_multDetect","_incomeText"];
	_AIlist = player nearEntities ["Man", 75];
	_outString = _incomeText;
	_AIlist = _AIlist select {side _x == side player && side _x != civilian};
	if (count _AIlist > 0) then {
		_eSides = east call BIS_fnc_enemySides;
		_AIlist = _AIlist select {side _x in _eSides && _x getVariable ["checkBlocked", 0] == 0};
		_docCheckUnit = objNull;
		_susValue = 0;
		{
			_AIUnit = _x;
			_check = !(lineIntersects [eyePos _AIUnit, getPos Player]) && !(terrainIntersect [eyePos _AIUnit, getPos Player]);
			if (_check) then {
				_outString = "ЗАМЕЧЕН";
				_spotVal = _AIUnit getVariable ["PlayerSpot", 0];
				_spotVal = _spotVal + 5 + _multDetect;
				if (_spotVal >= 100 && !CurrentCheck) then {
					_docCheckUnit = _AIUnit;
					CurrentCheck = true;
					_faction = getText(configfile >> "CfgVehicles" >> typeOf (_AIUnit) >> "faction");
					_susValue = [_faction] call UNDERCOVER_getFactionValue;
				};
				_AIUnit setVariable ["PlayerSpot", _spotVal, 0];
			};
		} foreach _AIlist;
		if (!(isNull _docCheckUnit) && CurrentCheck && _susValue <= 15) then {
			{
				_x setVariable ["checkBlocked", 300, true];
				_x setVariable ["PlayerSpot", 0, true];
			} foreach _AIlist;
			_docCheckUnit setDir ([_docCheckUnit, player] call BIS_fnc_dirTo);
			3 cutText ["Предьявите документы.", "Plain Down", 2];
			_outString = [_docCheckUnit] remoteExec ["UNDERCOVER_DocumentsCheck", owner player];
		};
	};
	HINT _outString;
	_outString;
};
UNDERCOVER_DocumentsCheck = {
	params ["_soldier"];
	sleep 4;
	3 cutText ["Предьявите документы или мы примем меры.", "Plain Down", 2];
	[player, "DOCUMENTSCHECKAI", ["Противник подозревает вас и хочет проверить документы", "Проверка документов", ""], _soldier, true] call BIS_fnc_taskCreate;
	_distOld = getPos _soldier distance (getPos player);
	_DistNew = _distOld;
	_i = 0;
	_Desition = "OVERT";
	_result = "";
	while {_DistNew <= _distOld} do {
		_distOld = _DistNew;
		sleep 1;
		_i = _i + 1;
		_DistNew = getPos _soldier distance (getPos player);
		if (_DistNew < 3) then {
			3 cutText ["Секундочку, мы сейчас всё проверим.", "Plain Down", 2];
			sleep 5;
			_Desition = selectRandom AI_METHODS;
			break;
		};
		if (_i >= 30) then {
			break;
		};
	};
	_faction = getText(configfile >> "CfgVehicles" >> typeOf (_soldier) >> "faction");
	["DOCUMENTSCHECKAI"] call BIS_fnc_deleteTask;
	switch (_Desition) do
	{
		case "SUCCESS" 		: {
			3 cutText ["Отлично, документы в порядке, вы свободны.", "Plain Down", 2];
			_result = "УСПЕШНАЯ ПРОВЕРКА";
		};
		case "REMEMBERED" 	: {
			3 cutText ["Вроде всё нормально, но здесь неверно заполнены пара граф.", "Plain Down", 2];
			_UnderCoverSpot = player getVariable ["UnderCoverSpot",0];
			_UnderCoverSpot = _UnderCoverSpot + 1; 
			player setVariable ["UnderCoverSpot", _UnderCoverSpot, 0];
			_result = "ВАС ЗАПОМНИЛИ";
		};
		case "ARRESTED" 	: {
			3 cutText ["Подделка! Вы арестованы", "Plain Down", 2];
			[_faction]call UNDERCOVER_PlayerDetected;
			["ace_captives_setHandcuffed", [player, true], player] call CBA_fnc_targetEvent;
			_result = "АРЕСТОВАН";
		};
		case "OVERT" 		: {
			3 cutText ["Нарушитель! Огонь!", "Plain Down", 2];
			[_faction]call UNDERCOVER_PlayerDetected;
			call UNDERCOVER_PlayerDetected;
			player setVariable ["OVERTED", 60, 0];
			_result = "РАСКРЫТ";
		};
	};
	CurrentCheck = false;
	_result;
};

UNDERCOVER_getSummarizePlayerData = {
	//Расчитать суммарное значение игрока
	_curM = 0;
	_curW = 0;
	_maxFac = 0;
	_mimicryFaction = "CSAT_Winter";
	{
		_addVal = [_x] call UNDERCOVER_getMaskedPlayerData;
		if (_addVal >= _maxFac) then {_maxFac = _addVal; _mimicryFaction = _x;_curM = _maxFac;};
	} forEach CHECKFACTIONS;
	{
		if (_mimicryFaction == _x) then {_curW = [_x] call UNDERCOVER_getWatchedPlayerData;};
	} forEach CHECKFACTIONS;	
	_fVal = _curM - _curW;
	_fString = "";
	//Расчет данных по подозрительности игрока
	if (_fVal >= 15 && player getVariable ["OVERTED", 0] == 0 && (player getVariable ["CURRENT_FACTION", _mimicryFaction] != _mimicryFaction)) then {
		//получить сторону от фракции
		_codeSide = getNumber(configfile >> "CfgFactionClasses" >> _mimicryFaction >> "side");
		_CheckSide = east;
		switch (_codeSide) do
		{
			case 0 : {_CheckSide = east;};
			case 1 : {_CheckSide = west;};
			case 2 : {_CheckSide = independent;};
			case 3 : {_CheckSide = civilian;};
		};
		[player] joinSilent createGroup _CheckSide;
		player setVariable ["CURRENT_FACTION", _mimicryFaction, true];
		_fString = "ПОДОЗРИТЕЛЕН"; 
		if (_fVal >= 20) then {
		_fString = "ИНКОГНИТО"; 
		} 
		else 
		{
			_dectVal = 20 - _fVal;
			_fString = [_dectVal,_fString] call UNDERCOVER_getPlayerDetectionData;
		};
	} else {
		if (player getVariable ["CURRENT_FACTION","PlayerGroup"] != "PlayerGroup") then {
            [player] joinSilent PlayerGroup;
            player setVariable ["CURRENT_FACTION", "PlayerGroup", true];
        }
	};
	if (player getVariable ["OVERTED", 0] > 0) then {
		_overted = (player getVariable ["OVERTED", 0]) - 1;
		player setVariable ["OVERTED", _overted, 0];
	};
	if (CurrentCheck) then {_fString = "ПРОВЕРКА"};
	HINT _fString;
	_fString
};