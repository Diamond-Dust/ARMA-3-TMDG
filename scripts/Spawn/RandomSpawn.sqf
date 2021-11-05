_prey_together = ["PreyTogether", 0] call BIS_fnc_getParamValue;
_random_prey = ["RandomPrey", 1] call BIS_fnc_getParamValue;
_random_hunter = ["RandomHunter", 1] call BIS_fnc_getParamValue;
_weapon_hunter = ["WeaponHunter", 2] call BIS_fnc_getParamValue;

_prey_together = _prey_together == 1;
_random_prey = _random_prey == 1;
_random_hunter = _random_hunter == 1;

_size = base_play_area;
_together_circle_radius = 5;

waitUntil {time > 0};

if (isServer) then 
{
	magazine_count = ({isPlayer _x} count playableUnits);
	systemChat str(magazine_count);
	publicVariable "magazine_count";
	switch (_weapon_hunter) do
	{
		case 0: {
			h1 addMagazines ["LIB_5Rnd_792x57", 1];
			h1 addWeapon "LIB_K98";
			h1 addMagazines ["LIB_5Rnd_792x57", 2*magazine_count - 1];
		};
		case 1: {
			h1 addMagazines ["LIB_5Rnd_792x57", 1];
			h1 addWeapon "LIB_K98ZF39";
			h1 addMagazines ["LIB_5Rnd_792x57", 2*magazine_count - 1];
		};
		case 2: {
			h1 addMagazines ["LIB_10Rnd_792x57_clip", 2];
			h1 addWeapon "LIB_G41";
			h1 addMagazines ["LIB_10Rnd_792x57_clip", 2*magazine_count - 2];
		};
	};
	
	_trigger_pos = getPos trig_play_area;
	
	if (_random_hunter) then 
	{
		_new_hunter_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
		
		h1 setPos _new_hunter_pos;
	};
	
	_hunter_pos = getPos h1;
	_min_hunter_distance = 300;
	
	if (_random_prey) then 
	{
		if (_prey_together) then 
		{
			_preys = units grp;
			
			_new_preys_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
			
			_prey_hunter_distance = _new_preys_pos distance _hunter_pos;
			
			while {_prey_hunter_distance < (_min_hunter_distance + _together_circle_radius)} do
			{
				_new_preys_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
			
				_prey_hunter_distance = _new_preys_pos distance _hunter_pos;
			};
		
			{
				_new_prey_pos = [_new_preys_pos, _together_circle_radius] call TMDG_fnc_RandomWithinCircle;
				
				_x setPos _new_prey_pos;
			} forEach _preys;
		}
		else
		{
			_preys = units grp;
		
			{
				_new_prey_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
				
				_prey_hunter_distance = _new_prey_pos distance _hunter_pos;
				
				while {_prey_hunter_distance < _min_hunter_distance} do
				{
					_new_prey_pos = [_trigger_pos, _size] call TMDG_fnc_RandomWithinCircle;
				
					_prey_hunter_distance = _new_prey_pos distance _hunter_pos;
				};
				
				_x setPos _new_prey_pos;
			} forEach _preys;
		};
	};
};

switch (_weapon_hunter) do
{
	case 0: {
		h1 addWeapon "LIB_K98";
	};
	case 1: {
		h1 addWeapon "LIB_K98ZF39";
	};
	case 2: {
		h1 addWeapon "LIB_G41";
	};
};