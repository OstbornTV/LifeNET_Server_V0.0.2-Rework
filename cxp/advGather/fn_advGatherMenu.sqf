/*
	Author: Casperento
	
	Description:
	System's menu related functions

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
#include "_macros.hpp"

params [
	["_type", "", [""]],
	["_ctrlArr", [], [[]]],
	["_from", 0, [-1]]
];

scopeName "main";

if (_type isEqualTo "" || {!isNil "cxpadg_started" && {!cxpadg_started}}) exitWith {};

switch (_type) do {
	case 'init': {
		if !(isNull objectParent player) exitWith {hint (["STR_CXP_ADG_Text_StayOutVeh"] call cxp_utils_fnc_getRealText)};
		if (!isNil "cxpadg_menuOpened" && {cxpadg_menuOpened}) exitWith {};

		// Check player's position
		private _currMkInfo = [];
		{
			if (player inArea _x) exitWith {_currMkInfo = _x splitString "@"};
			false
		} count cxpadg_zonesNames;
		if (count _currMkInfo isEqualTo 0) exitWith {};

		// Check player's inventory for the required item
		cxpadg_currItType = _currMkInfo # 2;
		cxpadg_currCfg = _currMkInfo # 3;
		private _zoneConfig = missionConfigFile >> "Cxp_Config_AdvGather" >> cxpadg_currItType >> cxpadg_currCfg;
		private _reqItem = getText(_zoneConfig >> "reqItem");
		if (_reqItem isNotEqualTo "") then {
			private _reqItemInv = missionNamespace getVariable format["life_inv_%1", _reqItem];
			if (_reqItemInv < 1) exitWith {
				private _rItemName = [(getText(missionConfigFile >> "VirtualItems" >> _reqItem >> "displayName"))] call cxp_utils_fnc_getRealText;
				hint format[["STR_CXP_ADG_Text_ReqItem"] call cxp_utils_fnc_getRealText, _rItemName];
				breakOut "main";
			};
		};

		// Setting current zone related variables variables
		private _currZoneItems = switch cxpadg_currItType do {
			case "Minerals": {getArray(_zoneConfig >> "mined")};
			case "Tradables": {[[cxpadg_currCfg, getText(_zoneConfig >> "processed"), 1.0]]};
			case "Sellables": {[[cxpadg_currCfg]]};
		};
		private _arr = [];
		private _weights = [];
		private "_itCfg";
		private "_itWeight";
		private "_itWeightP";
		private "_itVarname";
		private "_itName";
		{
			_itCfg = _x # 0;
			_itWeight = getNumber(missionConfigFile >> "VirtualItems" >> _itCfg >> "weight");
			_itVarname = getText(missionConfigFile >> "VirtualItems" >> _itCfg >> "variable");
			_itName = [(getText(missionConfigFile >> "VirtualItems" >> _itCfg >> "displayName"))] call cxp_utils_fnc_getRealText;
			
			_weights append [_itWeight];
			if ((life_carryWeight + _itWeight) > life_maxWeight) then {cxpadg_fullBackpack = true};

			if (cxpadg_currItType isNotEqualTo "Sellables") then {
				_itWeightP = getNumber(missionConfigFile >> "VirtualItems" >> (_x # 1) >> "weight");
				_arr append ([[_itCfg, [_itName, _itVarname, _itWeight, _itWeightP]]]);
			} else {
				_arr append ([[_itCfg, [_itName, _itVarname, _itWeight]]]);
			};

			false
		} count _currZoneItems;
		
		cxpadg_currZoneGatherSound = getText(_zoneConfig >> "sound");
		cxpadg_currZoneLighterIt = selectMin _weights;
		cxpadg_currZoneItems = createHashMapFromArray _arr;

		// Open system's menu
		if !(createDialog "CXP_ADG_MENU") exitWith {['onUnload'] call cxpadg_fnc_advGatherMenu};
		cxpadg_menuOpened = true;
		life_action_inUse = true;
	};
	case 'onLoad': {
		// Backpack info
		private _backpackInfo = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_BACKPACK;
		_backpackInfo ctrlSetText (format[["STR_CXP_ADG_Text_BackPack"] call cxp_utils_fnc_getRealText,  life_carryWeight, life_maxWeight]);

		// Fetching Items' information
		private _currZoneItems = toArray cxpadg_currZoneItems;
		private _itemsLB = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_LISTBOX_ITEMS;
		lbClear _itemsLB;
		{
			_itemsLB lbAdd (_x # 0);
			_itemsLB lbSetData [(lbSize _itemsLB)-1, str(_x)];
			false
		} count (_currZoneItems # 1);
		_itemsLB lbSetCurSel 0;

		// Showing info about max amount of the selected item player can store
		private _selectedItem = call compile lbData[ctrlIDC _itemsLB, lbCurSel (ctrlIDC _itemsLB)];
		cxpadg_currZoneItMaxAmount = floor ((life_maxWeight - life_carryWeight) / (_selectedItem # 2));
		private _maxAmountInfo = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_AMOUNT;
		_maxAmountInfo ctrlSetText format[["STR_CXP_ADG_Text_GatherAmount"] call cxp_utils_fnc_getRealText, cxpadg_currZoneItMaxAmount, (_selectedItem # 0)];

		private _procListBox = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_LISTBOX_PROCS;
		lbClear _procListBox;
		private _classArr = switch cxpadg_currItType do {
			case "Sellables": {
				getArray(missionConfigFile >> "Cxp_Config_AdvGather" >> cxpadg_currItType >> cxpadg_currCfg >> "traders")
			};
			default {
				getArray(missionConfigFile >> "Cxp_Config_AdvGather" >> cxpadg_currItType >> cxpadg_currCfg >> "processors")
			};
		};
		{
			_procListBox lbAdd ([markerText _x] call cxp_utils_fnc_getRealText);
			_procListBox lbSetData [(lbSize _procListBox)-1, _x];
			false
		} count _classArr;
		_procListBox lbSetCurSel 0;

		private _btnClose = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_BTN_CLOSE;
		_btnClose ctrlSetText (["STR_CXP_ADG_Text_BtnClose"] call cxp_utils_fnc_getRealText);
		_btnClose ctrlSetTooltip (["STR_CXP_ADG_ToolTip_BtnClose"] call cxp_utils_fnc_getRealText);
		_btnClose ctrlAddEventHandler ["ButtonClick", { closeDialog 2; }];
		
		private _tooltipBtnStart = "STR_CXP_ADG_ToolTip_BtnStart";
		private _btnStart = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_BTN_START;
		_btnStart ctrlSetText (["STR_CXP_ADG_Text_BtnStart"] call cxp_utils_fnc_getRealText);
		
		if (!isNil "cxpadg_fullBackpack" && {cxpadg_fullBackpack}) then {
			_btnStart ctrlEnable false;
			systemChat (["STR_CXP_ADG_ToolTip_BtnStart_InvFull"] call cxp_utils_fnc_getRealText);
			_tooltipBtnStart = "STR_CXP_ADG_ToolTip_BtnStart_InvFull";
		};
		
		_btnStart ctrlSetTooltip ([_tooltipBtnStart] call cxp_utils_fnc_getRealText);
		_btnStart ctrlAddEventHandler ["ButtonClick", {
			params ["_ctrl"];
			
			private _ctrlParent = ctrlParent _ctrl;
			private _prgBar = _ctrlParent displayCtrl IDC_CXP_ADG_MENU_PROGRESSBAR;
			private _prgBarText = _ctrlParent displayCtrl IDC_CXP_ADG_MENU_PROGRESSBAR_TEXT;
			[_ctrlParent, _prgBar, _prgBarText, _ctrl] spawn {
				params [
					["_ctrlParent", displayNull, [displayNull]],
					["_prgBar", controlNull, [controlNull]],
					["_prgBarText", controlNull, [controlNull]],
					["_ctrlBtn", controlNull, [controlNull]]
				];

				if (isNull _ctrlParent || {isNull _prgBar} || {isNull _prgBar} || {isNull _ctrlBtn}) exitWith {};

				private _btnClose = _ctrlParent displayCtrl IDC_CXP_ADG_MENU_BTN_CLOSE;
				_btnClose ctrlEnable false;
				_btnClose ctrlSetTooltip (["STR_CXP_ADG_ToolTip_WaitStarted"] call cxp_utils_fnc_getRealText);

				private _btnProc = _ctrlParent displayCtrl IDC_CXP_ADG_MENU_BTN_MARKPROC;
				_btnProc ctrlEnable false;
				_btnProc ctrlSetTooltip (["STR_CXP_ADG_ToolTip_WaitStarted"] call cxp_utils_fnc_getRealText);

				player switchMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
				disableUserInput true;

				_ctrlBtn ctrlEnable false;
				_ctrlBtn ctrlSetTooltip (["STR_CXP_ADG_ToolTip_BtnStarted"] call cxp_utils_fnc_getRealText);

				life_action_gathering = true;

				// Play gather sound
				[player, cxpadg_currZoneGatherSound, 30, 1] remoteExecCall ["life_fnc_say3D", -2];
				
				// Setup progress bar
				private _gatherMultiplier = getNumber(missionConfigFile >> "Cxp_Config_AdvGather" >> cxpadg_currItType >> cxpadg_currCfg >> "gather_time_multiplier");
				private _waitTime = if (cxpadg_currZoneItMaxAmount < 7) then {3} else {ceil(_gatherMultiplier * cxpadg_currZoneItMaxAmount)};
				private _prg = 0;
				waitUntil {
					player playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
					uiSleep 1;
					_prg = _prg + (1/_waitTime);
					if (_prg >= 1) then {_prg = 1};
					_prgBarText ctrlSetText format[["STR_CXP_ADG_Text_ProgressBar"] call cxp_utils_fnc_getRealText, round(_prg * 100), "%"];
					_prgBar progressSetPosition _prg;
					_prg == 1
				};

				life_action_gathering = false;
				disableUserInput false;
				_btnClose ctrlEnable true;
				_btnClose ctrlSetTooltip (["STR_CXP_ADG_ToolTip_BtnClose"] call cxp_utils_fnc_getRealText);
				_btnProc ctrlEnable true;

				private _lbItems = _ctrlParent displayCtrl IDC_CXP_ADG_MENU_LISTBOX_ITEMS;
				private _itData = call compile lbData[ctrlIDC _lbItems, lbCurSel (ctrlIDC _lbItems)];

				if ([(_itData # 1), (_itData # 2), cxpadg_currZoneItMaxAmount] call cxpadg_fnc_addVirtualItem) then {
					systemChat (["STR_CXP_ADG_ToolTip_BtnStart_InvFull"] call cxp_utils_fnc_getRealText);
					_ctrlBtn ctrlSetTooltip (["STR_CXP_ADG_ToolTip_BtnStart_InvFull"] call cxp_utils_fnc_getRealText);
				} else {
					diag_log "CXP ADG could not add virtual items into player's backpack...";
				
					[_ctrlBtn,
					"start_button_delay",
					"STR_CXP_ADG_Text_BtnStart",
					"STR_CXP_ADG_Text_BtnStart_Delay",
					"STR_CXP_ADG_ToolTip_BtnStart",
					"STR_CXP_ADG_ToolTip_BtnStart_Delay"
					] spawn cxpadg_fnc_buttonDelay;
				};
				
				// update menu ctrls
				cxpadg_currZoneItMaxAmount = floor ((life_maxWeight - life_carryWeight) / (_itData # 2));
				private _maxAmountInfo = _ctrlParent displayCtrl IDC_CXP_ADG_MENU_AMOUNT;
				_maxAmountInfo ctrlSetText format[["STR_CXP_ADG_Text_GatherAmount"] call cxp_utils_fnc_getRealText, cxpadg_currZoneItMaxAmount, (_itData # 0)];

				private _backpackInfo = _ctrlParent displayCtrl IDC_CXP_ADG_MENU_BACKPACK;
				_backpackInfo ctrlSetText (format[["STR_CXP_ADG_Text_BackPack"] call cxp_utils_fnc_getRealText,  life_carryWeight, life_maxWeight]);

				private _tooltipBtnProc = if (cxpadg_currItType isNotEqualTo "Sellables") then {"STR_CXP_ADG_ToolTip_BtnProcessor"} else {"STR_CXP_ADG_ToolTip_BtnTrader"};
				_btnProc ctrlSetTooltip ([_tooltipBtnProc] call cxp_utils_fnc_getRealText);
			};

		}];

		private _btnProcMark = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_BTN_MARKPROC;
		if !(isNil "cxpadg_taskDestination") then {
			[_btnProcMark] spawn cxpadg_fnc_buttonDelay;
		} else {
			private _textBtnProc = if (cxpadg_currItType isNotEqualTo "Sellables") then {"STR_CXP_ADG_Text_BtnProcessor"} else {"STR_CXP_ADG_Text_BtnTrader"};
			_btnProcMark ctrlSetText ([_textBtnProc] call cxp_utils_fnc_getRealText);
			private _tooltipBtnProc = if (cxpadg_currItType isNotEqualTo "Sellables") then {"STR_CXP_ADG_ToolTip_BtnProcessor"} else {"STR_CXP_ADG_ToolTip_BtnTrader"};
			_btnProcMark ctrlSetTooltip ([_tooltipBtnProc] call cxp_utils_fnc_getRealText);
		};
		_btnProcMark ctrlAddEventHandler ["ButtonClick", {
			params ["_ctrl"];

			if !(isNil "cxpadg_taskDestination") exitWith {
				call cxpadg_fnc_cancelTask;
				private _textBtnProc = if (cxpadg_currItType isNotEqualTo "Sellables") then {"STR_CXP_ADG_Text_BtnProcessor"} else {"STR_CXP_ADG_Text_BtnTrader"};
				_ctrl ctrlSetText ([_textBtnProc] call cxp_utils_fnc_getRealText);
				private _tooltipBtnProc = if (cxpadg_currItType isNotEqualTo "Sellables") then {"STR_CXP_ADG_ToolTip_BtnProcessor"} else {"STR_CXP_ADG_ToolTip_BtnTrader"};
				_ctrl ctrlSetTooltip ([_tooltipBtnProc] call cxp_utils_fnc_getRealText);
			};

			// Set processor as current destination
			call cxpadg_fnc_setTask;
			[_ctrl] spawn cxpadg_fnc_buttonDelay;
		}];
	};
	case 'onUnload': {
		cxpadg_currZoneItems = nil;
		cxpadg_currItType = nil;
		cxpadg_currCfg = nil;
		cxpadg_currMkName = nil;
		cxpadg_menuOpened = nil;
		cxpadg_currZoneItMaxAmount = nil;
		cxpadg_fullBackpack = nil;
		cxpadg_currZoneGatherSound = nil;
		life_action_inUse = false;
	};
	case 'onLBSelChanged': {
		_ctrlArr params ["_ctrl", "_selectedIndex"];
		if (isNull _ctrl) exitWith {};

		if (_from isEqualTo 1) then {
			private _itData = call compile lbData[ctrlIDC _ctrl, _selectedIndex];
			private _infoText = "<t font='RobotoCondensedBold' color='"+ TEXT_COLOR_HEX +"'>" + format[["STR_CXP_ADG_Text_ItemWeight"] call cxp_utils_fnc_getRealText, (_itData # 2)] + "<br/>";
			if (cxpadg_currItType isNotEqualTo  "Sellables") then {
				_infoText = _infoText + format[["STR_CXP_ADG_Text_ItemWeightP"] call cxp_utils_fnc_getRealText, (_itData # 3)] + "<br/></t>";
			};
			
			private _itInfoStrText = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_ITEMINFO;
			_itInfoStrText ctrlSetStructuredText (parseText _infoText);

			cxpadg_currZoneItMaxAmount = floor ((life_maxWeight - life_carryWeight) / (_itData # 2));
			private _maxAmountInfo = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_AMOUNT;
			_maxAmountInfo ctrlSetText format[["STR_CXP_ADG_Text_GatherAmount"] call cxp_utils_fnc_getRealText, cxpadg_currZoneItMaxAmount, (_itData # 0)];

			private _ctrlBtn = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_BTN_START;
			if (cxpadg_currZoneItMaxAmount isEqualTo 0) then {
				_ctrlBtn ctrlEnable false;
				_ctrlBtn ctrlSetTooltip format[["STR_CXP_ADG_ToolTip_BtnStart_SelectedOut"] call cxp_utils_fnc_getRealText];
			} else {
				_ctrlBtn ctrlEnable true;
				_ctrlBtn ctrlSetTooltip format[["STR_CXP_ADG_ToolTip_BtnStart"] call cxp_utils_fnc_getRealText];
			};
		} else {
			cxpadg_currMkName = lbData[ctrlIDC _ctrl, _selectedIndex];
			private _procLoc = getMarkerPos cxpadg_currMkName;
			private _mapCtrl = (findDisplay IDD_CXP_ADG_MENU) displayCtrl IDC_CXP_ADG_MENU_MAPCTRL;
			_mapCtrl ctrlMapAnimAdd [0.5, 0.15, _procLoc];
			ctrlMapAnimCommit _mapCtrl;
		};
	};
};
