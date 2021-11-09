// Originally used in ARMA 3 Battle Royale mod.
TMDG_get_weapon_and_ammo = {
	params ["_holder", "_weapon"];

	_holder addWeaponCargoGlobal [_weapon, 1];
	_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
	_magazineClass = selectRandom _magazines; 
	_holder addMagazineCargoGlobal [_magazineClass, 1];
};

TMDG_get_weapon_and_amm = {
	params ["_holder", "_weapon", "_count"];

	_holder addWeaponCargoGlobal [_weapon, 1];
	_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
	_magazineClass = selectRandom _magazines; 
	_holder addMagazineAmmoCargo [_magazineClass, 1, _count];
};

TMDG_holder_smoke = {
	params ["_pos"];
	
	_source = "#particlesource" createVehicleLocal (_pos vectorAdd [2, 2, 0]); 
	_source setParticleParams [ 
		[ 
			"\A3\data_f\ParticleEffects\Universal\Universal", // particleShape 
			16,             // particleFSNtieth 
			7,              // particleFSIndex 
			48,             // particleFSFrameCount 
			1             // particleFSLoop 
		],     //particleShape or Array 
		"",    //animationName 
		"Billboard", //particleType 
		1,     //timePeriod 
		8,    //lifeTime 
		[0, 0, 0],  //position relative to particleSource 
		[0, 0, 0.1],  //moveVelocity 
		0,     //rotationVelocity 
		0.227,   //weight 
		0.21,     //volume 
		1.025,    //rubbing 
		[ 
			0.45,  
			0.65,  
			1,  
			2 
		],     //size 
		[ 
			[1, 0, 1, 0.7]    //RGBA 
		],    //color 
		[0.2],    //animationSpeed 
		0.01,     //randomDirectionPeriod 
		0.04,    //randomDirectionIntensity 
		"",    //onTimerScript 
		"",    //beforeDestroyedScript 
		_this   //this 
	]; 
	_source setParticleRandom [ 
		2,      //lifeTimeVar 
		[0.01, 0.01, 0.01],  //positionVar 
		[0.01, 0.01, 1],   //moveVelocityVar 
		0.01,     //rotationVelocityVar 
		0.1,     //sizeVar 
		[0, 0, 0, 0.1],  //colorVar 
		0,      //randomDirectionPeriodVar    
		0,      //randomDirectionIntensityVar 
		10     //angleVar 
	]; 
	_source setDropInterval 0.04; 
};

TMDG_create_holder = { 
	params ["_type", "_pos"]; 

	_pos0 = (_pos select 0); 
	_pos1 = (_pos select 1); 
	_pos2 = (_pos select 2); 
	
	_holder = Nil;
	switch (_type) do 
	{ 
		// Tables 
		case 0: { 
			_placer = createVehicle ["CUP_table_drawer", [_pos0, _pos1, 0.02], [], 0, "CAN_COLLIDE"]; 
			_pos2 = 0.82; 
			_holder = createVehicle ["groundWeaponHolder",[_pos0,_pos1,_pos2], [], 0, "CAN_COLLIDE"]; 
		}; 
		// Boxes + Smoke 
		case 1: { 
			[_pos] remoteExec ["TMDG_holder_smoke"];
			
			_typeArr = [ 
				"LIB_AmmoCrate_Mortar_SU",  
				"LIB_Lone_Big_Box",  
				"LIB_AmmoCrate_Mortar_GER",  
				"LIB_BasicWeaponsBox_US",  
				"LIB_BasicAmmunitionBox_US",  
				"LIB_BasicAmmunitionBox_GER" 
			]; 
			_holder_type = selectRandom _typeArr; 
			
			_holder = createVehicle [_holder_type, [_pos0,_pos1, 0.02], [], 0, "CAN_COLLIDE"]; 
			clearItemCargoGlobal _holder; 
			clearMagazineCargoGlobal _holder; 
			clearWeaponCargoGlobal _holder; 
			clearBackpackCargoGlobal _holder; 
		}; 
	}; 
	_holder
};

_possible_weapons = [
	"LIB_M1896", //Mauser
	"lib_shg24", //Grenade
	"LIB_NB39", //Smoke
	"LIB_K98", //Kar98k
	"LIB_5Rnd_792x57", //Kar98k ammo
	"V_LIB_SOV_IShBrVestMG", //Vest
	"FirstAidKit", //FAK
	"Binocular", //Binocular
	"ItemCompass", //Compass
	"LIB_Welrod_mk1", //Welrod
	"LIB_Webley_mk6", //Revolver
	"H_LIB_UK_Helmet_Mk2_FAK_Camo", //Helmet
	"LIB_PzFaust_30m", // Panzerfaust 30m
	"LIB_shumine_42_MINE_mag", //Mine
	"LIB_P08", //Luger
	"LIB_K98ZF39", // Kar Sniper
	"LIB_PTRD", // Kar Sniper
    "LIB_1Rnd_145x114", // PTRD ammo
    "LIB_Colt_M1911", //M1911
    "LIB_WaltherPPK" //PPK
];

_possible_magazines = [
	"LIB_10Rnd_9x19_M1896", //Mauser
	"", //Grenade
	"", //Smoke
	"LIB_5Rnd_792x57", //Kar98k
	"", //Kar98k ammo
	"", //Vest
	"", //FAK
	"", //Binocular
	"", //Compass
	"LIB_6Rnd_9x19", //Welrod
	"LIB_MN_6Rnd_455", //Revolver
	"",
	""
];

_weapon_count = ["WeaponCount", 50] call BIS_fnc_getParamValue;
_weapon_holder = ["WeaponHolder", 0] call BIS_fnc_getParamValue;
_showLoot = ["ShowWeapons", 0] call BIS_fnc_getParamValue;

