package com.fw.view.comps
{
	import flash.events.ErrorEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import feathers.controls.ImageLoader;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * 可以点击的 ImageLoader
	 */	
	
	public class ClickImageLoader extends ImageLoader  
	{
		[Event(name="triggered", type="starling.events.Event")]
		
		private static const MAX_DRAG_DIST:Number = 50;
		public static var grayMat:Vector.<Number> = new Vector.<Number>();
		
		grayMat.push(.33,.33,.33,0,0,
			.33,.33,.33,0,0,
			.33,.33,.33,0,0,
			0,0,0,1,0);
		
//		public const hightlightFilters:Array = [new ColorMatrixFilter(
//			[1,0,0,0,50,   
//				0,1,0,0,50,   
//				0,0,1,0,50,  
//				0,0,0,1,0 
//			])];
		
		private var mUseHandCursor:Boolean;
		private var mEnabled:Boolean;
		private var mIsDown:Boolean;
		private var beginx:Number;
		private var beginy:Number;
		public function ClickImageLoader()
		{
			super();
			
			mEnabled = true;
			mIsDown = false;
			mUseHandCursor = true
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function onTouch(event:TouchEvent):void
		{
			Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
				MouseCursor.BUTTON : MouseCursor.AUTO;
			
			var touch:Touch = event.getTouch(this);
			if (!mEnabled || touch == null) return;
			if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
				scaleSkin();
				beginx = touch.globalX;
				beginy = touch.globalY;
				mIsDown = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				if (touch.globalX < beginx - MAX_DRAG_DIST ||
					touch.globalY < beginy - MAX_DRAG_DIST ||
					touch.globalX > beginx + MAX_DRAG_DIST ||
					touch.globalY > beginy + MAX_DRAG_DIST)
				{
					resetContents();
					scaleContent();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				resetContents();
				scaleContent();
				dispatchEventWith(Event.TRIGGERED, true,{globalX:touch.globalX,globalY:touch.globalY});
			}
		}
		
		protected function scaleContent():void 
		{
			
		}
		protected function scaleSkin():void
		{
			
		}
		private function resetContents():void
		{
			mIsDown = false;
			
		}
		
		/** 按钮是否能够被触碰(即是否禁用)。 */
		public function get enabled():Boolean { return mEnabled; }
		public function set enabled(value:Boolean):void
		{
			if (mEnabled != value)
			{
				mEnabled = value;			
				resetContents();
			}
		}
		/** 当光标移动到按钮上时，是否显示手型光标，默认为：false。
		 *  @default false */
		public override function get useHandCursor():Boolean { return mUseHandCursor; }
		public override function set useHandCursor(value:Boolean):void { mUseHandCursor = value; }
		
		private var _isGray:Boolean;
		public function set isGray(value:Boolean):void {
			_isGray = value;
			if (image != null) {
				if (value) {
					this.image.filter = new ColorMatrixFilter(grayMat);
				} else {
					this.image.filter = null;
				}
			}
		}
		public function get isGray():Boolean {
			return _isGray;
		}
		
		override protected function refreshCurrentTexture():void {
			super.refreshCurrentTexture();
			this.isGray = _isGray;
		}

		public var defSource:Object;
		override protected function loader_errorHandler(event:ErrorEvent):void
		{
			super.loader_errorHandler(event);
			
			if (defSource != null) {
				this.source = defSource;
			}
		}
		
		override protected function rawDataLoader_errorHandler(event:ErrorEvent):void
		{
			super.rawDataLoader_errorHandler(event);
			
			if (defSource != null) {
				this.source = defSource;
			}
		}
	}
}