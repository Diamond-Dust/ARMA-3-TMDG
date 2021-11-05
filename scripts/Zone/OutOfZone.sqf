#include "\a3\ui_f\hpp\definecommongrids.inc"

TMDG_out_of_bounds = {
	params ["_timer"];

	[(format ["<t color='#ff0000' size='.8'>Warning!<br />You have %1 seconds to re-enter the playable area.</t>", _timer]),0,GUI_GRID_TOPCENTER_Y + 0 * GUI_GRID_TOPCENTER_H,1,0,0,800] spawn BIS_fnc_dynamicText;
};

_timer_kill = timer_kill_limit;

//hint format ["%1", playableInZone];

if (playableInZone) then
{
	while {_timer_kill > 0} do
	{
		//hintSilent format ["You have %1 seconds to re-enter the playable area", _timer_kill];
		//(_timer_kill) remoteExec ["TMDG_out_of_bounds"];
		[(format ["<t color='#ff0000' size='.8'>Warning!<br />You have %1 seconds to re-enter the playable area.</t>", _timer_kill]),0,GUI_GRID_TOPCENTER_Y + 0 * GUI_GRID_TOPCENTER_H,1,0,0,800] spawn BIS_fnc_dynamicText;
		_timer_kill = _timer_kill - 1;
		_backInZone = [trig_play_area, player] call BIS_fnc_inTrigger;//checks if player re entered the zone
		if (_backInZone) exitWith 
		{
			//hint "Back in zone"; 
			_keepAlive = true;
			timer_kill_limit = _timer_kill;
		};//if the player did re enter the zone then exit the loop/script
		sleep 1;
	};
	if (_timer_kill == 0) then
	{
		playSound3D [
			"A3\Sounds_F\weapons\ebr\ebr_st_6.wss",
			player,
			false,
			getPosASL player,
			5,
			1.0,
			0
		];
		sleep 0.25;
		player setDammage 1;//if the timer runs out/hits 0 then it will kill the player
	};
};