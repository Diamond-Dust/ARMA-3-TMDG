TMDG_create_timer_out = {
	params ["_time"];
	with uiNamespace do
	{	
		waitUntil {!isNull findDisplay 46};
		disableSerialization;
		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", 40002];
		_ctrl ctrlSetPosition [safezoneX+0.475*safezoneW,safezoneY+0.98*safezoneH,0.05*safezoneW,0.02*safezoneH];
		_ctrl ctrlSetStructuredText parseText format ["<t size='1' align='center'>%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString];
		_ctrl ctrlSetTextColor [0.9,0.9,0.9,1];
		_ctrl ctrlSetBackgroundColor [0.1,0.1,0.1,0.9];
		_ctrl ctrlCommit 0;
	};
};

if isServer then 
{ 
	civiliangroup = createGroup civilian; 
	publicVariable "civiliangroup";
};

isOut = true;

timer_kill_base_value = ["ShootingTimer", 40] call BIS_fnc_getParamValue; 
timer_kill_limit = timer_kill_base_value;
[timer_kill_limit] remoteExec ["TMDG_create_timer_out"];
publicVariable "timer_kill_base_value";
publicVariable "timer_kill_limit";

null = [] execVm "scripts\Zone\ShrinkZone.sqf";
null = [] execVm "scripts\Weapons\PlaceWeapons.sqf";
//null = [] execVm "scripts\Zone\OutTimer.sqf";
{[] execVM "scripts\Dogs\Dogs.sqf"} remoteExec ["bis_fnc_call", east]; 
