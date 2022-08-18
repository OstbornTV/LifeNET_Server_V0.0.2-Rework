/*
	Author: Casperento
	
	Description:
	Format a given string that will be passed to MySQL

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
if (_this isEqualTo "" || !(_this isEqualType "STRING")) exitWith {diag_log "[CXP-UTILS] Invalid string passed to mresString function..."};

private _chars = toArray "{}[]`´'/\:|;,-""<>";
_this = toArray _this;
_this = _this select {!(_x in _chars)};

toString _this;
