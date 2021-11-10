TMDG_create_timer = {
	params ["_id", "_formatted_time", "_row"];
	with uiNamespace do
	{	
		waitUntil {!isNull findDisplay 46};
		disableSerialization;
		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", _id];
		_ctrl ctrlSetStructuredText parseText _formatted_time;
		_h = (ctrlTextHeight _ctrl)/3;
		_w = (ctrlTextWidth _ctrl)/2;
		_divider = 0.0055 * (getResolution select 5);
		_ctrl ctrlSetPosition [
			safezoneX+(1.0-_w)*safezoneW,
			safezoneY +(0.5-_h/2)*safezoneH + _row * (0.01 + _h),
			_w*safezoneW,
			_h*safezoneH
		];
		_ctrl ctrlSetTextColor [0.9,0.9,0.9,1];
		_ctrl ctrlSetBackgroundColor [0.1,0.1,0.1,0.9];
		_ctrl ctrlCommit 0;
	};
};

TMDG_update_timer = {
	params ["_id", "_formatted_time"];
	with uiNamespace do
	{
		_ctrl = findDisplay 46 displayCtrl _id;
		_ctrl ctrlSetStructuredText parseText _formatted_time;
		_ctrl ctrlCommit 0;
	};
};



TMDG_create_timer_shrink = {
	params ["_time", "_size_multiplier"];
	_formatted_time = format ["<t size='%2' align='center'><img size='%2' color='#ffffff' image='\A3\ui_f\data\map\markers\military\circle_CA.paa' /> %1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, _size_multiplier];
	[40001, _formatted_time, -1] call TMDG_create_timer;
};

TMDG_update_timer_shrink = {
	params ["_time", "_size_multiplier"];
	
	_formatted_time = "";
	if (_time <= 10) then {
		_formatted_time = format ["<t size='%25' align='center' color='#aa0000'><img size='%2' color='#aa0000' image='\A3\ui_f\data\map\markers\military\circle_CA.paa' /> %1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, _size_multiplier];
	} else {
		_formatted_time =  format ["<t size='%2' align='center'><img size='%2' color='#ffffff' image='\A3\ui_f\data\map\markers\military\circle_CA.paa' /> %1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, _size_multiplier];
	};
	[40001, _formatted_time] call TMDG_update_timer;
};


TMDG_create_timer_death = {
	params ["_time", "_size_multiplier"];

	_formatted_time = format ["<t size='%3' align='center'><img size='%3' color='#ffffff' image='\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa' /> %1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, _size_multiplier];
	[40002, _formatted_time, 1] call TMDG_create_timer;
};

TMDG_update_timer_death = {
	params ["_time", "_colour", "_size_multiplier"];

	_formatted_time = format ["<t size='%3' align='center' color='%4'><img size='%3' color='%4' image='\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa' /> %1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, _size_multiplier, _colour];
	[40002, _formatted_time] call TMDG_update_timer;
};


TMDG_create_timer_dog = {
	params ["_time", "_size_multiplier"];
	
	_formatted_time = format ["<t size='%3' align='center'><img size='%3' color='#ffffff' image='%2' />%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, getMissionPath "icons\dog2.paa", _size_multiplier];
	[40003, _formatted_time, 0] call TMDG_create_timer;
};

TMDG_update_timer_dog = {
	params ["_time", "_size_multiplier"];
	
	_formatted_time = "";
	if (_time <= 10) then {
		_formatted_time = format ["<t size='%3' color='#bb0000' align='center'><img size='%3' color='#bb0000' image='%2' />%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, getMissionPath "icons\dog2.paa", _size_multiplier];
	} else {
		_formatted_time = format ["<t size='%3' align='center'><img color='#ffffff' size='%3' color='#ffffff' image='%2' />%1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, getMissionPath "icons\dog2.paa", _size_multiplier];
	};
	sleep 2;
	[40003, _formatted_time] call TMDG_update_timer;
};


_size_multiplier = (30/11) * (getResolution select 5);

waitUntil{time > 0};

[shrink_time, _size_multiplier] call TMDG_create_timer_shrink;
[death_time, _size_multiplier] call TMDG_create_timer_death;
[dogs_time, _size_multiplier] call TMDG_create_timer_dog;

while {true} do {
	[shrink_time, _size_multiplier] call TMDG_update_timer_shrink;
	[death_time, death_colour, _size_multiplier] call TMDG_update_timer_death;
	[dogs_time, _size_multiplier] call TMDG_update_timer_dog;

	sleep 1;
};