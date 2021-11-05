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
	"H_mas_ww2_helmet_ukc_B", //Helmet
	"LIB_PzFaust_30m", // Panzerfaust 30m
	"LIB_shumine_42_MINE_mag", //Mine
	"LIB_P08", //Luger
	"LIB_K98ZF39", // Kar Sniper
	"LIB_PTRD" // Kar Sniper
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
_showLoot = ["ShowWeapons", 0] call BIS_fnc_getParamValue;

_showLoot = _showLoot == 1;

if (isServer) then
{
	for "_i" from 1 to _weapon_count do
	{
		_pos = getPos trig_play_area;
		_pos = [_pos, base_play_area] call TMDG_fnc_RandomWithinCircle;
		_pos0 = (_pos select 0);
		_pos1 = (_pos select 1);
		_pos2 = (_pos select 2);
		
		_pos2 = 0.82; // reset and adjust it up slightly from 0m ATL

		_placer = createVehicle ["CUP_table_drawer",[_pos0,_pos1,0.02], [], 0, "CAN_COLLIDE"];
		_holder = createVehicle ["groundWeaponHolder",[_pos0,_pos1,_pos2], [], 0, "CAN_COLLIDE"];
		
		_debugLoot = "";
		
		_KK_fnc_arrayShuffle = {
			private "_cnt";
			_cnt = count _this;
			for "_i" from 1 to _cnt do {
				_this pushBack (_this deleteAt floor random _cnt);
			};
			_this
		};
		
		_typeArr = [0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,5,5,5,5,6,6,6,6,6,6,7,7,8,8,9,9,10,10,11,11,12,13,14,14,15,16,17];// call _KK_fnc_arrayShuffle; // shuffle the array, thanks to KillzoneKid //46
		_type = selectRandom _typeArr; // select a random number from the shuffled array
		
		_debugLoot = format ["%1 - %2",_debugLoot,_type];
		
		
		switch (_type) do
		{
			case 0: {
				[_holder, (_possible_weapons select 0)] call TMDG_get_weapon_and_ammo;
			};
			case 1: {
				_holder addItemCargoGlobal [(_possible_weapons select 1), 1];
			};
			case 2: {
				_holder addItemCargoGlobal [(_possible_weapons select 2), 1];
			};
			case 3: {
				_holder addWeaponCargoGlobal [(_possible_weapons select 3), 1];
				_holder addItemCargoGlobal ["LIB_ACC_K98_Bayo", 1];
			};
			case 4: {
				_holder addMagazineCargoGlobal [(_possible_weapons select 4), 1];
			};
			case 5: {
				_holder addItemCargoGlobal [(_possible_weapons select 5), 1];
			};
			case 6: {
				_holder addItemCargoGlobal [(_possible_weapons select 6), 1];
			};
			case 7: {
				_holder addItemCargoGlobal [(_possible_weapons select 7), 1];
			};
			case 8: {
				_holder addItemCargoGlobal [(_possible_weapons select 8), 1];
			};
			case 9: {
				[_holder, (_possible_weapons select 9)] call TMDG_get_weapon_and_ammo;
			};
			case 10: {
				[_holder, (_possible_weapons select 10)] call TMDG_get_weapon_and_ammo;
			};
			case 11: {
				_holder addItemCargoGlobal [(_possible_weapons select 11), 1];
			};
			case 12: {
				_holder addItemCargoGlobal [(_possible_weapons select 12), 1];
			};
			case 13: {
				_holder addItemCargoGlobal [(_possible_weapons select 13), 1];
			};
			case 14: {
				[_holder, (_possible_weapons select 14)] call TMDG_get_weapon_and_ammo;
			};
			case 15: {
				_holder addItemCargoGlobal [(_possible_weapons select 15), 1];
			};
			case 16: {
				[_holder, (_possible_weapons select 16)] call TMDG_get_weapon_and_ammo;
			};
			case 17: {
				[_holder, (_possible_weapons select 3), (random 2)+1] call TMDG_get_weapon_and_amm;
			};
			case 110: { // weapon
				_weaponArr = weaponsLoot call _KK_fnc_arrayShuffle;
				_weapon = selectRandom _weaponArr;
				_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
				_magazineClass = selectRandom _magazines; 
				_holder addWeaponCargoGlobal [_weapon, 1];
				_holder addMagazineCargoGlobal [_magazineClass, (round(random 2) + 1)]; // at least 1 magazine, max 3
			};
			case 111: { // item
				_itemArr = itemsLoot call _KK_fnc_arrayShuffle;
				_item = selectRandom _itemArr;
				_holder addItemCargoGlobal [_item, 1];
			};
			case 112: { // clothing
				_clothingArr = clothesLoot call _KK_fnc_arrayShuffle;
				_clothing = selectRandom _clothingArr;
				_holder addItemCargoGlobal [_clothing, 1];
			};
			case 113: { // vest
				_vestArr = vestsLoot call _KK_fnc_arrayShuffle;
				_vest = selectRandom _vestArr;
				_holder addItemCargoGlobal [_vest, 1];
			};
			case 114: { // medical
				_medicalArr = medicalLoot call _KK_fnc_arrayShuffle;
				_medical = selectRandom _medicalArr;
				_holder addItemCargoGlobal [_medical, 1];
			};
			case 115: { // grenades/mines
				_minesArr = grenadeMineLoot call _KK_fnc_arrayShuffle;
				_mine = selectRandom _minesArr;
				_holder addItemCargoGlobal [_mine, 1];
			};
			case 116: { // backpack
				_backpackArr = backpacksLoot call _KK_fnc_arrayShuffle;
				_backpack = selectRandom _backpackArr;
				_holder addBackpackCargoGlobal [_backpack, 1];
			};
			case 117: { // magazines
				_weaponArr = weaponsLoot call _KK_fnc_arrayShuffle;
				_weapon = selectRandom _weaponArr;
				_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
				_magazineClass = selectRandom _magazines; 
				_holder addMagazineCargoGlobal [_magazineClass, (round(random 4) + 1)]; // at least 1 magazine, max 5
			};
		};
		
		_holder enableSimulationGlobal false;
		_holder enableDynamicSimulation true;
		
		if (_showLoot) then
		{			
			_id = format ["LOOT_%1",_pos];
			_debug = createMarker [_id, getPos _holder];
			_debug setMarkerShape "ICON";
			_debug setMarkerType "hd_dot";
			_debug setMarkerColor "ColorRed";
			_txt = format ["%1",_debugLoot];
			_debug setMarkerText _txt;	
		};
	
	};
};