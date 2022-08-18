
_this = ((str _this) + (str side player)); //<< adds multi side support

if((getMarkerPos ( format ["stig_sz_markerA%1",_this] )) isEqualTo [0,0,0]) exitWith {
	hint format ["Sperrzone %1 existiert nicht.",_this]; 
};
stig_sz_vorschaumarker_var setMarkerPosLocal (getMarkerPos(format ["stig_sz_markerA%1",_this] ));
stig_sz_vorschaumarker_var setMarkerSizeLocal (getMarkerSize(format ["stig_sz_markerA%1",_this] ));