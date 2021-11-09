_prey_together = ["PreyTogether", 0] call BIS_fnc_getParamValue;
_random_prey = ["RandomPrey", 1] call BIS_fnc_getParamValue;
_random_hunter = ["RandomHunter", 1] call BIS_fnc_getParamValue;
_weapon_hunter = ["WeaponHunter", 2] call BIS_fnc_getParamValue;
_showSpawn = ["ShowSpawnpoints", 0] call BIS_fnc_getParamValue;

_prey_together = _prey_together == 1;
_random_prey = _random_prey == 1;
_random_hunter = _random_hunter == 1;
_showSpawn = _showSpawn == 1;

_size = base_play_area;
_together_circle_radius = 5;

waitUntil {time > 0};

if (isServer) then 
{
	magazine_count = ({isPlayer _x} count playableUnits);
	publicVariable "magazine_count";
	switch (_weapon_hunter) do
	{
		case 0: {
			h1 addMagazines ["LIB_5Rnd_792x57", 1];
			h1 addWeaponGlobal "LIB_K98";
			h1 addMagazines ["LIB_5Rnd_792x57", 2*magazine_count - 1];
		};
		case 1: {
			h1 addMagazines ["LIB_5Rnd_792x57", 1];
			h1 addWeaponGlobal "LIB_K98ZF39";
			h1 addMagazines ["LIB_5Rnd_792x57", 2*magazine_count - 1];
		};
		case 2: {
			h1 addMagazines ["LIB_10Rnd_792x57_clip", 1];
			h1 addWeaponGlobal "LIB_G41";
			h1 addMagazines ["LIB_10Rnd_792x57_clip", 1*magazine_count - 1];
		};
	};
	
	_trigger_pos = getPos trig_play_area;
	
	_new_hunter_pos = getPos h1;
	if (_random_hunter) then 
	{
		_new_hunter_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
		
		h1 setPos _new_hunter_pos;
	};
	
	_hunter_pos = _new_hunter_pos;
	_min_hunter_distance = 300;
	
	if (_showSpawn) then
	{			
		_id = "ZAROFF_SPAWN";
		_debug = createMarker [_id, _hunter_pos];
		_debug setMarkerShape "ICON";
		_debug setMarkerType "loc_LetterZ";
		_debug setMarkerColor "ColorRed";
		
		_markerstr = createMarker ["markername_zaroff", _hunter_pos];
		_markerstr setMarkerShape "ELLIPSE";
		_markerstr setMarkerColor "ColorGrey";
		_markerstr setMarkerSize [_min_hunter_distance, _min_hunter_distance];
	};
	
	if (_random_prey) then 
	{
		if (_prey_together) then 
		{
			_preys = units grp;
			
			_new_preys_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
			
			_prey_hunter_distance = _new_preys_pos distance2D _hunter_pos;
			
			while {_prey_hunter_distance < (_min_hunter_distance + _together_circle_radius)} do
			{
				_new_preys_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
			
				_prey_hunter_distance = _new_preys_pos distance2D _hunter_pos;
			};
				
			if (_showSpawn) then
			{
				_markerstr = createMarker ["markername_together", _new_preys_pos];
				_markerstr setMarkerShape "ELLIPSE";
				_debug setMarkerColor "ColorGreen";
				_markerstr setMarkerSize [_together_circle_radius, _together_circle_radius];
			};
		
			{
				_new_prey_pos = [_new_preys_pos, _together_circle_radius] call TMDG_fnc_RandomWithinCircle;
				
				_x setPos _new_prey_pos;
				
				if (_showSpawn) then
				{
					_id = format ["PREY_SPAWN_%1", random 100000];
					_debug = createMarker [_id, _new_preys_pos];
					_debug setMarkerShape "ICON";
					_debug setMarkerType "loc_LetterP";
					_debug setMarkerColor "ColorGreen";
				};
			} forEach _preys;
		}
		else
		{
			_preys = units grp;
		
			{
				_new_prey_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
				
				_prey_hunter_distance = _new_prey_pos distance2D _hunter_pos;
				
				while {_prey_hunter_distance < _min_hunter_distance} do
				{
					_new_prey_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
				
					_prey_hunter_distance = _new_prey_pos distance2D _hunter_pos;
				};
				
				_x setPos _new_prey_pos;
				
				if (_showSpawn) then
				{			
					_id = format ["PREY_SPAWN_%1", random 100000];
					_debug = createMarker [_id, _new_prey_pos];
					_debug setMarkerShape "ICON";
					_debug setMarkerType "loc_LetterP";
					_debug setMarkerColor "ColorGreen";
				};
			} forEach _preys;
		};
	};
};