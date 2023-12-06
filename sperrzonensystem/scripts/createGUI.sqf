/*
  Dieser Abschnitt deaktiviert die Serialisierung und initialisiert globale Variablen.
*/
disableSerialization;
stig_sz_GUI_isVisible = true;

/*
  UI-Namespace wird verwendet, um globale UI-Elemente zu speichern und zu organisieren.
*/
with uiNamespace do {
  disableSerialization;
  diag_log "Sperrzonensystem: UI wird initialisiert.";

  // Das Display mit der ID 12 wird abgerufen
  _display = findDisplay 12;

  // Array zum Speichern aller Steuerelemente für (de)aktivierung über Schaltflächen
  stig_sz_controls = [];
  _pushIntoArray = {
    stig_sz_controls pushBack _this;
  };

  // Farbeinstellungen für die Seiten (Fraktionen)
  _sidergba = ([side player] call BIS_fnc_sideColor);
  _sidergba set [3, 0.5];
  _sideColor = {
    _this ctrlSetBackgroundColor _sidergba;
  };

  // Funktion zum Erstellen von Steuerelementen
  _createControl = {
    _cur = _display ctrlCreate ["RscButton", -1];
    _cur ctrlSetText _this select 0;
    _cur ctrlSetPosition (_this select 1);
    _cur call _sideColor;
    _cur ctrlCommit 0;
    _cur buttonSetAction format ["%1 spawn stig_sz_%2", _this select 2, _this select 3];
    _cur ctrlSetTooltip (_this select 4);
    _cur call _pushIntoArray;
  };

  // Schaltflächen für das Markieren von Sperrzonen
  {
    _createControl [
      str _x,
      [0, 0.68 + 0.08 * (_x - 1), 0.0375, 0.08],
      "find",
      "Vorhandene Sperrzone grau markieren"
    ];
  } forEach [1, 2, 3, 4];

  // Schaltflächen für das Hinzufügen von Sperrzonen
  {
    _createControl [
      "+",
      [0.0375, 0.68 + 0.08 * (_x - 1), 0.0625, 0.08],
      "add",
      "Sperrzone erstellen"
    ];
  } forEach [1, 2, 3, 4];

  // Schaltflächen für das Entfernen von Sperrzonen
  {
    _createControl [
      "X",
      [0.1, 0.68 + 0.08 * (_x - 1), 0.0625, 0.08],
      "del",
      "Sperrzone entfernen"
    ];
  } forEach [1, 2, 3, 4];

  // Statusanzeige
  stig_sz_status = _display ctrlCreate ["RscText", -1];
  stig_sz_status ctrlSetPosition [0.275, 0.76, 0.35, 0.08];
  stig_sz_status call _sideColor;
  stig_sz_status ctrlCommit 0;
  stig_sz_status call _pushIntoArray;

  // Radiusregler
  stig_sz_regler = _display ctrlCreate ["RscSlider", -1];
  stig_sz_regler ctrlSetPosition [0.1625, 0.88, 0.4625, 0.12];
  stig_sz_regler call _sideColor;
  stig_sz_regler ctrlCommit 0;
  stig_sz_regler ctrlSetTooltip "Verschiebe den Regler, um den Radius zu bestimmen.";
  stig_sz_regler call _pushIntoArray;
  stig_sz_regler ctrlAddEventHandler [
    "SliderPosChanged",
    {
      (uiNamespace getVariable "stig_sz_radius") ctrlSetText (str (round (sliderPosition (uiNamespace getVariable "stig_sz_regler"))));
    }
  ];

  // Textanzeige für den Radius
  _createControl [
    "Radius der Sperrzone:",
    [0.1625, 0.84, 0.2625, 0.04],
    "",
    "ctrlSetBackgroundColor [-1,-1,1,0.5]"
  ];

  // Textanzeige für den Status
  _createControl [
    "Status:",
    [0.1625, 0.76, 0.1125, 0.08],
    "",
    "ctrlSetBackgroundColor [-1,-1,1,0.5]"
  ];

  // Textanzeige für den Radius-Wert
  stig_sz_radius = _display ctrlCreate ["RscText", -1];
  stig_sz_radius ctrlSetPosition [0.425, 0.84, 0.2, 0.04];
  stig_sz_radius call _sideColor;
  stig_sz_radius ctrlCommit 0;
  stig_sz_radius call _pushIntoArray;

  // Schaltfläche für Information
  _cur = _display ctrlCreate ["RscButton", -1];
  _cur ctrlSetText "Sperrzonensystem";
  _cur ctrlSetPosition [0.1625, 0.68, 0.4625, 0.08];
  _cur call _sideColor;
  _cur ctrlCommit 0;
  _cur ctrlSetTooltip "";
  _cur buttonSetAction "hint 'Sperrzonenscript von Stig.\nZu finden auf Native-Network.net'";
  _cur call _pushIntoArray;

  // Slider-Einstellungen
  stig_sz_regler sliderSetRange [
    missionNamespace getVariable ["stig_sz_radius_min", 300],
    missionNamespace getVariable ["stig_sz_radius_max", 1000]
  ];
  stig_sz_regler sliderSetSpeed [50, 50];

  // Textanzeige für den Status
  stig_sz_status ctrlSetText "Bereit zum Erstellen.";

  // Textanzeige für den Radius-Wert
  stig_sz_radius ctrlSetText str (sliderPosition stig_sz_regler);

  // Ereignisbehandlung für den Klick auf die Karte
  addMissionEventHandler ["MapSingleClick", {
    params ["_units", "_pos", "_alt", "_shift"];
    stig_sz_mapclick = _pos;
  }];

  // Variable für Vorschau-Marker
  stig_sz_vorschau = "";
  stig_sz_mapclick = [0, 0, 0];
  (findDisplay 12) displayAddEventHandler [
    "keyDown",
    {
      if (_this select 1 == 28) then {
        stig_sz_enter = true;
      };
    }
  ];

  // Vorschaumarker-Einstellungen
  stig_sz_vorschaumarker_var = createMarkerLocal ["stig_sz_vorschaumarker", [0, 0]];
  stig_sz_vorschaumarker_var setMarkerShapeLocal "ELLIPSE";
  stig_sz_vorschaumarker_var setMarkerColorLocal "ColorBlack";
  stig_sz_vorschaumarker_var setMarkerSizeLocal [0, 0];

  // Tagebuch-Eintrag für das Sperrzonensystem
  player createDiarySubject ["sperrzonensystem", "Sperrzonensystem"];
  player createDiaryRecord [
    "sperrzonensystem",
    [
      "UI ein-/ausblenden",
      "<br/><execute expression='call stig_sz_hideGUI'>Klicke hier, um das Overlay zur Sperrzonenverwaltung ein- oder auszublenden.</execute>"
    ]
  ];
};

// Ereignisbehandlung für den Klick auf die Karte
addMissionEventHandler ["MapSingleClick", {
  params ["_units", "_pos", "_alt", "_shift"];
  stig_sz_mapclick = _pos;
}];

// Initialisierung abgeschlossen
diag_log "Sperrzonensystem: Initialisierung abgeschlossen.";