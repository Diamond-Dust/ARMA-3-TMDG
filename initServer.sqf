base_play_area = 1000; 
publicVariable "base_play_area";

waitUntil {time > 0};
null = [] execVm "scripts\Spawn\RandomSpawn.sqf";
{[] execVM "scripts\Dogs\Dogs.sqf"} remoteExec ["bis_fnc_call", east]; 