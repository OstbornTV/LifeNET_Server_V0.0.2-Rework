
_this = ((str _this) + (str side player)); //<< adds multi side support

if ((getMarkerPos ( format ["stig_sz_markerA%1",_this] )) isEqualTo [0,0,0]) exitWith {
	hint format ["Sperrzone %1 kann nicht gelöscht werden, da sie nicht erstellt wurde.",_this];
};
deleteMarker (format["stig_sz_markerA%1",_this]);
deleteMarker (format["stig_sz_markerB%1",_this]);
(uiNamespace getVariable "stig_sz_status") ctrlSetText "Sperrzone entfernt. Bereit.";
_this remoteExecCall ["stig_sz_msg_del",0,false];