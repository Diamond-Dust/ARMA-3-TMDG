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

while {timer_kill_limit < timer_kill_base_value} do
{
    timer_kill_limit = timer_kill_limit + 1;
	[timer_kill_limit, timer_kill_base_value] call TMDG_update_timer_in;
	sleep 1;
};
