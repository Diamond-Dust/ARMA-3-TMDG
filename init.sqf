TMDG_keyspressed_out = {
	_shift =_this select 2;
	_handled = false;
	switch (_this select 1) do {

	case 35: {//H key
			if (_shift) then {
				_tctrl = (findDisplay 46) displayCtrl 40002;
				_tctrl ctrlShow !(ctrlShown _tctrl);
			};
		};
	};
	_handled;
};

TMDG_create_timer_out = {
	params ["_time"];
	
	_size_multiplier = (30/11) * (getResolution select 5)/1.5;
	
	with uiNamespace do
	{	
		waitUntil {!isNull findDisplay 46};
		disableSerialization;
		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", 40002];
		(findDisplay 46) displayAddEventHandler ["KeyDown","_this call TMDG_keyspressed_out"];
		_ctrl ctrlSetStructuredText parseText format ["<t size='%2' align='center'><img size='%2' color='#ffffff' image='\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa' /> %1s</t>", [_time, "MM:SS"] call BIS_fnc_secondsToString, _size_multiplier];
		_h = (ctrlTextHeight _ctrl)/3;
		_w = (ctrlTextWidth _ctrl);
		_ctrl ctrlSetPosition [
			safezoneX+(1.0-_w)*safezoneW,
			safezoneY +(0.5-_h/2)*safezoneH + 3*_h/2 + 0.01 * _size_multiplier,
			_w*safezoneW,
			_h*safezoneH
		];
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

0 fadeRadio 0;
enableRadio false;
isOut = true;

timer_kill_base_value = ["ShootingTimer", 40] call BIS_fnc_getParamValue; 
timer_kill_limit = timer_kill_base_value;

null = [] execVm "scripts\Zone\ShrinkZone.sqf";
null = [] execVm "scripts\Weapons\PlaceWeapons.sqf";
[timer_kill_limit] call TMDG_create_timer_out;
