
//Minimum and maximum value you can select as radius with the slider
stig_sz_radius_min = 300;
stig_sz_radius_max = 2000;

//Enable/Disable the system for a side. True means the side can use it.
stig_sz_enable_WEST	= true;
stig_sz_enable_EAST	= true;
stig_sz_enable_GUER	= false;
stig_sz_enable_CIV	= false;

//Optional. Here you can add a condition which must return true in order to activate the system for a player.
//Condition is executed locally on the player's machine. Only the condition of the player's side is used.
//For example this is useful if you have a life server and only want players with a minimum level to be able to use the system.
stig_sz_condition_WEST	= {true};
stig_sz_condition_EAST	= {true};
stig_sz_condition_GUER	= {true};
stig_sz_condition_CIV	= {true};