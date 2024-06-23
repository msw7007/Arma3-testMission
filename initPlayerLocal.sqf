params ["_player", "_didJIP"];

///Общая инициализация
if (!(hasInterface || isNull _player)) exitWith {};
InterfaceLine = "";
waitUntil {((!isNull _player && isPlayer _player) && ("SERVER IDLE" == missionNamespace getVariable ["SERVER_STATE",""]))};
_clOwner = owner _player;
sleep 5;

MOBACTIVE = missionNamespace getVariable ["MOBACTIVE",false];
if (MOBACTIVE) then {
///Старт скриптов относящихся к МОБ
#include "Spectr\func_MOB.sqf"
call L_Camp_UpdateStatus;
call L_CheckCrystals;
[_player] spawn L_Strats_Check;
};

///Старт скриптов относящихся к миссии/кампании
#include "Spectr\func_MISSIONS.sqf"
call CAMPAIGN_Info;

///Старт скриптов относящихся к стелсу
#include "Spectr\func_UNDERCOVER.sqf"
waitUntil {missionNamespace getVariable ["COVERSYSTEMACTIVE",false]};
[] spawn UNDERCOVER_Init;
sleep 60;
[] spawn {
  while{true} do {
	_clOwner = owner player;	
	[] spawn UNDERCOVER_getSummarizePlayerData;
	
	ALLVIED = missionNamespace getVariable ["ALLVIED",[]];
	if (count ALLVIED > 0) then {
		[player, ALLVIED, 3] spawn L_CHECKNEARVIED;
	};
	sleep 5;
  };
};