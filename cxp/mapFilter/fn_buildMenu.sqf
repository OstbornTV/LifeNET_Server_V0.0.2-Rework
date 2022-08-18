/*
	Author: Casperento
	
	Description:
	Build mapfilter main menu

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
disableSerialization;

waitUntil {!isNull findDisplay 46 && !isNull findDisplay 12};

private _hidden = [];
{
	if (markerAlpha _x == 0) then {_hidden pushBack _x};
} forEach allMapMarkers;
uiNamespace setVariable ["mpf_hidden_mks",_hidden];

addMissionEventHandler ["Map", {
	params ["_mapIsOpened", "_mapIsForced"];
	private _display = findDisplay 12;
	private _mcChBxOpWithTask = _display displayCtrl 88212;
	private _mcZoomSlider = _display displayCtrl 88001;

	if (_mapIsOpened && {!isNil 'cxpmf_taskDestination'} && {cbChecked _mcChBxOpWithTask}) then {
		_mcZoomSlider sliderSetPosition 0.08;
		mapAnimAdd [1, 0.08, taskDestination cxpmf_taskDestination];
		mapAnimCommit;
	};
}];

private _CENTER_Y = ((getResolution select 3) * 0.5 * pixelH);
private _PIXEL_GRID_W = (pixelW * pixelGrid);
private _PIXEL_GRID_H = (pixelH * pixelGrid);

private _xMainContainer = (safeZoneX + safeZoneW) - 26 * _PIXEL_GRID_W;
private _yMainContainer = _CENTER_Y - 61.5/2 * _PIXEL_GRID_H;
private _wMainContainer = 26 * _PIXEL_GRID_W;
private _hMainContainer = 61.5 * _PIXEL_GRID_H;

private _expW = 3 * _PIXEL_GRID_W;
private _expH = 61.5 * _PIXEL_GRID_H;

private _display = findDisplay 12;

private _mainContainer = [_display, "CXP_MF_RscControlsGroupNoScrollbars", 88000, (_xMainContainer+_wMainContainer) - _expW, _yMainContainer, _wMainContainer, _hMainContainer] call cxp_utils_fnc_createContainer;

_mainContainer ctrlAddEventHandler ["MouseMoving",{
	params ["_control", "_xPos", "_yPos", "_mouseOver"];
	if (_mouseOver) then {
		_control ctrlMapCursor ["","Arrow"];
	} else {
		_control ctrlMapCursor ["","Track"];
	};
}];

private _mcBG = [_display, "CXP_MF_RscText", -1, 0, 0, _wMainContainer, _hMainContainer, _mainContainer] call cxp_utils_fnc_createContainer;
_mcBG ctrlSetBackgroundColor [0,0,0,0.7];

private _mcExpand = [_display, "CXP_MF_RscButton", -1, 0, 0, _expW, _expH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcExpand ctrlSetText "<";
_mcExpand ctrlAddEventHandler ["ButtonClick", {
	params ["_ctrl"];

	[_ctrl, ctrlParentControlsGroup _ctrl] spawn {
		params ["_ctrl","_container"];

		(ctrlPosition _container) params ["_cX","_cY","_cW","_cH"];
		private _btnW = ctrlPosition _ctrl select 2;

		if (ctrlText _ctrl isEqualTo "<") then {
			_container ctrlSetPosition [_cX-_cW+_btnW,_cY,_cW,_cH];
			_container ctrlCommit 0.5;
			waitUntil {ctrlCommitted _container};
			_ctrl ctrlSetText ">";
			if (cbChecked (findDisplay 12 displayCtrl 88313)) then {[] spawn cxpmf_fnc_resetCbList};
		} else {
			_container ctrlSetPosition [_cX+_cW-_btnW,_cY,_cW,_cH];
			_container ctrlCommit 0.5;
			waitUntil {ctrlCommitted _container};
			_ctrl ctrlSetText "<";
		};
	};
}];

private _titW = 23.5 * _PIXEL_GRID_W;
private _titH = 3 * _PIXEL_GRID_H;
private _mcTitle = [_display, "CXP_MF_RscText", -1, _expW, 0, _titW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcTitle ctrlSetText "CXP MAP FILTER";
_mcTitle ctrlSetBackgroundColor [0,0,0,0.8];

private _catW = 23 * _PIXEL_GRID_W;
private _mcCat = [_display, "CXP_MF_RscText", -1, _expW, _titH, _catW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcCat ctrlSetText (["STR_CXP_MF_Text_Category"] call cxp_utils_fnc_getRealText);
_mcCat ctrlSetTextColor [1,1,1,1];
private _cmbX = 4 * _PIXEL_GRID_W;
private _cmbY = 2 * _titH;
private _cmbW = 21 * _PIXEL_GRID_W;
private _cmbH = 2.5 * _PIXEL_GRID_H;
private _mcCatCmb = [_display, "CXP_MF_RscCombo", 88005, _cmbX, _cmbY, _cmbW, _cmbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcCatCmb ctrlAddEventHandler ["LBSelChanged", {["cat", 88005] spawn cxpmf_fnc_changeCbList;}];
_mcCatCmb ctrlEnable false;

private _mcScat = [_display, "CXP_MF_RscText", -1, _expW, 3*_titH, _catW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcScat ctrlSetText (["STR_CXP_MF_Text_Subcategory"] call cxp_utils_fnc_getRealText);
_mcScat ctrlSetTextColor [1,1,1,1];
private _cmb2Y = 4 * _titH;
private _mcScatCmb = [_display, "CXP_MF_RscCombo", 88004, _cmbX, _cmb2Y, _cmbW, _cmbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcScatCmb ctrlAddEventHandler ["LBSelChanged", {["scat", 88004] spawn cxpmf_fnc_changeCbList;}];
_mcScatCmb ctrlEnable false;

private _mcMk = [_display, "CXP_MF_RscText", -1, _expW, 5*_titH, _catW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcMk ctrlSetText (["STR_CXP_MF_Text_Markers"] call cxp_utils_fnc_getRealText);
_mcMk ctrlSetTextColor [1,1,1,1];
private _cmb3Y = 6 * _titH;
private _mcMkCmb = [_display, "CXP_MF_RscCombo", 88003, _cmbX, _cmb3Y, _cmbW, _cmbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcMkCmb ctrlAddEventHandler ["LBSelChanged", {["mks", 88001] spawn cxpmf_fnc_changeCbList;}];
_mcMkCmb ctrlEnable false;


private _mcZoom = [_display, "CXP_MF_RscText", -1, _expW, 7*_titH, _catW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcZoom ctrlSetText "Zoom:";
_mcZoom ctrlSetTextColor [1,1,1,1];
private _sldY = 8 * _titH;
private _mcZoomSlider = [_display, "CXP_MF_RscSlider", 88001, _cmbX, _sldY, _cmbW, _cmbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcZoomSlider ctrlEnable false;
_mcZoomSlider sliderSetRange [0.01, 1.0];
_mcZoomSlider sliderSetPosition 0.08;
_mcZoomSlider ctrlSetTooltip (["STR_CXP_MF_ToolTip_FindWarning"] call cxp_utils_fnc_getRealText);
_mcZoomSlider ctrlAddEventHandler ["SliderPosChanged", {
	params ["_control", "_newValue"];
	private _mkName = (findDisplay 12 displayCtrl 88003) lbData (lbCurSel (findDisplay 12 displayCtrl 88003));
	private _pos = if !(_mkName isEqualTo "") then {getMarkerPos _mkName} else {getPos player};
	mapAnimAdd [0, _newValue, _pos];
	mapAnimCommit;
}];

private _mcActions = [_display, "CXP_MF_RscText", -1, _expW, 9*_titH, _catW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcActions ctrlSetText (["STR_CXP_MF_Text_Actions"] call cxp_utils_fnc_getRealText);
_mcActions ctrlSetTextColor [1,1,1,1];


private _btnW = 21 * _PIXEL_GRID_W;
private _mcBtnReset = [_display, "CXP_MF_RscButton", 88101, _cmbX, 10*_titH, _btnW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcBtnReset ctrlSetText (["STR_CXP_MF_Text_Reset"] call cxp_utils_fnc_getRealText);
_mcBtnReset ctrlSetTooltip (["STR_CXP_MF_ToolTip_Reset"] call cxp_utils_fnc_getRealText);
_mcBtnReset ctrlAddEventHandler ["ButtonClick", "_this spawn cxpmf_fnc_resetCbList"];

private _mcBtnFind = [_display, "CXP_MF_RscButton", -1, _cmbX, 11*_titH + _titH/10, _btnW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcBtnFind ctrlSetText (["STR_CXP_MF_Text_Find"] call cxp_utils_fnc_getRealText);
_mcBtnFind ctrlSetTooltip (["STR_CXP_MF_ToolTip_Find"] call cxp_utils_fnc_getRealText);
_mcBtnFind ctrlAddEventHandler ["ButtonClick", {
	disableSerialization;
	private _display = findDisplay 12;
	private _mcZoomSlider = _display displayCtrl 88001;
	_mcZoomSlider ctrlEnable true;
	_mcZoomSlider ctrlSetTooltip (["STR_CXP_MF_ToolTip_Zoom"] call cxp_utils_fnc_getRealText);
	_mcZoomSlider sliderSetPosition 0.08;

	private _mkName = (_display displayCtrl 88003) lbData (lbCurSel (_display displayCtrl 88003));
	if (_mkName isEqualTo "") exitwith {systemChat (["STR_CXP_MF_SCHAT_InvalidMarker"] call cxp_utils_fnc_getRealText)};
	(_display displayCtrl 88001) sliderSetPosition 0.08;
	mapAnimAdd [1, 0.08, getMarkerPos _mkName];
	mapAnimCommit;
}];

private _mcBtnMark = [_display, "CXP_MF_RscButton", -1, _cmbX, 12*_titH + (_titH/10*2), _btnW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcBtnMark ctrlSetText (["STR_CXP_MF_Text_Set"] call cxp_utils_fnc_getRealText);
_mcBtnMark ctrlSetTooltip (["STR_CXP_MF_ToolTip_Set"] call cxp_utils_fnc_getRealText);
_mcBtnMark ctrlAddEventHandler ["ButtonClick", {
	private _display = findDisplay 12;
	private _cbListMarkers = _display displayCtrl 88003;
	private _mkName = _cbListMarkers lbData (lbCurSel _cbListMarkers);

	if (_mkName isEqualTo "") exitWith {systemChat (["STR_CXP_MF_SCHAT_ChooseToSet"] call cxp_utils_fnc_getRealText)};

	if !(isNil "cxpmf_taskDestination") exitWith {systemChat (["STR_CXP_MF_SCHAT_CancelCurrentTask"] call cxp_utils_fnc_getRealText)};

	cxpmf_taskDestination = player createSimpleTask ["mpf_dest"];
	cxpmf_taskDestination setTaskState "Created";
	cxpmf_taskDestination setSimpleTaskDescription [
		(["STR_CXP_MF_TaskStr_LongDescription"] call cxp_utils_fnc_getRealText),
		(["STR_CXP_MF_TaskStr_ShortDescription"] call cxp_utils_fnc_getRealText),
		(["STR_CXP_MF_TaskStr_SucceededDescription"] call cxp_utils_fnc_getRealText)
	];
	cxpmf_taskDestination setSimpleTaskDestination (getMarkerPos _mkName);
	player setCurrentTask cxpmf_taskDestination;
	cxpmf_taskDestination setTaskState "Assigned";
	["Cxp_TaskDestAssigned"] call BIS_fnc_showNotification;

	cxpmf_tggTask = createTrigger ["EmptyDetector", getMarkerPos _mkName, false];
	cxpmf_tggTask setTriggerArea [10, 10, 0, false];
	cxpmf_tggTask setTriggerActivation [str playerSide, "PRESENT", true];
	cxpmf_tggTask setTriggerStatements [
		"this && (vehicle player) in thislist && local player",
		"
			cxpmf_taskDestination setTaskState 'Succeeded';
			call cxpmf_fnc_cancelTask;
			disableSerialization;
			private _resetBtn = findDisplay 12 displayCtrl 88101;
			_resetBtn ctrlEnable true;
			_resetBtn ctrlSetTooltip (['STR_CXP_MF_ToolTip_Reset'] call cxp_utils_fnc_getRealText);
		",
		""
	];

	private _resetBtn = _display displayCtrl 88101;
	_resetBtn ctrlEnable false;
	_resetBtn ctrlSetTooltip (["STR_CXP_MF_ToolTip_CancelWarning"] call cxp_utils_fnc_getRealText);
}];

private _mcBtnMark = [_display, "CXP_MF_RscButton", -1, _cmbX, 13*_titH + (_titH/10*3), _btnW, _titH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcBtnMark ctrlSetText (["STR_CXP_MF_Text_Cancel"] call cxp_utils_fnc_getRealText);
_mcBtnMark ctrlSetTooltip (["STR_CXP_MF_ToolTip_Cancel"] call cxp_utils_fnc_getRealText);
_mcBtnMark ctrlAddEventHandler ["ButtonClick", {
	if (isNil "cxpmf_taskDestination") exitWith {systemChat (["STR_CXP_MF_SCHAT_NoCurrentDestination"] call cxp_utils_fnc_getRealText)};
	call cxpmf_fnc_cancelTask;
	private _resetBtn = findDisplay 12 displayCtrl 88101;
	_resetBtn ctrlEnable true;
	_resetBtn ctrlSetTooltip (["STR_CXP_MF_ToolTip_Reset"] call cxp_utils_fnc_getRealText);
}];

private _chbW = 0.025 * safezoneW;
private _chbH = 0.04 * safezoneH;
private _mcChBxHideAll = [_display, "CXP_MF_RscCheckBox", 88010, _cmbX, 14*_titH + (_titH/10*4), _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcChBxHideAll ctrlSetTooltip (["STR_CXP_MF_ToolTip_HideAll"] call cxp_utils_fnc_getRealText);
_mcChBxHideAll ctrlAddEventHandler ["CheckedChanged", {
	params ["_control", "_checked"];
	private _chbox2 = findDisplay 12 displayCtrl 88111;

	if (_checked isEqualTo 1) then {
		{_x setMarkerAlphaLocal 0} forEach allMapMarkers;
		_chbox2 ctrlEnable false;
	} else {
		{
			if !(_x in (uiNamespace getVariable "mpf_hidden_mks")) then {_x setMarkerAlphaLocal 1};
		} forEach allMapMarkers;
		_chbox2 ctrlEnable true;
	};
}];
private _mcHideAllTxt = [_display, "CXP_MF_RscText_Left", -1, _cmbX + _chbW, 14*_titH + (_titH/10*4), _btnW - _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcHideAllTxt ctrlSetText (["STR_CXP_MF_Text_HideAll"] call cxp_utils_fnc_getRealText);
_mcHideAllTxt ctrlSetTextColor [1,1,1,1];

private _mcChBxHideAllEx = [_display, "CXP_MF_RscCheckBox", 88111, _cmbX, 15*_titH + (_titH/10*5), _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcChBxHideAllEx ctrlSetTooltip (["STR_CXP_MF_ToolTip_HideAllEx"] call cxp_utils_fnc_getRealText);
_mcChBxHideAllEx ctrlAddEventHandler ["CheckedChanged", {
	params ["_control", "_checked"];
	private _chbox1 = findDisplay 12 displayCtrl 88010;
	private _marker = (findDisplay 12 displayCtrl 88003) lbData (lbCurSel (findDisplay 12 displayCtrl 88003));

	if (_checked isEqualTo 1) then {
		if (_marker isEqualTo "") then {systemChat (["STR_CXP_MF_SCHAT_ExceptionNotFound"] call cxp_utils_fnc_getRealText)};
		{
			if !(_x isEqualTo _marker) then {
				_x setMarkerAlphaLocal 0;
			};
		} forEach allMapMarkers;
		_chbox1 ctrlEnable false;
	} else {
		{
			if !(_x isEqualTo _marker) then {
				if !(_x in (uiNamespace getVariable "mpf_hidden_mks")) then {_x setMarkerAlphaLocal 1};
			};
		} forEach allMapMarkers;
		_chbox1 ctrlEnable true;
	};
}];
private _mcHideAllExTxt = [_display, "CXP_MF_RscText_Left", -1, _cmbX + _chbW, 15*_titH + (_titH/10*5), _btnW - _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcHideAllExTxt ctrlSetText (["STR_CXP_MF_Text_HideAllEx"] call cxp_utils_fnc_getRealText);
_mcHideAllExTxt ctrlSetTextColor [1,1,1,1];

private _mcChBxOpWithTask = [_display, "CXP_MF_RscCheckBox", 88212, _cmbX, 16*_titH + (_titH/10*6), _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcChBxOpWithTask ctrlSetTooltip (["STR_CXP_MF_ToolTip_TaskWithMap"] call cxp_utils_fnc_getRealText);
_mcChBxOpWithTask cbSetChecked true;
private _mcOpWithTaskTxt = [_display, "CXP_MF_RscText_Left", -1, _cmbX + _chbW, 16*_titH + (_titH/10*6), _btnW - _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcOpWithTaskTxt ctrlSetText (["STR_CXP_MF_Text_TaskWithMap"] call cxp_utils_fnc_getRealText);
_mcOpWithTaskTxt ctrlSetTextColor [1,1,1,1];

private _mcChBxOpReset = [_display, "CXP_MF_RscCheckBox", 88313, _cmbX, 17*_titH + (_titH/10*7), _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcChBxOpReset ctrlSetTooltip (["STR_CXP_MF_ToolTip_ResetWithMap"] call cxp_utils_fnc_getRealText);
_mcChBxOpReset cbSetChecked true;
private _mcOpResetTxt = [_display, "CXP_MF_RscText_Left", -1, _cmbX + _chbW, 17*_titH + (_titH/10*7), _btnW - _chbW, _chbH, _mainContainer] call cxp_utils_fnc_createContainer;
_mcOpResetTxt ctrlSetText (["STR_CXP_MF_Text_ResetWithMap"] call cxp_utils_fnc_getRealText);
_mcOpResetTxt ctrlSetTextColor [1,1,1,1];