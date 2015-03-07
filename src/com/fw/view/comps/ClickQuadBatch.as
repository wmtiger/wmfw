package com.fw.view.comps
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.QuadBatch;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 此组件用于把quadBatch加入其中后，还能触发其加过的触摸事件
	 * @author WmTiger
	 */
	public class ClickQuadBatch extends QuadBatch implements IClickQuadBatch
	{
		private static var sHelperRect:Rectangle = new Rectangle();
		private static var subHelperRect:Rectangle = new Rectangle();
		private static var MAX_DRAG_DIST:int = 50;
		
		private var mChildren:Vector.<DisplayObject>;
		private var _btnState:Boolean = false;// 是否是按钮状态，点下后会缩放一下

		private var tagProp:Array;
        
		public function ClickQuadBatch()
		{
			mChildren = new <DisplayObject>[];
			super();
			addEventListener(TouchEvent.TOUCH,onClickHandler);
		}
		
		private function onClickHandler(event:TouchEvent):void
		{
			var tag:DisplayObject = event.currentTarget as DisplayObject;
			
			var touch:Touch = event.getTouch(tag);
			if (touch == null) return;	
			if (touch.phase == TouchPhase.BEGAN)
			{
				tagProp = [tag.x,tag.y,tag.width,tag.height,tag.scaleX,tag.scaleY,touch.globalX,touch.globalY];
				if(_btnState)
				{
					//const scale:Number = tag.scaleX * 0.9;
					tag.scaleX = tag.scaleX * 0.9; 
					tag.scaleY = tag.scaleY * 0.9;
					if(tag.pivotX == 0)
					{
						tag.x += 0.05 * tag.width;
						tag.y += 0.05 * tag.height;
					}
				}
			}
			else if (touch.phase == TouchPhase.MOVED && tagProp)
			{
				if(_btnState)
				{
					var butarr:Array = tagProp;
					if (touch.globalX < butarr[6] - MAX_DRAG_DIST ||
						touch.globalY < butarr[7] - MAX_DRAG_DIST ||
						touch.globalX > butarr[6] + MAX_DRAG_DIST ||
						touch.globalY > butarr[7]  + MAX_DRAG_DIST)
					{
						resetTag(tag);
					}
				}
			}
			else if (touch.phase == TouchPhase.ENDED && tagProp)
			{
				if(_btnState)
				{
					resetTag(tag);
				}
				tag.dispatchEventWith(Event.TRIGGERED, true);
			}
			
		}
		
		private function resetTag(tag:DisplayObject):void
		{
			if(tag)
			{
				if(tagProp && tagProp.length > 0)
				{
					tag.x = tagProp[0];
					tag.y = tagProp[1];
					tag.scaleX = tagProp[4];
					tag.scaleY = tagProp[5];
				}
			}
		}
		
		public function set btnState(v:Boolean):void
		{
			_btnState = v;
		}
		
		override public function addQuadBatch(quadBatch:QuadBatch, parentAlpha:Number = 1.0, modelViewMatrix:Matrix = null, blendMode:String = null):void
		{
			pushObjToChildren(quadBatch);
			super.addQuadBatch(quadBatch, parentAlpha, modelViewMatrix, blendMode);
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
        {
            // on a touch test, invisible or untouchable objects cause the test to fail
            if (forTouch && (!visible || !touchable)) return null;
            
            // otherwise, check bounding box
            if (getBounds(this, sHelperRect).containsPoint(localPoint))
			{
				var len:int = mChildren.length;
				for (var i:int = 0; i < len; i++) 
				{
					subHelperRect.x = mChildren[i].x;
					subHelperRect.y = mChildren[i].y;
					subHelperRect.width = mChildren[i]['texture'].width;
					subHelperRect.height = mChildren[i]['texture'].height;
					//trace(subHelperRect,localPoint,subHelperRect.containsPoint(localPoint));
					if(subHelperRect.containsPoint(localPoint))
						return mChildren[i];
				}
				return this;
			}
			return null;
        }
		
		protected function pushObjToChildren(qb:QuadBatch):void
		{
			if(mChildren.indexOf(qb) < 0)
			{
				mChildren.push(qb);
			}
		}
		
		public function get numChildren():int
		{
			if (mChildren == null)
			{
				return 0;
			}
			return mChildren.length;
		}
		
		protected function clearBatch():void
		{
			reset();
		}
		
		public function reflush():void
		{
			clearBatch();
			var len:int = numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				if (mChildren[i] is QuadBatch) 
				{
					addQuadBatch(mChildren[i] as QuadBatch);
				}
			}
		}
		
		override public function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH,onClickHandler);
			mChildren = null;
			super.dispose();
		}
	
	}

}