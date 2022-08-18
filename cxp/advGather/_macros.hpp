#define IDD_CXP_ADG_MENU 791481
#define IDC_CXP_ADG_MENU_MAPCTRL 1474
#define IDC_CXP_ADG_MENU_ITEMINFO 1471
#define IDC_CXP_ADG_MENU_AMOUNT 1469
#define IDC_CXP_ADG_MENU_BTN_CLOSE 1476
#define IDC_CXP_ADG_MENU_BTN_START 1477
#define IDC_CXP_ADG_MENU_BTN_MARKPROC 1478
#define IDC_CXP_ADG_MENU_PROGRESSBAR 1480
#define IDC_CXP_ADG_MENU_PROGRESSBAR_TEXT 1481
#define IDC_CXP_ADG_MENU_LISTBOX_PROCS 1482
#define IDC_CXP_ADG_MENU_LISTBOX_ITEMS 1484
#define IDC_CXP_ADG_MENU_BACKPACK 1485

#define PIXEL_GRID_X	((getResolution select 2) * 0.5 * pixelW)
#define PIXEL_GRID_Y	((getResolution select 3) * 0.5 * pixelH)
#define PIXEL_GRID_W	(pixelW * pixelGrid)
#define PIXEL_GRID_H	(pixelH * pixelGrid)
#define PIXEL_GRID_SIZEEX (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)

#define BACKGROUND_COLOR {0.176, 0.235, 0.302, 1.000} // #2d3c4d
#define ACTIVE_COLOR {0.255, 0.427, 0.545, 1.000}     // #416d8b
#define TEXT_COLOR {0.980, 0.980, 0.980, 1.000}       // #fafafa
#define TEXT_COLOR_HEX "#fafafa"
#define TEXT_COLOR_ALT {0.980, 0.980, 0.980, 1.000}       // #ffffff
#define DISABLED_COLOR {0.667, 0.737, 0.749, 1.000}   // #aabcbf
#define SELECT_COLOR {0.255, 0.427, 0.545, 1.000}     // #416d8b

#define TEXT_FONT "RobotoCondensedBold"
