

disableSerialization;
stig_sz_GUI_isVisible = true;
with uiNamespace do {
	disableSerialization;
	diag_log "Sperrzonensystem: UI wird initialisiert.";

	_display = findDisplay 12;
	comment "array of all controls to (un)hide them later via button";
	stig_sz_controls = [];
	_pushIntoArray = {
		stig_sz_controls pushBack _this;
	};
	_sidergba = ([side player] call BIS_fnc_sideColor);
	_sidergba set [3,0.5];
	_sideColor = {
		_this ctrlSetBackgroundColor _sidergba;
	};

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "1";
	_cur ctrlSetPosition [0, 0.68, 0.0375, 0.08];
	_cur call _sideColor; //ctrlSetBackgroundColor [-1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "1 spawn stig_sz_find";
	_cur ctrlSetTooltip "Vorhandene Sperrzone grau markieren";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "2";
	_cur ctrlSetPosition [0, 0.76, 0.0375, 0.08];
	_cur call _sideColor; //ctrlSetBackgroundColor [-1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "2 spawn stig_sz_find";
	_cur ctrlSetTooltip "Vorhandene Sperrzone grau markieren";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "3";
	_cur ctrlSetPosition [0, 0.84, 0.0375, 0.08];
	_cur call _sideColor; //ctrlSetBackgroundColor [-1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "3 spawn stig_sz_find";
	_cur ctrlSetTooltip "Vorhandene Sperrzone grau markieren";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "4";
	_cur ctrlSetPosition [0, 0.92, 0.0375, 0.08];
	_cur call _sideColor; //ctrlSetBackgroundColor [-1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "4 spawn stig_sz_find";
	_cur ctrlSetTooltip "Vorhandene Sperrzone grau markieren";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "+";
	_cur ctrlSetPosition [0.0375, 0.68, 0.0625, 0.08];
	_cur ctrlSetTextColor [-1,1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "1 spawn stig_sz_add";
	_cur ctrlSetTooltip "Sperrzone erstellen";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "+";
	_cur ctrlSetPosition [0.0375, 0.76, 0.0625, 0.08];
	_cur ctrlSetTextColor [-1,1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "2 spawn stig_sz_add";
	_cur ctrlSetTooltip "Sperrzone erstellen";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "+";
	_cur ctrlSetPosition [0.0375, 0.84, 0.0625, 0.08];
	_cur ctrlSetTextColor [-1,1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "3 spawn stig_sz_add";
	_cur ctrlSetTooltip "Sperrzone erstellen";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "+";
	_cur ctrlSetPosition [0.0375, 0.92, 0.0625, 0.08];
	_cur ctrlSetTextColor [-1,1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "4 spawn stig_sz_add";
	_cur ctrlSetTooltip "Sperrzone erstellen";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "X";
	_cur ctrlSetPosition [0.1, 0.68, 0.0625, 0.08];
	_cur ctrlSetTextColor [1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "1 spawn stig_sz_del";
	_cur ctrlSetTooltip "Sperrzone entfernen";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "X";
	_cur ctrlSetPosition [0.1, 0.76, 0.0625, 0.08];
	_cur ctrlSetTextColor [1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "2 spawn stig_sz_del";
	_cur ctrlSetTooltip "Sperrzone entfernen";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "X";
	_cur ctrlSetPosition [0.1, 0.84, 0.0625, 0.08];
	_cur ctrlSetTextColor [1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "3 spawn stig_sz_del";
	_cur ctrlSetTooltip "Sperrzone entfernen";
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "X";
	_cur ctrlSetPosition [0.1, 0.92, 0.0625, 0.08];
	_cur ctrlSetTextColor [1,-1,-1,1];
	_cur ctrlCommit 0;
	_cur buttonSetAction "4 spawn stig_sz_del";
	_cur ctrlSetTooltip "Sperrzone entfernen";
	_cur call _pushIntoArray;

	stig_sz_status = _display ctrlCreate ["RscText", -1];
	stig_sz_status ctrlSetPosition [0.275, 0.76, 0.35, 0.08];
	stig_sz_status call _sideColor; //ctrlSetBackgroundColor [-1,-1,1,0.5];
	stig_sz_status ctrlCommit 0;
	stig_sz_status call _pushIntoArray;

	stig_sz_regler = _display ctrlCreate ["RscSlider", -1];
	stig_sz_regler ctrlSetPosition [0.1625, 0.88, 0.4625, 0.12];
	stig_sz_regler call _sideColor; //ctrlSetBackgroundColor [-1,-1,-1,1];
	stig_sz_regler ctrlCommit 0;
	stig_sz_regler ctrlSetTooltip "Verschiebe den Regler, um den Radius zu bestimmen.";
	stig_sz_regler call _pushIntoArray;
	stig_sz_regler ctrlAddEventHandler ["SliderPosChanged",{(uiNamespace getVariable "stig_sz_radius") ctrlSetText (str (round (sliderPosition (uiNamespace getVariable "stig_sz_regler"))))}];

	_cur = _display ctrlCreate ["RscText", -1];
	_cur ctrlSetText "Radius der Sperrzone:";
	_cur ctrlSetPosition [0.1625, 0.84, 0.2625, 0.04];
	_cur ctrlSetTextColor [1,1,1,1];
	_cur call _sideColor; //ctrlSetBackgroundColor [-1,-1,1,0.5];
	_cur ctrlCommit 0;
	_cur call _pushIntoArray;

	_cur = _display ctrlCreate ["RscText", -1];
	_cur ctrlSetText "Status:";
	_cur ctrlSetPosition [0.1625, 0.76, 0.1125, 0.08];
	_cur call _sideColor; //ctrlSetBackgroundColor [-1,-1,1,0.5];
	_cur ctrlCommit 0;
	_cur call _pushIntoArray;

	stig_sz_radius = _display ctrlCreate ["RscText", -1];
	stig_sz_radius ctrlSetPosition [0.425, 0.84, 0.2, 0.04];
	stig_sz_radius call _sideColor; //ctrlSetBackgroundColor [-1,-1,1,0.5];
	stig_sz_radius ctrlCommit 0;
	stig_sz_radius call _pushIntoArray;
	_cur = _display ctrlCreate ["RscButton", -1];
	_cur ctrlSetText "Sperrzonensystem";
	_cur ctrlSetPosition [0.1625, 0.68, 0.4625, 0.08];
	_cur call _sideColor; //ctrlSetBackgroundColor [1,1,1,1];
	_cur ctrlCommit 0;
	_cur ctrlSetTooltip "";
	_cur buttonSetAction "hint 'Sperrzonenscript von Stig.\nZu finden auf Native-Network.net'";
	_cur call _pushIntoArray;

	comment "Slider Setup";
	stig_sz_regler sliderSetRange [missionNamespace getVariable ["stig_sz_radius_min",300],missionNamespace getVariable ["stig_sz_radius_max",1000]];
	stig_sz_regler sliderSetSpeed [50,50];

	comment "Text Setup";
	stig_sz_status ctrlSetText "Bereit zum Erstellen.";
	stig_sz_radius ctrlSetText str ( sliderPosition stig_sz_regler );



	//A button which was always visible in the top bar of the map,
	//but didnt worked reliable, therefore replaced by clickable diary record
	/*
	stig_sz_hideButton = (call _display) ctrlCreate ["RscButton", -1];
	stig_sz_hideButton ctrlSetText "Sperrzonensystem";
	//stig_sz_hideButton ctrlSetPosition [17.904033 * ( ((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX) , 0.33333 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY) ,5.1978 * (((safezoneW / safezoneH) min 1.2) / 40) ,1 *  ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)];
	stig_sz_hideButton ctrlSetPosition [35 * ( ((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX) , 0.23333 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY) ,6 * (((safezoneW / safezoneH) min 1.2) / 40) ,1 *  ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)];
	stig_sz_hideButton ctrlSetTooltip "Sperrzonensystem öffnen";
	stig_sz_hideButton buttonsetAction "call stig_sz_hideGUI;";
	stig_sz_hideButton ctrlCommit 0;
	*/
	player createDiarySubject ["sperrzonensystem","Sperrzonensystem"];
	player createDiaryRecord ["sperrzonensystem", ["UI ein-/ausblenden", "<br/><execute expression='call stig_sz_hideGUI'>Klicke hier, um das Overlay zur Sperrzonenverwaltung ein- oder auszublenden.</execute>" ]];
};

addMissionEventHandler ["MapSingleClick", {
	params ["_units", "_pos", "_alt", "_shift"];
	stig_sz_mapclick = _pos;
}];
//onMapSingleClick {stig_sz_mapclick = +_pos;};
stig_sz_vorschau = "";
stig_sz_mapclick = [0,0,0];
(findDisplay 12) displayAddEventHandler ["keyDown",{if(_this select 1==28)then{stig_sz_enter=true;}}];

stig_sz_vorschaumarker_var = createMarkerLocal ["stig_sz_vorschaumarker", [0,0]];
stig_sz_vorschaumarker_var setMarkerShapeLocal "ELLIPSE";
stig_sz_vorschaumarker_var setMarkerColorLocal "ColorBlack";
stig_sz_vorschaumarker_var setMarkerSizeLocal [0,0];

//call stig_sz_hideGUI;
diag_log "Sperrzonensystem: Initialisierung abgeschlossen.";