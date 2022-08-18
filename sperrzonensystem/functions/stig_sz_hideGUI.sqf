

_fade = 0;
if(stig_sz_GUI_isVisible)then{
	_fade = 1;
	(uiNamespace getVariable "stig_sz_hideButton") ctrlSetTooltip "Sperrzonensystem öffnen";
} else {
	(uiNamespace getVariable "stig_sz_hideButton") ctrlSetTooltip "Sperrzonensystem schließen";
};
stig_sz_GUI_isVisible = !stig_sz_GUI_isVisible;
disableSerialization;
{
	_x ctrlEnable stig_sz_GUI_isVisible;
	_x ctrlSetFade _fade;
	_x ctrlCommit 0.5;
} forEach (uiNamespace getVariable ["stig_sz_controls",[]]);