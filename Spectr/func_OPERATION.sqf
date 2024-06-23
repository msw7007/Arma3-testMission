Operation_INI = 
{
	DataGetted = false; publicVariable "DataGetted";
	[DataServer,												// Object the action is attached to
	"Вывести сервер в сеть",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 2",						// Condition for the action to be shown
	"_caller distance _target < 2",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{
		DataGetted = true; publicVariable "DataGetted";
	},													// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	10,													// Action duration [s]
	0,													// Priority
	true,												// Remove on completion
	false												// Show in unconscious state 
	] remoteExec ["BIS_fnc_holdActionAdd", 0, DataServer];
};