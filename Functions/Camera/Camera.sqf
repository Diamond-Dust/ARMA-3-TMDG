["Initialize",[player, [east, independent, civilian], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;
with uiNamespace do
{	waitUntil {!isNull findDisplay 60492};
	disableSerialization;
	_ctrl = findDisplay 60492 ctrlCreate ["RscStructuredText",-1];
	_ctrl ctrlSetPosition [safezoneX+0.97*safezoneW,safezoneY,0.03*safezoneW,0.033*safezoneH];
	_ctrl ctrlSetStructuredText parseText "<img size='1.4' image='\A3\Ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_exit_ca.paa'/>";
	_ctrl ctrlSetTextColor [0.9,0.9,0.9,1];
	_ctrl ctrlSetBackgroundColor [0.1,0.1,0.1,0.9];
	_ctrl ctrlAddEventHandler ["MouseButtonClick",{["Terminate"] call BIS_fnc_EGSpectator}];
	_ctrl ctrlCommit 0;
};