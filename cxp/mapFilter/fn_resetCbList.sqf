/*
	Author: Casperento
	
	Description:
	Resets combo list

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
if !(isNil "cxpmf_taskDestination") exitWith {};

disableSerialization;
private _display = findDisplay 12;

private _categories = [];
{
	_categories pushBack (configName _x);
	false;
} count ("true" configClasses(missionConfigFile >> "Cxp_Config_MapFilter" >> worldName >> (call cxp_utils_fnc_getPlayerSide)));
_categories = _categories call BIS_fnc_sortAlphabetically;

private _cbListCat = _display displayCtrl 88005;
lbClear _cbListCat;
{
	_cbListCat lbAdd _x;
	_cbListCat lbSetData [(lbSize _cbListCat)-1,_x];
	false;
} count _categories;
_cbListCat ctrlEnable true;

private _cbListSubCat = _display displayCtrl 88004;
lbClear _cbListSubCat;
_cbListSubCat ctrlEnable false;

private _cbListMarkers = _display displayCtrl 88003;
lbClear _cbListMarkers;
_cbListMarkers ctrlEnable false;

mapAnimAdd [1, 0.08, player];
mapAnimCommit;

private _mcZoomSlider = _display displayCtrl 88001;
_mcZoomSlider sliderSetPosition 0.08;

private _chbox1 = _display displayCtrl 88010;
private _chbox2 = _display displayCtrl 88111;
{
	if (cbChecked _x) then {
		_x cbSetChecked false;
		if (_forEachIndex isEqualTo 0) then {
			{
				if !(_x in (uiNamespace getVariable "mpf_hidden_mks")) then {_x setMarkerAlphaLocal 1};
			} forEach allMapMarkers;
		} else {
			{
				if (markerAlpha _x < 1) then {
					if !(_x in (uiNamespace getVariable "mpf_hidden_mks")) then {_x setMarkerAlphaLocal 1};
				};
			} forEach allMapMarkers;
		};
	};
	if !(ctrlEnabled _x) then {_x ctrlEnable true};
} forEach [_chbox1, _chbox2];