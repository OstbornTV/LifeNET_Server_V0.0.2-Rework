#include "_macros.hpp"

import RscMapControl;
class CXP_ADG_RscMapControl : RscMapControl {
	sizeEx = PIXEL_GRID_SIZEEX;
};

import RscText;
class CXP_ADG_RscText : RscText {
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	colorShadow[] = {0,0,0,0.5};
	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	style = 0x2; // Centered
	shadow = 0;
	sizeEx = PIXEL_GRID_SIZEEX;
};

class CXP_ADG_RscText_Left : CXP_ADG_RscText {style=0x0;};
class CXP_ADG_RscText_Right : CXP_ADG_RscText {style=0x1;};

import RscProgress;
class CXP_ADG_RscProgressBar : RscProgress {
	type = 8; // CT_PROGRESS
	colorFrame[] = {1, 0, 0, 1};
    colorBackground[] = {0,0,0,0.9};
    colorBar[] = {1, 0, 0, 1};
    texture = "";
};

import RscButton;
class CXP_ADG_RscButton : RscButton {
	colorBackground[] = {0,0,0,1};
	colorBackgroundActive[] = {0.502,0.502,0.502,1};
	colorBackgroundDisabled[] = {0,0,0,0};
	colorBorder[] = {0,0,0,0};
	colorDisabled[] = {0,0,0,0};
	colorFocused[] = {0,0,0,1};
	colorShadow[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	sizeEx = PIXEL_GRID_SIZEEX;
};

import RscFrame;
class CXP_ADG_RscFrame : RscFrame {
	sizeEx = PIXEL_GRID_SIZEEX;
};

import RscStructuredText;
class CXP_ADG_RscStructuredText : RscStructuredText {
	sizeEx = PIXEL_GRID_SIZEEX;
};

import RscListBox;
class CXP_ADG_RscListBox : RscListBox {
	sizeEx = PIXEL_GRID_SIZEEX;
};

#include "CXP_ADG_MENU.hpp"
