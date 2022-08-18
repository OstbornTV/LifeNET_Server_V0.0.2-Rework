class CXP_ADG_MENU
{
	name = "CXP_ADG_MENU";
	idd = IDD_CXP_ADG_MENU;
	onLoad = "['onLoad'] spawn cxpadg_fnc_advGatherMenu;";
	onUnload = "['onUnload'] spawn cxpadg_fnc_advGatherMenu;";

	class CXP_ADG_MENU_RscText_Base : CXP_ADG_RscText
	{
		font = TEXT_FONT;
		colorText[] = TEXT_COLOR;
		colorBackground[] = BACKGROUND_COLOR;
	};
	class CXP_ADG_MENU_RscText_Base_Left : CXP_ADG_RscText_Left
	{
		font = TEXT_FONT;
		colorText[] = TEXT_COLOR;
		colorBackground[] = BACKGROUND_COLOR;
	};
	class CXP_ADG_MENU_RscText_Base_Right : CXP_ADG_RscText_Right
	{
		font = TEXT_FONT;
		colorText[] = TEXT_COLOR;
		colorBackground[] = BACKGROUND_COLOR;
	};
	class CXP_ADG_MENU_RscButton_Base : CXP_ADG_RscButton
	{
		font = TEXT_FONT;
		colorText[] = TEXT_COLOR_ALT;
		colorBackground[] = TEXT_COLOR;
		colorBackgroundActive[] = ACTIVE_COLOR;
		colorBackgroundDisabled[] = DISABLED_COLOR;
		colorBorder[] = {-1,-1,-1,-1};
		colorDisabled[] = BACKGROUND_COLOR;
		colorFocused[] = TEXT_COLOR;
		colorShadow[] = {-1,-1,-1,-1};
	};
	class CXP_ADG_MENU_RscProgressBar_Base : CXP_ADG_RscProgressBar
	{
		font = TEXT_FONT;
		colorFrame[] = TEXT_COLOR;
		colorBackground[] = BACKGROUND_COLOR;
		colorBar[] = TEXT_COLOR;
	};
	class CXP_ADG_MENU_RscListBox_Base : CXP_ADG_RscListBox
	{
		font = TEXT_FONT;
		colorText[] = TEXT_COLOR;
		colorSelect[] = TEXT_COLOR;
		colorSelectBackground[] = ACTIVE_COLOR;
		colorSelect2[] = TEXT_COLOR;
		colorSelectBackground2[] = ACTIVE_COLOR;
		colorDisabled[] = DISABLED_COLOR;
		colorScrollbar[] = TEXT_COLOR;
		colorBackground[] = BACKGROUND_COLOR;
	};

	class ControlsBackground
	{
		class CXP_ADG_BG: CXP_ADG_MENU_RscText_Base
		{
			idc = -1;
			x = -32.6 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -24.7 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 65.3 * PIXEL_GRID_W;
			h = 53.1 * PIXEL_GRID_H;
		};
		class CXP_ADG_TITLE: CXP_ADG_MENU_RscText_Base
		{
			idc = -1;
			text = "CXP ADVANCED GATHER";
			x = -32.6 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -28.5 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 65.3 * PIXEL_GRID_W;
			h = 3.6 * PIXEL_GRID_H;
		};
		class CXP_ADG_TEXT_BACKPACK: CXP_ADG_MENU_RscText_Base_Right
		{
			idc = IDC_CXP_ADG_MENU_BACKPACK;
			text = $STR_CXP_ADG_Text_BackPack;
			x = -29.8 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -9.9 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 28.9 * PIXEL_GRID_W;
			h = 4.1 * PIXEL_GRID_H;
		};
		class CXP_ADG_GATHER_INFOBOX_TEXT: CXP_ADG_MENU_RscText_Base
		{
			idc = -1;
			text = $STR_CXP_ADG_Text_ItemInformation;
			x = -18.5 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -23.9 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 34.4 * PIXEL_GRID_W;
			h = 3.4 * PIXEL_GRID_H;
		};
		class CXP_ADG_ProcLocation_Title: CXP_ADG_MENU_RscText_Base
		{
			idc = -1;
			text = $STR_CXP_ADG_Text_ProcLoc;
			x = -15 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -7 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 27.8 * PIXEL_GRID_W;
			h = 4.5 * PIXEL_GRID_H;
		};
		class CXP_ADG_FRAME_MAP_FRAME: CXP_ADG_RscFrame
		{
			idc = -1;
			x = -29.5 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -2.5 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 29 * PIXEL_GRID_W;
			h = 15.8 * PIXEL_GRID_H;
			text = "";
			colorBackground[] = {-1,-1,-1,-1};
			colorText[] = TEXT_COLOR;
		};
		class CXP_ADG_FRAME_ITEMINFO_FRAME_2: CXP_ADG_RscFrame
		{
			idc = -1;
			x = -29.8 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -20.3 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 29.2 * PIXEL_GRID_W;
			h = 10.9 * PIXEL_GRID_H;
			text = "";
			colorBackground[] = {-1,-1,-1,-1};
			colorText[] = TEXT_COLOR;
		};
		class CXP_ADG_FRAME_PROCS_FRAME_3: CXP_ADG_RscFrame
		{
			idc = -1;
			x = 0.3 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -2.5 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 28.6 * PIXEL_GRID_W;
			h = 15.8 * PIXEL_GRID_H;
			text = "";
			colorBackground[] = {-1,-1,-1,-1};
			colorText[] = TEXT_COLOR;
		};
		class CXP_ADG_FRAME_ITEMLB_FRAME_4: CXP_ADG_RscFrame
		{
			idc = -1;
			x = 0.4 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -20.3 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 28.6 * PIXEL_GRID_W;
			h = 13.7 * PIXEL_GRID_H;
			text = "";
			colorBackground[] = {-1,-1,-1,-1};
			colorText[] = TEXT_COLOR;
		};
		class CXP_ADG_MAPCTRL: CXP_ADG_RscMapControl
		{
			idc = IDC_CXP_ADG_MENU_MAPCTRL;
			x = -29.1 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -2 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 28.1 * PIXEL_GRID_W;
			h = 14.9 * PIXEL_GRID_H;
		};
		class CXP_ADG_STRTEXT_ITEMINFO: CXP_ADG_RscStructuredText
		{
			idc = IDC_CXP_ADG_MENU_ITEMINFO;
			x = -29.1 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -19.5 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 27.6 * PIXEL_GRID_W;
			h = 9.2 * PIXEL_GRID_H;
			text = "";
			colorText[] = TEXT_COLOR;
			colorBackground[] = {-1,-1,-1,-1};
		};
		class CXP_ADG_GATHER_AMOUNT: CXP_ADG_MENU_RscText_Base
		{
			idc = IDC_CXP_ADG_MENU_AMOUNT;
			text = $STR_CXP_ADG_Text_GatherAmount;
			x = -31.3 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = 13.9 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 62.4 * PIXEL_GRID_W;
			h = 3.2 * PIXEL_GRID_H;
		};
	};
	class Controls
	{
		class CXP_ADG_BTN_CLOSE: CXP_ADG_MENU_RscButton_Base
		{
			idc = IDC_CXP_ADG_MENU_BTN_CLOSE;
			x = 9.7 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = 23.3 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 11.8 * PIXEL_GRID_W;
			h = 3.8 * PIXEL_GRID_H;
		};
		class CXP_ADG_BTN_MARKPROC: CXP_ADG_MENU_RscButton_Base
		{
			idc = IDC_CXP_ADG_MENU_BTN_MARKPROC;
			x = -6.4 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = 23.2 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 11.8 * PIXEL_GRID_W;
			h = 3.8 * PIXEL_GRID_H;
		};
		class CXP_ADG_BTN_START: CXP_ADG_MENU_RscButton_Base
		{
			idc = IDC_CXP_ADG_MENU_BTN_START;
			x = -22.4 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = 23.3 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 11.8 * PIXEL_GRID_W;
			h = 3.8 * PIXEL_GRID_H;
		};
		class CXP_ADG_PROGRESSBAR: CXP_ADG_MENU_RscProgressBar_Base
		{
			idc = IDC_CXP_ADG_MENU_PROGRESSBAR;
			x = -29.4 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = 18 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 58.3 * PIXEL_GRID_W;
			h = 3.6 * PIXEL_GRID_H;
		};
		class CXP_ADG_PROGRESSBAR_Text: CXP_ADG_MENU_RscText_Base
		{
			idc = IDC_CXP_ADG_MENU_PROGRESSBAR_TEXT;
			x = -29.4 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = 18 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 58.3 * PIXEL_GRID_W;
			h = 3.6 * PIXEL_GRID_H;
			colorText[] = ACTIVE_COLOR;
			colorBackground[] = {-1,-1,-1,-1};
		};
		class CXP_ADG_LISTBOX_PROCS: CXP_ADG_MENU_RscListBox_Base
		{
			idc = IDC_CXP_ADG_MENU_LISTBOX_PROCS;
			x = 0.7 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -2 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 27.7 * PIXEL_GRID_W;
			h = 15 * PIXEL_GRID_H;
			onLBSelChanged = "['onLBSelChanged', _this] spawn cxpadg_fnc_advGatherMenu;";
		};
		class CXP_ADG_LISTBOX_ITEMS: CXP_ADG_MENU_RscListBox_Base
		{
			idc = IDC_CXP_ADG_MENU_LISTBOX_ITEMS;
			x = 0.8 * PIXEL_GRID_W + PIXEL_GRID_X;
			y = -19.9 * PIXEL_GRID_H + PIXEL_GRID_Y;
			w = 27.7 * PIXEL_GRID_W;
			h = 12.8 * PIXEL_GRID_H;
			onLBSelChanged = "['onLBSelChanged', _this, 1] spawn cxpadg_fnc_advGatherMenu;";
		};
	};
};