/*
This script loads all the functions into variables.
*/

{
	call compile format ["%1 = compileFinal preprocessfilelinenumbers ""%2functions\%1.sqf""",_x,stig_sz_root];
} forEach [
	"stig_sz_add",
	"stig_sz_del",
	"stig_sz_find",
	"stig_sz_hideGUI",
	"stig_sz_msg_add",
	"stig_sz_msg_del"
];
