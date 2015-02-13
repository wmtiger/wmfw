package com.fw.view.comps.style
{
	import flash.filters.DropShadowFilter;

	public class StyleDef
	{
		// 按钮风格类
		public static const BTN_DEF:String = "BTN_DEF";
		
		// Tab按钮风格类
		public static const TAB_BTN_DEF:String = "TAB_BTN_DEF";
		
		// 文本风格类
		public static const LABEL_DEF:String = "LABEL_DEF";
		
		// tab风格类
		public static const TAB_BAR_DEF:String = "TAB_BAR_DEF";
		
		// 字体名字
		public static const FONT_NAME_FZY4:String = "FZY4";
		
		
		/////////////////////////
		////   以下是默认值       ////
		/////////////////////////
		
		// 字体大小值
		public static const FONT_SIZE_14:int = 14;
		public static const FONT_SIZE_16:int = 16;
		public static const FONT_SIZE_18:int = 18;
		public static const FONT_SIZE_20:int = 20;
		
		// 字体颜色值
		public static const FONT_COLOR_WHITE:uint = 0xFFFFFF;
		public static const FONT_COLOR_GREEN:uint = 0x00FF00;
		public static const FONT_COLOR_BLUE:uint = 0x0000FF;
		public static const FONT_COLOR_PURPLE:uint = 0x0000FF;
		public static const FONT_COLOR_ORANGE:uint = 0xFFA801;
		public static const FONT_COLOR_RED:uint = 0xCC00FF;
		
		// 风格颜色值
		public static const STYLE_COlOR_DARK:uint = 0x787878; //变暗颜色
		public static const STYLE_COlOR_WHITE:uint = 0xffffff; //白色
		
		// 阴影
		public static var DROPSHADOW_BLACK:DropShadowFilter = new DropShadowFilter(2, 45, 0, 1, 2, 2, 2, 2);
		
		
		public function StyleDef()
		{
		}
	}
}