///Сверка на то, что обратился сервер
if (!(isServer)) exitWith {};

///Установка общих значений
MISSIONSPECIALZONES = []; 
iZones = [];
PortalId = 0;
SERVER_STATE = "INIT";
publicVariable "SERVER_STATE";

///Настройка зоны операции
OPCENTRALZONE = getPos Osiris;							//Где находится центр операции
OPZONERAD = 5000;												//Радиус операции
SERVER_STATE = "BASIS READY";			
publicVariable "SERVER_STATE";

///Настройка и запуск МОБ игрока
#include "Spectr\func_MOB.sqf"
MOBACTIVE = true;
publicVariable "MOBACTIVE";
if (MOBACTIVE) then {
	MSQUADSUPPPOINTS = 1000; 		
	publicVariable "MSQUADSUPPPOINTS";										//Количество очков на старте
	PARADROPVEHICLE = "ORCA_UNARMED_WINTER_HEX"; 							//Класс вертушки, которая доставляет по координатам
	DROPVEHICLE = "USAF_C17"; 												//Класс грузового вертолёта
	remoteExec ["G_CampInit", 2];											//Инициализация МОБ
	SERVER_STATE = "MOB READY";			
	publicVariable "SERVER_STATE";
};

///Настройка и запуск систем окружения
#include "Spectr\func_ENVIROMENT.sqf"
//Настройка видов кристаллов
BLUECRYSTS = ["TG_TiberiumBlue_1_Mature","TG_TiberiumBlue_2_Mature","TG_TiberiumBlue_3_Mature","TG_TiberiumBlue_4_Mature","TG_TiberiumBlue_5_Mature"];
GREENCRYSTS = ["TG_TiberiumGreen_1_Mature","TG_TiberiumGreen_2_Mature","TG_TiberiumGreen_3_Mature","TG_TiberiumGreen_4_Mature","TG_TiberiumGreen_5_Mature"];
REDCRYSTS = ["TG_TiberiumRed_1_Mature","TG_TiberiumRed_2_Mature","TG_TiberiumRed_3_Mature","TG_TiberiumRed_4_Mature","TG_TiberiumRed_5_Mature"];
PURPLECRYSTS = ["TG_TiberiumPurple_1_Mature","TG_TiberiumPurple_2_Mature","TG_TiberiumPurple_3_Mature","TG_TiberiumPurple_4_Mature","TG_TiberiumPurple_5_Mature"];
ANOMALY_ACTIVE = true; 												//Включить аномалии сталкера
ALLOWEDANOMALIES = ["M","E","S","B","P","T","F"];						//Типы аномалий
INFECTED_ACTIVE = true; 												//Включить зараженных
AnoSpawn = 4;															//Количество аномальных зон
ALLOWEDINFECTIONS = ['TB','ST','SP','PA','JU','HE','BO','SC','BOSS'];	//Типы зараженных
TIMETOCLEAR = 150;														//Сколько нужно продержаться в зоне зараженных для зачистки зоны
MutSpawn = 4;															//Количество зараженных зон
FREECRYSTS_ACTIVE = true;												//Включить базовые залежи кристалов
ResSpawn = 4;															//Количество ресурсных зон
DigSpawn = 4;															//Количество копательных зон													
///Инициализация зон фантастического окружения
INFCONTROLZONES = []; 													//Зоны под контролем зараженных
ANOCONTROLZONES = [];													//Зоны аномалий
RESCONTROLZONES = [];													//Зоны ресурсов
DIGCONTROLZONES = [];													//Зоны раскопок
AllDHDs = [];															//Список всех ДХД
if (ANOMALY_ACTIVE) then {
	[AnoSpawn] spawn AnoEnviroment_CreateAnomalyZones;
}; 
if (INFECTED_ACTIVE) then {
	[MutSpawn] spawn AnoEnviroment_CreateMutantZones;
};
if (FREECRYSTS_ACTIVE) then {
	[ResSpawn] spawn AnoEnviroment_CreateResourceZones;
	[DigSpawn] spawn AnoEnviroment_CreateDigZones;	
};
waitUntil {((Count INFCONTROLZONES) == MutSpawn || !INFECTED_ACTIVE) && ((Count ANOCONTROLZONES) == AnoSpawn || !ANOMALY_ACTIVE) && ((Count RESCONTROLZONES) == ResSpawn || !FREECRYSTS_ACTIVE) && ((Count DIGCONTROLZONES) == DigSpawn || !FREECRYSTS_ACTIVE)};
SERVER_STATE = "ANOMALY READY";			
publicVariable "SERVER_STATE";

///Настройка и запуск вражеских фракций и их командования
ENEMYSYSTEMACTIVE = true;
TENSIONPOINTS = [];
publicVariable "ENEMYSYSTEMACTIVE";
if (ENEMYSYSTEMACTIVE) then {
	#include "Spectr\func_ENEMY.sqf"
	CAPTUREVALUE = 300;
	TENSIONWEIGHLOSS = 5;
	BASICRETREAT = 50;
	//Разрешенный тип локаций для всех баз
	ENEMYFACTIONSEXCL = ["TG_Faction_GDI","TG_Faction_NOD","TG_Faction_Forgotten","TG_Faction_Empty","TG_Faction_Civilian","TG_TIBERIAN_GENESIS_MODULE_CAT","min_rf","OPF_T_F"];
	//Инициализонные массивы вражеских фракций
	JamersArray = [];
	[] spawn G_ENEMYFORCES_Init;
	SERVER_STATE = "ENEMY READY";			
	publicVariable "SERVER_STATE";
};

///Настройка системы "работы под прикрытием"
COVERSYSTEMACTIVE = true;
publicVariable "COVERSYSTEMACTIVE";
if (COVERSYSTEMACTIVE) then {
	AI_GlobalWarning = 0;    		publicVariable "AI_GlobalWarning";		//Глобальная настороженность ИИ
	SERVER_STATE = "UNDERCOVER READY";			
	publicVariable "SERVER_STATE";
};

sleep 1;
SERVER_STATE = "SERVER IDLE";			
publicVariable "SERVER_STATE";
#include "Spectr\func_OPERATION.sqf"
[] spawn Operation_INI;
