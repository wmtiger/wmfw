package com.fw.view.comps.base
{
	import feathers.core.FeathersControl;
	
	public class GamePanel extends FeathersControl
	{
		protected var _w:int;
		protected var _h:int;
		
		public function GamePanel(w:int, h:int)
		{
			_w = w;
			_h = h;
			super();
		}
		
		public function get panelWidth():int
		{
			return _w;
		}
		
		public function get panelHeight():int
		{
			return _h;
		}
		
	}
}