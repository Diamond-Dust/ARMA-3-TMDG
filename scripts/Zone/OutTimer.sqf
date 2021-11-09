#include "\a3\ui_f\hpp\definecommongrids.inc"

TMDG_out_of_bounds = {
	params ["_timer"];

	[(format ["<t color='#ff0000' size='.8'>Warning!<br />You have %1 seconds to re-enter the playable area.</t>", _timer]),0,GUI_GRID_TOPCENTER_Y + 0 * GUI_GRID_TOPCENTER_H,1,0,0,800] spawn BIS_fnc_dynamicText;
};

TMDG_update_timer_out = {
	params ["_time"];
	with uiNamespace do
	{
		waitUntil {!isNull findDisplay 46};
		disableSerialization;
		_ctrl = findDisplay 46 displayCtrl 40002;
		_ctrl ctrlSetStructuredText parseText format ["<t size='1' valign='middle' align='center' color='#ee0000'>%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString];
		_ctrl ctrlCommit 0;
	};
};

TMDG_update_timer_in = {
	params ["_time", "_timer_max_value"];
	with uiNamespace do
	{
		waitUntil {!isNull findDisplay 46};
		disableSerialization;
		_ctrl = findDisplay 46 displayCtrl 40002;
		_ctrl ctrlSetStructuredText parseText format ["<t size='1' valign='middle' align='center'>%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString];
		if (_time == _timer_max_value) then {
			_ctrl ctrlSetStructuredText parseText format ["<t size='1' valign='middle' align='center'>%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString];
		} else {
			_ctrl ctrlSetStructuredText parseText format ["<t size='1' valign='middle' align='center' color='#00ff00'>%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString];
		};
		_ctrl ctrlCommit 0;
	};
};

_isOut = [_this, 0, false] call BIS_fnc_param;

if (playableInZone) then
{
	if (_isOut) then {
		_timer_kill = timer_kill_limit;
		
		while {_timer_kill > 0} do
		{
			_timer_kill = _timer_kill - 1;
			_backInZone = [trig_play_area, player] call BIS_fnc_inTrigger;//checks if player re entered the zone
			[(format ["<t color='#ff0000' size='.7'>Warning!<br />You have %1 seconds to re-enter the playable area.</t>", _timer_kill]),0,GUI_GRID_TOPCENTER_Y + 0.033 * safezoneH,1,0,0,800] spawn BIS_fnc_dynamicText;
			[_timer_kill] call TMDG_update_timer_out;
			if (_backInZone) then 
			{
				timer_kill_limit = _timer_kill;
				break;
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
	} else {
		while {timer_kill_limit < timer_kill_base_value} do
		{
			timer_kill_limit = timer_kill_limit + 1;
			_backInZone = [trig_play_area, player] call BIS_fnc_inTrigger;//checks if player re entered the zone
			[timer_kill_limit, timer_kill_base_value] call TMDG_update_timer_in;
			if (!_backInZone) then 
			{
				break;
			};
			sleep 1;
		};
	};
};