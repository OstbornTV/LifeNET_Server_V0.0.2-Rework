/*
  Dieses Skript entfernt eine Sperrzone anhand ihres Markers.
*/

// Multi-Side-Unterstützung hinzufügen
_this = (str _this) + (str side player);

// Überprüfen, ob die Sperrzone existiert
if ((getMarkerPos (format ["stig_sz_markerA%1",_this])) isEqualTo [0,0,0]) then {
  // Die Sperrzone existiert nicht, daher wird das Skript beendet und eine Meldung angezeigt
  exitWith {
    hint format ["Sperrzone %1 kann nicht gelöscht werden, da sie nicht erstellt wurde.", _this];
  };
}

// Markierungen für die Sperrzone löschen
deleteMarker (format ["stig_sz_markerA%1", _this]);
deleteMarker (format ["stig_sz_markerB%1", _this]);

// Statusaktualisierung
(uiNamespace getVariable "stig_sz_status") ctrlSetText "Sperrzone entfernt. Bereit.";

// Remote-Ausführung der Funktion "stig_sz_msg_del"
_this remoteExecCall ["stig_sz_msg_del", 0, false];
