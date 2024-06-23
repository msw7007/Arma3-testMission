class CVDialog
{
	
	idd = 3301;
	
	class controls {

		class BaseFrame: RscFrame
		{
			idc = 1801;
			text = "Запрос техники";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.352 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
		class OrderBox: RscListbox
		{
			idc = 1501;
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = 1 * GUI_GRID_H + GUI_GRID_Y;
			w = 14 * GUI_GRID_W;
			h = 12 * GUI_GRID_H;
		};
		class OrderButton: RscButton
		{
			idc = 1601;
			text = "Запрос техники";
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.522 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.055 * safezoneH;
			colorBackground[] = {0,0,0,0,7};
			action = "call L_Base_ShopVeh_Request";
		};
	};
};
class CSADialog
{
	
	idd = 3302;
	
	class controls {

		class BaseFrame: RscFrame
		{
			idc = 1802;
			text = "Выбор стратагем";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.352 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
		class OrderBox: RscListbox
		{
			idc = 1502;
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = 1 * GUI_GRID_H + GUI_GRID_Y;
			w = 14 * GUI_GRID_W;
			h = 12 * GUI_GRID_H;
		};
		class OrderButton: RscButton
		{
			idc = 1602;
			text = "Добавить";
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.522 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.055 * safezoneH;
			colorBackground[] = {0,0,0,0,7};
			action = "call L_StratagemAdd";
		};
	};
};
class CSRDialog
{
	
	idd = 3303;
	
	class controls {

		class BaseFrame: RscFrame
		{
			idc = 1803;
			text = "Выбор стратагем";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.352 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
		class OrderBox: RscListbox
		{
			idc = 1503;
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = 1 * GUI_GRID_H + GUI_GRID_Y;
			w = 14 * GUI_GRID_W;
			h = 12 * GUI_GRID_H;
		};
		class OrderButton: RscButton
		{
			idc = 1603;
			text = "Убрать";
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.522 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.055 * safezoneH;
			colorBackground[] = {0,0,0,0,7};
			action = "call L_StratagemRemove";
		};
	};
};
class CSSDialog
{
	
	idd = 3304;
	
	class controls {

		class BaseFrame: RscFrame
		{
			idc = 1804;
			text = "Активация стратагем";
			x = 0.035 * safezoneW + safezoneX;
			y = 0.1 * safezoneH + safezoneY;
			w = 0.35 * safezoneW;
			h = 0.2 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
		class RscStructuredText_1105: RscStructuredText
		{
			idc = 1515;
			text = "Вызов союзников";
			x = -25 * GUI_GRID_W - GUI_GRID_X;
			y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5  * GUI_GRID_H;
		};
		class RscStructuredText_1104: RscStructuredText
		{
			idc = 1514;
			text = "Стратагема 4";
			x = -25 * GUI_GRID_W - GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5 * GUI_GRID_H;
		};
		class RscStructuredText_1103: RscStructuredText
		{
			idc = 1513;
			text = "Стратагема 3";
			x = -25 * GUI_GRID_W - GUI_GRID_X;
			y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5 * GUI_GRID_H;
		};
		class RscStructuredText_1102: RscStructuredText
		{
			idc = 1512;
			text = "Стратагема 2";
			x = -25 * GUI_GRID_W - GUI_GRID_X;
			y = -3 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5  * GUI_GRID_H;
		};
		class RscStructuredText_1101: RscStructuredText
		{
			idc = 1511;
			text = "Стратагема 1";
			x = -25 * GUI_GRID_W - GUI_GRID_X;
			y = -4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5 * GUI_GRID_H;
		};
		class RscStructuredText_1110: RscStructuredText
		{
			idc = 1520;
			text = "Не активна";
			x = -5 * GUI_GRID_W - GUI_GRID_X;
			y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5 * GUI_GRID_H;
		};
		class RscStructuredText_1109: RscStructuredText
		{
			idc = 1519;
			text = "Не взята";
			x = -5 * GUI_GRID_W - GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5  * GUI_GRID_H;
		};
		class RscStructuredText_1108: RscStructuredText
		{
			idc = 1518;
			text = "Не взята";
			x = -5 * GUI_GRID_W - GUI_GRID_X;
			y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5  * GUI_GRID_H;
		};
		class RscStructuredText_1107: RscStructuredText
		{
			idc = 1517;
			text = "Не взята";
			x = -5 * GUI_GRID_W - GUI_GRID_X;
			y = -3 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5 * GUI_GRID_H;
		};
		class RscStructuredText_1106: RscStructuredText
		{
			idc = 1516;
			text = "Не взята";
			x = -5 * GUI_GRID_W - GUI_GRID_X;
			y = -4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0};
			colorActive[] = {-1,-1,-1,0};
			sizeEx = 3.5 * GUI_GRID_H;
		};
	};
};

