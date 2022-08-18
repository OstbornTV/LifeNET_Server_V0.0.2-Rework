/*
	Author: Casperento
	
	Description:
	Change system's data according to an item selected on the combo list

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [["_type", "", [""]], ["_ctrlIdc", 0, [-1]]];

disableSerialization;
private _display = findDisplay 12;
private _ctrlSelected = _display displayCtrl _ctrlIdc;

if (isNull _ctrlSelected) exitWith {diag_log "[CXP-MAP-FILTER] Invalid IDC passed to cxpmf_fnc_changeCbList..."};
if (_type isEqualTo "") exitWith {diag_log "[CXP-MAP-FILTER] Invalid type passed to cxpmf_fnc_changeCbList..."};

private _cfg = missionConfigFile >> "Cxp_Config_MapFilter" >> worldName >> (call cxp_utils_fnc_getPlayerSide);
private _selectedData = _ctrlSelected lbData (lbCurSel _ctrlSelected);

private _mcZoomSlider = findDisplay 12 displayCtrl 88001;
_mcZoomSlider ctrlEnable false;
_mcZoomSlider ctrlSetTooltip (["STR_CXP_MF_ToolTip_FindWarning"] call cxp_utils_fnc_getRealText);

if (_type isEqualTo "cat") exitwith {
	private _subCat = [];
	{
		_subCat pushBack (configName _x);
		false;
	} count ("true" configClasses(_cfg >> _selectedData));
	_subCat = _subCat call BIS_fnc_sortAlphabetically;

	private _cbListSubCat = _display displayCtrl 88004;
	lbClear _cbListSubCat;
	{
		_cbListSubCat lbAdd _x;
		_cbListSubCat lbSetData [(lbSize _cbListSubCat)-1,_x];
		false;
	} count _subCat;
	_cbListSubCat ctrlEnable true;

	private _cbListMarkers = _display displayCtrl 88003;
	lbClear _cbListMarkers;
	_cbListMarkers ctrlEnable false;
};

if (_type isEqualTo "scat") exitwith {
	private _cbListCat = _display displayCtrl 88005;
	private _selectedCat = _cbListCat lbData (lbCurSel _cbListCat);
	private _markers = getArray(_cfg >> _selectedCat >> _selectedData >> "mpfl_mks");
	_markers = _markers call BIS_fnc_sortAlphabetically;

	private _cbListMarkers = _display displayCtrl 88003;
	lbClear _cbListMarkers;
	{
		_cbListMarkers lbAdd ([markerText _x] call cxp_utils_fnc_getRealText);
		_cbListMarkers lbSetData [(lbSize _cbListMarkers)-1, _x];
		false;
	} count _markers;
	_cbListMarkers ctrlEnable true;
};

if (_type isEqualTo "mks") exitwith {
	_ctrlSelected ctrlEnable false;
	_ctrlSelected sliderSetPosition 0.08;
	_ctrlSelected ctrlSetTooltip (["STR_CXP_MF_ToolTip_FindWarning"] call cxp_utils_fnc_getRealText);
};