_showLoot = _showLoot == 1;

if (isServer) then
{

	waitUntil {time > 0};
	
	for "_i" from 1 to _weapon_count do
	{
		_pos = getPos trig_play_area;
		_pos = [_pos, base_play_area] call TMDG_fnc_RandomWithinCircle;
		
		_current_holder = [_weapon_holder, _pos] call TMDG_create_holder;
		
		_debugLoot = "";
		
		_KK_fnc_arrayShuffle = {
			private "_cnt";
			_cnt = count _this;
			for "_i" from 1 to _cnt do {
				_this pushBack (_this deleteAt floor random _cnt);
			};
			_this
		};
		
		_typeArr = [0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,5,5,5,5,6,6,6,6,6,6,7,7,8,8,9,9,10,10,11,11,12,13,14,14,15,16,17,18,19,20];// call _KK_fnc_arrayShuffle; // shuffle the array, thanks to KillzoneKid //46
		_type = selectRandom _typeArr; // select a random number from the shuffled array
		
		_debugLoot = format ["%1 - %2",_debugLoot,_type];
		
		
		switch (_type) do
		{
			case 0: {
				[_current_holder, (_possible_weapons select 0)] call TMDG_get_weapon_and_ammo;
			};
			case 1: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 1), 1];
			};
			case 2: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 2), 1];
			};
			case 3: {
				_current_holder addWeaponCargoGlobal [(_possible_weapons select 3), 1];
				_current_holder addItemCargoGlobal ["LIB_ACC_K98_Bayo", 1];
			};
			case 4: {
				_current_holder addMagazineCargoGlobal [(_possible_weapons select 4), 1];
			};
			case 5: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 5), 1];
			};
			case 6: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 6), 1];
			};
			case 7: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 7), 1];
			};
			case 8: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 8), 1];
			};
			case 9: {
				[_current_holder, (_possible_weapons select 9)] call TMDG_get_weapon_and_ammo;
			};
			case 10: {
				[_current_holder, (_possible_weapons select 10)] call TMDG_get_weapon_and_ammo;
			};
			case 11: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 11), 1];
			};
			case 12: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 12), 1];
			};
			case 13: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 13), 1];
			};
			case 14: {
				[_current_holder, (_possible_weapons select 14)] call TMDG_get_weapon_and_ammo;
			};
			case 15: {
				_current_holder addItemCargoGlobal [(_possible_weapons select 15), 1];
			};
			case 16: {
				[_current_holder, (_possible_weapons select 16)] call TMDG_get_weapon_and_ammo;
			};
			case 17: {
				[_current_holder, (_possible_weapons select 3), (random 2)+1] call TMDG_get_weapon_and_amm;
			};
			case 18: {
				_current_holder addMagazineCargoGlobal [(_possible_weapons select 17), 5];
			};
			case 19: {
				[_current_holder, (_possible_weapons select 18)] call TMDG_get_weapon_and_ammo;
			};
			case 20: {
				[_current_holder, (_possible_weapons select 19)] call TMDG_get_weapon_and_ammo;
			};
			case 110: { // weapon
				_weaponArr = weaponsLoot call _KK_fnc_arrayShuffle;
				_weapon = selectRandom _weaponArr;
				_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
				_magazineClass = selectRandom _magazines; 
				_current_holder addWeaponCargoGlobal [_weapon, 1];
				_current_holder addMagazineCargoGlobal [_magazineClass, (round(random 2) + 1)]; // at least 1 magazine, max 3
			};
			case 111: { // item
				_itemArr = itemsLoot call _KK_fnc_arrayShuffle;
				_item = selectRandom _itemArr;
				_current_holder addItemCargoGlobal [_item, 1];
			};
			case 112: { // clothing
				_clothingArr = clothesLoot call _KK_fnc_arrayShuffle;
				_clothing = selectRandom _clothingArr;
				_current_holder addItemCargoGlobal [_clothing, 1];
			};
			case 113: { // vest
				_vestArr = vestsLoot call _KK_fnc_arrayShuffle;
				_vest = selectRandom _vestArr;
				_current_holder addItemCargoGlobal [_vest, 1];
			};
			case 114: { // medical
				_medicalArr = medicalLoot call _KK_fnc_arrayShuffle;
				_medical = selectRandom _medicalArr;
				_current_holder addItemCargoGlobal [_medical, 1];
			};
			case 115: { // grenades/mines
				_minesArr = grenadeMineLoot call _KK_fnc_arrayShuffle;
				_mine = selectRandom _minesArr;
				_current_holder addItemCargoGlobal [_mine, 1];
			};
			case 116: { // backpack
				_backpackArr = backpacksLoot call _KK_fnc_arrayShuffle;
				_backpack = selectRandom _backpackArr;
				_current_holder addBackpackCargoGlobal [_backpack, 1];
			};
			case 117: { // magazines
				_weaponArr = weaponsLoot call _KK_fnc_arrayShuffle;
				_weapon = selectRandom _weaponArr;
				_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
				_magazineClass = selectRandom _magazines; 
				_current_holder addMagazineCargoGlobal [_magazineClass, (round(random 4) + 1)]; // at least 1 magazine, max 5
			};
		};
		
		_current_holder enableSimulationGlobal false;
		_current_holder enableDynamicSimulation true;
		
		if (_showLoot) then
		{			
			_id = format ["LOOT_%1",_pos];
			_debug = createMarker [_id, getPos _current_holder];
			_debug setMarkerShape "ICON";
			_debug setMarkerType "hd_dot";
			_debug setMarkerColor "ColorRed";
			_txt = format ["%1",_debugLoot];
			_debug setMarkerText _txt;	
		};
	
	};
};