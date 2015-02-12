package com.fw.view.comps
{
	import feathers.controls.Button;
	
	/**
	 * 自定义按钮
	 * @author weism
	 */
	public class CustomBtn extends Button
	{
		public var scaleForDownSkin:Boolean = true;
		
		public function CustomBtn()
		{
			super();
		}
		
		override protected function scaleSkin():void
		{
			if (!scaleForDownSkin)
			{
				super.scaleSkin();
				return;
			}
			if (!this.currentSkin)
			{
				return;
			}
			if (this.currentSkin.scaleX < 0)
				var sc:int = -1;
			else
				sc = 1;
			if (this._currentState == STATE_DOWN)
			{
				
				this.currentSkin.width = this.actualWidth * 1.1;
				this.currentSkin.scaleX *= sc;
				this.currentSkin.height = this.actualHeight * 1.1;
				this.currentSkin.x = this.actualWidth * -0.05;
				this.currentSkin.y = this.actualHeight * -0.05;
			}
			else
			{
				this.currentSkin.x = 0;
				this.currentSkin.y = 0;
				if (this.currentSkin.width != this.actualWidth)
				{
					this.currentSkin.width = this.actualWidth;
					this.currentSkin.scaleX *= sc;
				}
				if (this.currentSkin.height != this.actualHeight)
				{
					this.currentSkin.height = this.actualHeight;
				}
			}
		}
	
	}

}