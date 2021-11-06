#include "\a3\ui_f\hpp\definecommongrids.inc"

TMDG_sudden_death_ui = {
	params ["_timer"];

	[(format ["<t color='#ff0000' size='.8'>Warning!<br />%1 seconds until Sudden Death.</t>", _timer]),0,GUI_GRID_TOPCENTER_Y + 3 * GUI_GRID_TOPCENTER_H,1,0,0,800] spawn BIS_fnc_dynamicText;
};

TMDG_adjust_marker_to_params = {
	params ["_marker_name", "_area", "_pos"];

	_marker_name setMarkerSize _area;
	_marker_name setMarkerPos _pos;
};

TMDG_adjust_marker_to_trigger = {
	params ["_trigger", "_marker_name", "_size"];

	//_trigger setTriggerArea [_size, _size, 0, false, -1];
	([_trigger, [_size, _size, 0, false, -1]]) remoteExec ["setTriggerArea"];
	_triggerArea = triggerArea (_trigger);
	_triggerPos = getPos (_trigger);
	_trgX = (_triggerArea select 0);
	_trgY = (_triggerArea select 1);
	_marker_name setMarkerSize [_size, _size];
	_marker_name setMarkerPos _triggerPos;
};

TMDG_spawn_smoke_on_trigger_boundary = {
	params ["_trigger", "_size", "_step_size"];
	
	{
		deleteVehicle _x;
	}forEach emitters;
	
	_step_size = 1;
	if (_size > 500) then {
		_step_size = 1;
	}
	else {
		if (_size > 250) then {
			_step_size = 2;
		}
		else {
			if (_size > 125) then {
				_step_size = 4;
			} else
			{
				_step_size = 8;
			};
		};
	};
	
	for "_i" from 0 to 360 step _step_size do {
		_pos = _trigger getPos[ _size, _i ];
		
		_source = "#particlesource" createVehicleLocal _pos;
		_source setParticleParams [
			[
				"\A3\data_f\ParticleEffects\Universal\Universal",	// particleShape
				16, 												// particleFSNtieth
				7, 													// particleFSIndex
				48, 												// particleFSFrameCount
				1													// particleFSLoop
			], 				//particleShape or Array
			"", 			//animationName
			"Billboard",	//particleType
			1, 				//timePeriod
			10, 			//lifeTime
			[0, 0, 0],		//position relative to particleSource
			[0, 0, 0.5], 	//moveVelocity
			0, 				//rotationVelocity
			10.277, 			//weight
			1, 				//volume
			0.025, 			//rubbing
			[
				0.5, 
				8, 
				12, 
				15
			], 				//size
			[
				[1, 0, 0, 0.7],				//RGBA
				[0, 1, 0, 0.5], 			//RGBA
				[0, 0, 1, 0.25],			//RGBA
				[1, 0, 1, 0]				//RGBA
			],				//color
			[0.2], 			//animationSpeed
			1, 				//randomDirectionPeriod
			0.04, 			//randomDirectionIntensity
			"", 			//onTimerScript
			"", 			//beforeDestroyedScript
			_this			//this
		];
		_source setParticleRandom [
			2, 					//lifeTimeVar
			[0.3, 0.3, 0.3], 	//positionVar
			[1.5, 1.5, 1], 		//moveVelocityVar
			20, 				//rotationVelocityVar
			0.2, 				//sizeVar
			[0, 0, 0, 0.1], 	//colorVar
			0, 					//randomDirectionPeriodVar
			0, 					//randomDirectionIntensityVar
			360					//angleVar
		];
		_source setDropInterval 0.2;
		
		emitters append[ _source ];
	};
};

_timer_base_value = ["ShrinkingTimer", 120] call BIS_fnc_getParamValue;
_resize_ratio = ["ShrinkingRatio", 80] call BIS_fnc_getParamValue;
_resize_limit = ["ShrinkingLimit", 100] call BIS_fnc_getParamValue;
_show_next = ["ShowNext", 1] call BIS_fnc_getParamValue;
_show_limit_countdown = ["ShrinkingLimitCountdown", 1] call BIS_fnc_getParamValue;

if isServer then 
{
	["t1", [trig_play_area, true]] call BIS_fnc_taskSetDestination;
	
	if (_resize_ratio != 0 && _resize_ratio != 100) then {
		_show_next = _show_next == 1;
		_show_limit_countdown = _show_limit_countdown == 1;
		_resize_ratio = _resize_ratio / 100.0;
		_timer = _timer_base_value;
		_size = base_play_area;

		[trig_play_area, "marker_play_area", _size] call TMDG_adjust_marker_to_trigger;
			
		if (!_show_next) then {
			deleteMarker "marker_next_play_area";
		};

		while {true} do
		{	
			_new_trigger_pos = [(getPos trig_play_area), (_size * (1 - _resize_ratio))] call TMDG_fnc_RandomWithinCircle;
			_new_size = _size * _resize_ratio;
			
			if (_new_size < _resize_limit) then 
			{
				_new_size = 5;
			};
			
			if (_show_next) then 
			{
				["marker_next_play_area", [_new_size, _new_size], _new_trigger_pos] call TMDG_adjust_marker_to_params;
			};
			
			[trig_play_area, _size] remoteExec ["TMDG_spawn_smoke_on_trigger_boundary"];

			while {_timer > 0} do
			{
			
				if (_show_limit_countdown && (_new_size < _resize_limit)) then
				{
					//(format ["%1 seconds until Sudden Death.", _timer]) remoteExec ["hintSilent"];
					(_timer) remoteExec ["TMDG_sudden_death_ui"];
				};
			
				_timer = _timer - 1;
				sleep 1;
			};
			
			trig_play_area setPos _new_trigger_pos;
			
			["t1", _new_trigger_pos] call BIS_fnc_taskSetDestination;
			
			_size = _new_size;
			
			[trig_play_area, "marker_play_area", _size] call TMDG_adjust_marker_to_trigger;
			
			if (_size < _resize_limit) exitWith
			{
				[trig_play_area, _size] remoteExec ["TMDG_spawn_smoke_on_trigger_boundary"];
				
				(format ["Hunt area decreased to 5 meters.\nFight to the death.", _timer]) remoteExec ["hint"];
			};
			
			_timer = _timer_base_value;
			
			(format ["Hunt area decreased.\nNext shrinking in %1 seconds.", _timer]) remoteExec ["hint"];
		};

	}
	else {
		deleteMarker "marker_next_play_area";

		if (_resize_ratio == 0) then {
			trig_play_area setPos [0, 0, 0];
			[trig_play_area, "marker_play_area"] call TMDG_adjust_marker_to_trigger;
		}
		else {
			_size = base_play_area;

			[trig_play_area, "marker_play_area", _size] call TMDG_adjust_marker_to_trigger;
		};
	};
};