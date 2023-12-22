/*
	Author: Casperento
	
	Description:
	Build bugtracker menu

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
// Bildschirmzentrum und Rastermaße
private _CENTER_X = ((getResolution select 2) * 0.5 * pixelW);
private _CENTER_Y = ((getResolution select 3) * 0.5 * pixelH);
private _UI_GRID_W = (pixelW * pixelGrid);
private _UI_GRID_H = (pixelH * pixelGrid);

// Deaktivierung der Serialisierung
disableSerialization;

// Erstellen eines leeren Displays
private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";

// Hauptgruppe für das Menü erstellen
private _xMainGroup = _CENTER_X - _UI_GRID_W * (80/2);
private _yMainGroup = _CENTER_Y - _UI_GRID_H * (40/2);
private _wMainGroup = _UI_GRID_W * 80;
private _hMainGroup = _UI_GRID_H * 40;
private _mainGroup = [_display, "CXP_BT_RscControlsGroupNoScrollbars", 717273, _xMainGroup, _yMainGroup, _wMainGroup, _hMainGroup] call cxp_utils_fnc_createContainer;

// Titel für das Menü erstellen
private _wGroupTitle = 1.0 * _wMainGroup;
private _hGroupTitle = 0.1 * _hMainGroup;
private _ctrlTitle = [_display, "CXP_BT_RscText", -1, 0, 0, _wGroupTitle, _hGroupTitle, _mainGroup] call cxp_utils_fnc_createContainer;
_ctrlTitle ctrlSetText "CXP BUGTRACKER";
_ctrlTitle ctrlSetTextColor [1,1,1,1];
_ctrlTitle ctrlSetBackgroundColor [0,0,0,0.8];

// Hauptbereich des Menüs erstellen
private _wGroupBody = 1.0 * _wMainGroup;
private _hGroupBody = 0.8 * _hMainGroup;
private _xGroupBody = 0.05 * _wMainGroup;
private _body = [_display, "CXP_BT_RscText_Left", -1, 0, _hGroupTitle, _wGroupBody, _hGroupBody, _mainGroup] call cxp_utils_fnc_createContainer;
_body ctrlSetBackgroundColor [0,0,0,0.7];

// Titel für den Hauptbereich erstellen
private _hBodyTitle = 0.1 * _hGroupBody;
private _yBodyTitle = _hGroupTitle + _hGroupTitle * 0.3;
private _bodyTitle = [_display, "CXP_BT_RscText", -1, 0, _yBodyTitle, _wGroupBody, _hBodyTitle, _mainGroup] call cxp_utils_fnc_createContainer;
_bodyTitle ctrlSetText (["STR_CXP_BT_Text_SubTitle"] call cxp_utils_fnc_getRealText);
_bodyTitle ctrlSetTextColor [1,1,1,1];

// Hintergrundtext für den Hauptbereich erstellen
private _wBodyForm = (1.0 * _wGroupBody) - 0.1;
private _bgTextHeight = 0.2 * _hGroupBody;
private _bgText = [_display, "CXP_BT_RscText_Left", -1, _xGroupBody, _yBodyTitle * 1.5, _wBodyForm, _bgTextHeight, _mainGroup] call cxp_utils_fnc_createContainer;
_bgText ctrlSetText (["STR_CXP_BT_Text_BugHpnd"] call cxp_utils_fnc_getRealText);
_bgText ctrlSetTextColor [1,1,1,1];

// Hintergrund-Edit-Feld für den Hauptbereich erstellen
private _bgEditHeight = 0.088 * _hGroupBody;
private _bgEdit = [_display, "CXP_BT_RscEdit", 7302, _xGroupBody, _yBodyTitle * 2.5, _wBodyForm, _bgEditHeight, _mainGroup] call cxp_utils_fnc_createContainer;
_bgEdit ctrlSetBackgroundColor [0, 0, 0, 1];

// Hintergrundtext 2 für den Hauptbereich erstellen
private _bgText2 = [_display, "CXP_BT_RscText_Left", -1, _xGroupBody, _yBodyTitle * 3.5, _wBodyForm, _bgTextHeight, _mainGroup] call cxp_utils_fnc_createContainer;
_bgText2 ctrlSetText (["STR_CXP_BT_Text_ExpectedBhv"] call cxp_utils_fnc_getRealText);
_bgText2 ctrlSetTextColor [1,1,1,1];

// Hintergrund-Edit-Feld 2 für den Hauptbereich erstellen
private _bgEdit2 = [_display, "CXP_BT_RscEdit", 7301, _xGroupBody, _yBodyTitle * 4.5, _wBodyForm, _bgEditHeight, _mainGroup] call cxp_utils_fnc_createContainer;
_bgEdit2 ctrlSetBackgroundColor [0, 0, 0, 1];

// Hintergrund-Button für den Hauptbereich erstellen
private _bgButtonWidth = 0.5 * _hGroupBody - 0.05;
private _bgButtonHeight = 0.15 * _hGroupBody;
private _bgButton = [_display, "CXP_BT_RscButton_Centered", -1, _xGroupBody, _yBodyTitle * 5.5, _bgButtonWidth, _bgButtonHeight, _mainGroup] call cxp_utils_fnc_createContainer;
_bgButton ctrlSetText (["STR_CXP_BT_Text_Report"] call cxp_utils_fnc_getRealText);
_bgButton ctrlSetTooltip (["STR_CXP_BT_ToolTip_Report"] call cxp_utils_fnc_getRealText);
_bgButton ctrlAddEventHandler ["ButtonClick", "_this call cxpbt_fnc_reportBug"];

// Hintergrund-Button 2 für den Hauptbereich erstellen
private _bgButton2 = [_display, "CXP_BT_RscButton_Centered", -1, _xGroupBody + _wBodyForm - _bgButtonWidth, _yBodyTitle * 5.5,  _bgButtonWidth, _bgButtonHeight, _mainGroup] call cxp_utils_fnc_createContainer;
_bgButton2 ctrlSetText (["STR_CXP_BT_Text_Close"] call cxp_utils_fnc_getRealText);
_bgButton2 ctrlSetTooltip (["STR_CXP_BT_ToolTip_Close"] call cxp_utils_fnc_getRealText);
_bgButton2 ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    _display = ctrlParent _ctrl;
    _display closeDisplay 0;
}];

// Fußzeile für das Menü erstellen
private _ctrlFooter = [_display, "CXP_BT_RscText", -1, 0, _hGroupBody+_hGroupTitle, _wGroupTitle, _hGroupTitle, _mainGroup] call cxp_utils_fnc_createContainer;
_ctrlFooter ctrlSetText (["STR_CXP_BT_Text_Credits"] call cxp_utils_fnc_getRealText);
_ctrlFooter ctrlSetTextColor [1,1,1,1];
_ctrlFooter ctrlSetBackgroundColor [0,0,0,0.8];
