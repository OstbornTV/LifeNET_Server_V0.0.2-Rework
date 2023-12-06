/*
  Dieses Skript zeigt eine Vorschau für eine vorhandene Sperrzone an.
*/

// Multi-Side-Unterstützung hinzufügen
_this = (str _this) + (str side player);

// Überprüfen, ob die Sperrzone existiert
if ((getMarkerPos (format ["stig_sz_markerA%1", _this])) isEqualTo [0, 0, 0]) then {
  // Die Sperrzone existiert nicht, daher wird das Skript beendet und eine Meldung angezeigt
  hint format ["Sperrzone %1 existiert nicht.", _this];
  exitWith {};
}

// Position und Größe der Vorschau aktualisieren
stig_sz_vorschaumarker_var setMarkerPosLocal (getMarkerPos (format ["stig_sz_markerA%1", _this]));
stig_sz_vorschaumarker_var setMarkerSizeLocal (getMarkerSize (format ["stig_sz_markerA%1", _this]));
