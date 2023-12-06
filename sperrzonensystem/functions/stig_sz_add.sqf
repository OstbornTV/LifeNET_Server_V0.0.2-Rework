// Das Argument _this wird in einen String umgewandelt und mit der Spielerfraktion kombiniert.
_this = (str _this) + (str side player); //<< Fügt Multi-Side-Unterstützung hinzu
stig_sz_current = _this;

// Überprüfen, ob eine Sperrzone mit dem gleichen Marker bereits existiert
if (!((getMarkerPos (format ["stig_sz_markerA%1", _this])) isEqualTo [0, 0, 0])) then {
  exitWith {
    hint format ["Sperrzone %1 kann nicht erstellt werden. Du musst sie erst entfernen.", _this];
  };
};

// Statusaktualisierung und Wartezeit, bis das Zentrum ausgewählt wird
(uiNamespace getVariable "stig_sz_status") ctrlSetText "Wähle das Sperrzonenzentrum.";
_a = stig_sz_mapclick;
waitUntil { !(_a isEqualTo stig_sz_mapclick) };
stig_sz_enter = false;
(uiNamespace getVariable "stig_sz_status") ctrlSetText "Bestätige mit ENTER.";

// Wartezeit bis zur Bestätigung (ENTER-Taste)
waitUntil {
  stig_sz_vorschaumarker_var setMarkerSizeLocal [
    sliderPosition (uiNamespace getVariable "stig_sz_regler"),
    sliderPosition (uiNamespace getVariable "stig_sz_regler")
  ];
  stig_sz_vorschaumarker_var setMarkerPosLocal stig_sz_mapclick;
  stig_sz_enter OR !visibleMap;
};

// Überprüfen, ob der Benutzer sich für einen anderen Slot entschieden hat
if (stig_sz_current != _this) exitWith {};

// Überprüfen, ob die Karte geschlossen wurde
if (!visibleMap) exitWith {
  diag_log "SZ GUI - Erstellung abgebrochen: Map geschlossen.";
  (uiNamespace getVariable "stig_sz_status") ctrlSetText "Abbruch: Map geschlossen. Bereit.";
  stig_sz_vorschaumarker_var setMarkerSizeLocal [0, 0];
};

// Überprüfen, ob eine Sperrzone mit dem gleichen Marker während der Wartezeit erstellt wurde
if (!((getMarkerPos (format ["stig_sz_markerA%1", _this])) isEqualTo [0, 0, 0])) then {
  exitWith {
    hint "Fehler: Sperrzonenerstellung wurde automatisch abgebrochen. Grund: Mehrere Personen erstellten gleichzeitig die gleiche Sperrzone.";
    stig_sz_vorschaumarker_var setMarkerSizeLocal [0, 0];
  };
};

// Marker Teil 1 erstellen (Schräge Striche)
_m = createMarker [format ["stig_sz_markerA%1", _this], stig_sz_mapclick];
_m setMarkerShape "ELLIPSE";
_m setMarkerColor ([side player, true] call BIS_fnc_sideColor);
_m setMarkerSize [sliderPosition (uiNamespace getVariable "stig_sz_regler"), sliderPosition (uiNamespace getVariable "stig_sz_regler")];
_m setMarkerText (format["Polizeisperrzone %1", _this]);
_m setMarkerAlpha 0.5;
_m setMarkerBrush "FDiagonal";

// Marker Teil 2 erstellen (Zone)
_m = createMarker [format ["stig_sz_markerB%1", _this], stig_sz_mapclick];
_m setMarkerShape "ELLIPSE";
_m setMarkerColor ([side player, true] call BIS_fnc_sideColor);
_m setMarkerSize [sliderPosition (uiNamespace getVariable "stig_sz_regler"), sliderPosition (uiNamespace getVariable "stig_sz_regler")];
_m setMarkerText (format["Polizeisperrzone %1", _this]);
_m setMarkerAlpha 0.5;
_m setMarkerBrush "SolidBorder";

// Statusaktualisierung
(uiNamespace getVariable "stig_sz_status") ctrlSetText "Sperrzone erstellt. Bereit.";

// Zurücksetzen des Vorschaumarkers
stig_sz_vorschaumarker_var setMarkerPosLocal [0, 0];
stig_sz_vorschaumarker_var setMarkerSizeLocal [0, 0];

// Remote-Ausführung der Funktion "stig_sz_msg_add"
_this remoteExecCall ["stig_sz_msg_add", 0, false];