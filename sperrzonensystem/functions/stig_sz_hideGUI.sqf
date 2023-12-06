/*
  Dieses Skript steuert die Sichtbarkeit des Sperrzonen-GUIs.
*/

// Standardwert für Fade-Effekt
_fade = 0;

// Überprüfen, ob das GUI sichtbar ist
if (stig_sz_GUI_isVisible) then {
  // Wenn sichtbar, Fade auf 1 setzen und Tooltip aktualisieren
  _fade = 1;
  (uiNamespace getVariable "stig_sz_hideButton") ctrlSetTooltip "Sperrzonensystem öffnen";
} else {
  // Wenn nicht sichtbar, Tooltip aktualisieren
  (uiNamespace getVariable "stig_sz_hideButton") ctrlSetTooltip "Sperrzonensystem schließen";
}

// Die Sichtbarkeit des GUI umkehren
stig_sz_GUI_isVisible = !stig_sz_GUI_isVisible;

// Deaktivierung der Serialisierung, um unerwünschte Effekte zu vermeiden
disableSerialization;

// Iteration über alle GUI-Elemente und Anpassung der Sichtbarkeit und des Fade-Effekts
{
  _x ctrlEnable stig_sz_GUI_isVisible;
  _x ctrlSetFade _fade;
  _x ctrlCommit 0.5;
} forEach (uiNamespace getVariable ["stig_sz_controls", []]);
