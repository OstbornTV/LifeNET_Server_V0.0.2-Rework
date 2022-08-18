//_this spawn { //spawn this function with markername as arg

_this = ((str _this) + (str side player)); //<< adds multi side support
stig_sz_current = _this;
if!((getMarkerPos ( format ["stig_sz_markerA%1",_this] )) isEqualTo [0,0,0]) exitWith { hint format ["Sperrzone %1 kann nicht erstellt werden. Du musst sie erst entfernen.",_this]; };
(uiNamespace getVariable "stig_sz_status") ctrlSetText "Wähle das Sperrzonenzentrum.";
_a = stig_sz_mapclick;
waitUntil { !(_a isEqualTo stig_sz_mapclick) };
stig_sz_enter = false;
(uiNamespace getVariable "stig_sz_status") ctrlSetText "Bestätige mit ENTER.";
waitUntil{
	stig_sz_vorschaumarker_var setMarkerSizeLocal [sliderPosition (uiNamespace getVariable "stig_sz_regler"),sliderPosition (uiNamespace getVariable "stig_sz_regler")];
	stig_sz_vorschaumarker_var setMarkerPosLocal stig_sz_mapclick;
	//(uiNamespace getVariable "stig_sz_radius") ctrlSetText str round sliderPosition (uiNamespace getVariable "stig_sz_regler");   //<< becomes a draw eventhandler
	stig_sz_enter OR !visibleMap;
};
if(stig_sz_current != _this)exitWith{}; //Kill thread if user decided to take another slot	
if(!visibleMap)exitWith{diag_log "SZ GUI - Erstellung abgebrochen: Map geschlossen."; (uiNamespace getVariable "stig_sz_status") ctrlSetText "Abbruch: Map geschlossen. Bereit."; stig_sz_vorschaumarker_var setMarkerSizeLocal [0,0];};
if!((getMarkerPos ( format ["stig_sz_markerA%1",_this] )) isEqualTo [0,0,0]) exitWith { hint "Fehler: Sperrzonenerstellung wurde automatisch abgebrochen. Grund: Mehrere Personen erstellten gleichzeitig die gleiche Sperrzone."; stig_sz_vorschaumarker_var setMarkerSizeLocal [0,0]; };

comment "Marker Teil 1 erstellen (Schräge Striche)";
_m = createMarker [format ["stig_sz_markerA%1",_this],stig_sz_mapclick];
_m setMarkerShape "ELLIPSE";
_m setMarkerColor ([ side player, true ] call BIS_fnc_sideColor);
_m setMarkerSize [(sliderPosition (uiNamespace getVariable "stig_sz_regler")),(sliderPosition (uiNamespace getVariable "stig_sz_regler"))];
_m setMarkerText (format["Polizeisperrzone %1",_this]);
_m setMarkerAlpha 0.5;
_m setMarkerBrush "FDiagonal";

comment "Marker Teil 2 erstellen (Zone)";
_m = createMarker [format ["stig_sz_markerB%1",_this],stig_sz_mapclick];
_m setMarkerShape "ELLIPSE";
_m setMarkerColor ([ side player, true ] call BIS_fnc_sideColor);
_m setMarkerSize [(sliderPosition (uiNamespace getVariable "stig_sz_regler")),(sliderPosition (uiNamespace getVariable "stig_sz_regler"))];
_m setMarkerText (format["Polizeisperrzone %1",_this]);
_m setMarkerAlpha 0.5;
_m setMarkerBrush "SolidBorder";

(uiNamespace getVariable "stig_sz_status") ctrlSetText "Sperrzone erstellt. Bereit.";

stig_sz_vorschaumarker_var setMarkerPosLocal [0,0];
stig_sz_vorschaumarker_var setMarkerSizeLocal [0,0];
_this remoteExecCall ["stig_sz_msg_add",0,false];
//}