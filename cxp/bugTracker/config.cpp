#define true 1
#define false 0

class Cxp_Config_BugTracker {
	//Key Binding
	cxp_bt_keyOpenOn = true; // Set true to be able to open the bugtracker menu using a selected key. If you set it to false you can call the function 'call cxpbt_fnc_btnBugTracker;' to load the menu (don't use it if you don't know what you're doing!)
	cxp_bt_keyOpen = 63; // Key that opens the main menu [DEFAULT: F5] ... Check out: https://community.bistudio.com/wiki/DIK_KeyCodes

	//System Settings
	cxp_bt_allowedChar = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-+*&@$!#();çÇ/\| "; // Allowed characters
	cxp_bt_lenChar = 512; // Number of characters the textboxes should have
	cxp_bt_delay = 3; // Time in minutes to wait for the next report [DEFAULT: 3min]

	//Advanced Configuration Options - Don't edit these if you don't know what you're doing... Both functions are configured according to default AltisLife's variables' names
	cxp_bt_saveFunction = "[] call SOCK_fnc_updateRequest"; // Type the function call that your server uses to sync player's data
	cxp_bt_asyncFuntion = "[_query, 1] call DB_fnc_asyncCall"; // Type the the function call that your server uses to make queries in your database, adjust the arguments ([_query, 1]) too according to your function. 
	cxp_bt_reportFailed = "life_action_inUse || life_is_processing || (player getVariable ['restrained',false]) || (animationState player isEqualTo 'Incapacitated')"; // Conditions that prevents the menu from being opened
};
