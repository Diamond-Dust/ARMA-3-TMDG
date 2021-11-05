if isServer then 
{ 
	civiliangroup = createGroup civilian; 
	publicVariable "civiliangroup";
};

base_play_area = 1000; 
publicVariable "base_play_area";

timer_kill_base_value = ["ShootingTimer", 40] call BIS_fnc_getParamValue; 
timer_kill_limit = timer_kill_base_value;
publicVariable "timer_kill_base_value";
publicVariable "timer_kill_limit";

isOut = false;

null = [] execVm "scripts\Zone\ShrinkZone.sqf";
null = [] execVm "scripts\Weapons\PlaceWeapons.sqf";
null = [] execVm "scripts\Spawn\RandomSpawn.sqf";
{[] execVM "scripts\Dogs\Dogs.sqf"} remoteExec ["bis_fnc_call", east]; 