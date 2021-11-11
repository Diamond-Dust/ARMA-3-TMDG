TMDG_keyspressed_dog = {
	_shift =_this select 2;
	_handled = false;
	switch (_this select 1) do {

	case 35: {//H key
			if (_shift) then {
				_tctrl = (findDisplay 46) displayCtrl 40003;
				_tctrl ctrlShow !(ctrlShown _tctrl);
			};
		};
	};
	_handled;
};

TMDG_create_timer_dog = {
	params ["_time"];
	
	_size_multiplier = (30/11) * (getResolution select 5)/1.5;
	
	with uiNamespace do
	{	
		waitUntil {!isNull findDisplay 46};
		disableSerialization;
		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", 40003];
		(findDisplay 46) displayAddEventHandler ["KeyDown","_this call TMDG_keyspressed_dog"];
		_ctrl ctrlSetStructuredText parseText format ["<t size='%3' align='center'><img size='%3' color='#ffffff' image='%2' />%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, getMissionPath "icons\dog2.paa", _size_multiplier];
		_h = (ctrlTextHeight _ctrl)/3;
		_w = (ctrlTextWidth _ctrl);
		_ctrl ctrlSetPosition [
			safezoneX+(1.0-_w)*safezoneW,
			safezoneY +(0.5-_h/2)*safezoneH,
			_w*safezoneW,
			_h*safezoneH
		];
		_ctrl ctrlSetTextColor [0.9,0.9,0.9,1];
		_ctrl ctrlSetBackgroundColor [0.1,0.1,0.1,0.9];
		_ctrl ctrlCommit 0;
	};
};

TMDG_update_timer_dog = {
	params ["_time"];
	
	_size_multiplier = (30/11) * (getResolution select 5)/1.5;
	
	with uiNamespace do
	{
		_ctrl = findDisplay 46 displayCtrl 40003;
		if (_time <= 10) then {
			_ctrl ctrlSetStructuredText parseText format ["<t size='%3' color='#bb0000' align='center'><img size='%3' color='#bb0000' image='%2' />%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, getMissionPath "icons\dog2.paa", _size_multiplier];
		} else {
			_ctrl ctrlSetStructuredText parseText format ["<t size='%3' align='center'><img color='#ffffff' size='%3' color='#ffffff' image='%2' />%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, getMissionPath "icons\dog2.paa", _size_multiplier];
		};
		_ctrl ctrlCommit 0;
	};
};

waitUntil {time > 0};
if ( playerSide != east ) exitWith {}; 

_timer_base_value = ["PingTimer", 180] call BIS_fnc_getParamValue;
_dog_accuracy = ["PingAccuracy", 50] call BIS_fnc_getParamValue;
_dog_chance = ["PingChance", 50] call BIS_fnc_getParamValue;

if (_dog_accuracy != -1) then {
	_current_markers = [];
	
	_warmup_timer = 5;
	[_warmup_timer] call TMDG_create_timer_dog;
	while {_warmup_timer > 0} do
	{
		_warmup_timer = _warmup_timer - 1;
		[_warmup_timer] call TMDG_update_timer_dog;
		sleep 1;
	};

	while {true} do 
	{
		{
			deleteMarkerLocal _x;
		} forEach _current_markers;
		_current_markers = [];
	
		_timer = _timer_base_value;
		
		_preys = units grp;
		
		{
			_caught_roll = random 100;
			
			if (_caught_roll < _dog_chance) then {
			
				_prey_pos = getPos _x;
				
				_marker_pos = [_prey_pos, _dog_accuracy] call TMDG_fnc_RandomWithinCircle;
				
				_marker_name = format ["%1m", _dog_accuracy];
				
				_marker_proper_name = createMarkerLocal [format ["%1", (count _current_markers)], _marker_pos];
				_marker_proper_name setMarkerTypeLocal "hd_unknown_noShadow";
				_marker_proper_name setMarkerColorLocal "ColorRed";
				_marker_proper_name setMarkerTextLocal _marker_name;
				
				_current_markers pushBack _marker_proper_name;
			
			};
		} forEach _preys;
		
		//"Dogs have pointed out some preys." remoteExec ["hint"];

		while {_timer > 0} do
		{
			_timer = _timer - 1;
			[_timer] call TMDG_update_timer_dog;
			sleep 1;
		};
	
	};
};