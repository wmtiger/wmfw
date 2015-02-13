package com.fw.view.comps 
{
	import com.fw.view.comps.ClickImageLoader;

	/**
	 * @author wmtiger
	 */
	public class CustomClickImageLdr extends ClickImageLoader 
	{
		private var _localWidth:Number;
		private var _localHeight:Number;
		private var _localX:Number;
		private var _localY:Number;
		
		public function CustomClickImageLdr() 
		{
			super();
			
		}
		
		override protected function scaleContent():void 
		{
			this.width = _localWidth;
			this.height = _localHeight;
			this.x = _localX;
			this.y = _localY;
		}
		
		override protected function scaleSkin():void
		{
			_localWidth = this.width;
			_localHeight = this.height;
			_localX = this.x;
			_localY = this.y;
			this.width = this.actualWidth * 1.1;
			this.height = this.actualHeight * 1.1;
			this.x = _localX + this.actualWidth * -0.05;
			this.y = _localY + this.actualHeight * -0.05;
		}
		
	}

}