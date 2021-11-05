waitUntil {time > 0};
if ( playerSide != east ) exitWith {}; 

_timer_base_value = ["PingTimer", 180] call BIS_fnc_getParamValue;
_dog_accuracy = ["PingAccuracy", 50] call BIS_fnc_getParamValue;
_dog_chance = ["PingChance", 50] call BIS_fnc_getParamValue;

if (_dog_accuracy != -1) then {
	_current_markers = [];
	
	_warmup_timer = 5;
	while {_warmup_timer > 0} do
	{
		_warmup_timer = _warmup_timer - 1;
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
		
		"Dogs have pointed out some preys." remoteExec ["hint"];

		while {_timer > 0} do
		{
			_timer = _timer - 1;
			sleep 1;
		};
	
	};
};