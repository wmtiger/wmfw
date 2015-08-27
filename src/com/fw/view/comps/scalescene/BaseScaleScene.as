package com.fw.view.comps.scalescene
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.utils.math.clamp;
	
	import starling.animation.IAnimatable;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class BaseScaleScene extends Sprite implements IAnimatable
	{
		private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
		private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;
		private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[2, 1.66, 1.33, 1];
		private static const MINIMUM_VELOCITY:Number = 0.02;
		private static const FRICTION:Number = 0.998;
		private static const HELPER_POINT:Point = new Point();
		
		private var _currentTouchX:Number;		
		private var _currentTouchY:Number;	
		private var _previousTouchX:Number;
		private var _previousTouchY:Number;
		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;		
		private var _previousVelocityX:Vector.<Number> = new <Number>[];
		private var _previousVelocityY:Vector.<Number> = new <Number>[];	
		private var _startTouchX:Number;
		private var _startTouchY:Number;
		private var _beginTouch:Boolean;
		private var mIsDown:Boolean;
		private var targetTween:Tween;
		
		protected var ismoveitem:Boolean;
		protected var maxscale:Number = 1.5;
		protected var _maxwidth:int=2800;//游戏最大显示宽
		protected var _maxheight:int=2871;//游戏最大显示高
		protected var isaddjuggler:Boolean;
		
		protected var _viewRect:Rectangle = new Rectangle();
		
		public var minscale:Number;
		
		public function BaseScaleScene()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,addstage);
		}
		
		protected function setViewRect():void
		{
			_viewRect.x = 0;
			_viewRect.y = 0;
			_viewRect.width = stage.stageWidth;
			_viewRect.height = stage.stageHeight;
		}
		
		public function get maxheight():int
		{
			return _maxheight;
		}

		public function get maxwidth():int
		{
			return _maxwidth;
		}

		protected function set beginTouch(value:Boolean):void
		{
			_beginTouch = value;
			
			if(!isaddjuggler)
			{
				if(value)
					Starling.juggler.add(this);
				else
					Starling.juggler.remove(this);
			}
		}
		
		public function get viewWidth():Number
		{
			return _viewRect.width;
		}
		public function get viewHeight():Number
		{
			return _viewRect.height;
		}

		private function addstage():void
		{
			setViewRect();
			removeEventListener(Event.ADDED_TO_STAGE,addstage);
			minscale = Math.max(viewWidth/maxwidth,viewHeight/maxheight);
			setScenePosition();
			addEventListener(TouchEvent.TOUCH, onTouch);
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler, false, 0, true);
		}
		
		protected function setScenePosition():void
		{
			this.showAtCenter();
		}
		private function onTouch(event:TouchEvent):void
		{
			
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			var pt:Point //当前的像素坐标
			if(touch)
			{
				moveComplete(false);
				mIsDown = true;
				_startTouchX = x;
				_startTouchY = y;
				pt = touch.getLocation(this);
				startTouch(pt);
				if(!ismoveitem)
				{
					this._velocityX = 0;
					this._velocityY = 0;
					this._previousVelocityX.length = 0;
					this._previousVelocityY.length = 0;
					
					this._previousTouchX  = this._currentTouchX =x;
					this._previousTouchY = this._currentTouchY = y;
					beginTouch = true;
				}
				stopTween();
			}
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			if(touches.length>0)
			{						
				if(Math.abs(_startTouchX-x)>2||Math.abs(_startTouchY-y)>2)
					mIsDown = false;	
			}
			if (touches.length == 1)//单指拖动
			{
				// one finger touching -> move
				if(ismoveitem)//拖动建筑
				{	
					pt = touches[0].getLocation(this);
					onefingermove(pt)			
				}
				else//拖动地图
				{
					var delta:Point = touches[0].getMovement(parent);
					x += delta.x;
					y += delta.y;
					checkXY(false);
					this._currentTouchX =x;
					this._currentTouchY = y;
				}
			}            
			else if (touches.length == 2)//双指缩放
			{
				if(_beginTouch)
				   beginTouch = false;
				// two fingers touching -> scale
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = touchA.getLocation(parent);
				var previousPosA:Point = touchA.getPreviousLocation(parent);
				var currentPosB:Point  = touchB.getLocation(parent);
				var previousPosB:Point = touchB.getPreviousLocation(parent);
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				var previousLocalA:Point  = touchA.getPreviousLocation(this);
				var previousLocalB:Point  = touchB.getPreviousLocation(this);
				var sizeDiff:Number = currentVector.length / previousVector.length;
				var scale:Number =scaleX* sizeDiff
				
				if(scale>maxscale||scale<minscale)//设置最多缩放比例
					return;
				scaleX = scale;
				scaleY = scale;
				
				x = (currentPosA.x + currentPosB.x)*.5- (previousLocalA.x + previousLocalB.x) *scale*.5;
				y = (currentPosA.y + currentPosB.y)*.5- (previousLocalA.y + previousLocalB.y) *scale*.5;
				
				checkXY(false);
			}
			
			touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				
				if(mIsDown)//单机事件
				{
					pt = touch.getLocation(this)
					click(pt);
				}
				if(_beginTouch)
				{		
					beginTouch = false;
					var sum:Number = this._velocityX * CURRENT_VELOCITY_WEIGHT;
					var velocityCount:int = this._previousVelocityX.length;
					var totalWeight:Number = CURRENT_VELOCITY_WEIGHT;
					for(var i:int = 0; i < velocityCount; i++)
					{
						var weight:Number = VELOCITY_WEIGHTS[i];
						sum += this._previousVelocityX.shift() * weight;
						totalWeight += weight;
					}
					var durationX:Number = 0;
					var durationY:Number = 0;
					var targetX:Number;
					var targetY:Number;
					
					var pixelsPerMS:Number = sum / totalWeight
					var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
					if(absPixelsPerMS <= MINIMUM_VELOCITY)
					{				
						durationX = 0;
						targetX = x;
					}else
					{
						targetX = x - (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
						var min:Number = viewWidth-maxwidth*scaleX
						if(targetX > _viewRect.x || targetX<min)
						{
							durationX = 0;
							targetX = x;
							while(Math.abs(pixelsPerMS) > MINIMUM_VELOCITY)
							{
								targetX += pixelsPerMS;
								if(targetX > _viewRect.x || targetX<min)
								{
									targetX = clamp(targetX, min,_viewRect.x);
									durationX++;
									break;
								}
								else
								{
									pixelsPerMS *= FRICTION;
								}
								durationX++;
							}
						}
						else
						{
							durationX = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
						}
					}					
					sum = this._velocityY * CURRENT_VELOCITY_WEIGHT;
					velocityCount = this._previousVelocityY.length;
					totalWeight = CURRENT_VELOCITY_WEIGHT;
					for(i = 0; i < velocityCount; i++)
					{
						weight = VELOCITY_WEIGHTS[i];
						sum += this._previousVelocityY.shift() * weight;
						totalWeight += weight;
					}
					pixelsPerMS = sum / totalWeight
					absPixelsPerMS = Math.abs(pixelsPerMS);
					
					if(absPixelsPerMS <= MINIMUM_VELOCITY)
					{				
						durationY = 0;
						targetY = y;
					}else
					{
						targetY = y - (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
						min = viewHeight-maxheight*scaleY
						if(targetY > _viewRect.y || targetY<min)
						{
							durationY = 0;
							targetY = y;
							while(Math.abs(pixelsPerMS) > MINIMUM_VELOCITY)
							{
								targetY += pixelsPerMS;
								if(targetY > _viewRect.y || targetY<min)
								{
									targetY = clamp(targetY, min, _viewRect.y);
									durationY++;
									break;
								}
								else
								{
									pixelsPerMS *= FRICTION;
								}
								durationY++;
							}
						}
						else
						{
							durationY = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
						}
					}					
					var duration:Number = Math.max(durationY,durationX);		
					stopTween();
					if(duration>0)
					{
						this.targetTween = new Tween(this, duration / 1000,Transitions.EASE_OUT);
						this.targetTween.animate("x", targetX);
						this.targetTween.animate("y", targetY);
						this.targetTween.onComplete = targetTween_onComplete;
						this.targetTween.onUpdate = targetTween_onUpdate;
						Starling.juggler.add(this.targetTween);
					}else
						moveComplete();
					
					
				}else
					moveComplete();
				mIsDown = false;
				
			}
			
		}
		protected function nativeStage_mouseWheelHandler(event:MouseEvent):void
		{	
			const starlingViewPort:Rectangle = Starling.current.viewPort;
			HELPER_POINT.x = (event.stageX - starlingViewPort.x) / Starling.contentScaleFactor;
			HELPER_POINT.y = (event.stageY - starlingViewPort.y) / Starling.contentScaleFactor;
			if(this.stage&&this.contains(this.stage.hitTest(HELPER_POINT, true)))
			{
				var currentPos:Point = parent.localToGlobal(HELPER_POINT);
				this.globalToLocal(HELPER_POINT, HELPER_POINT);
				var localMouseX:Number = HELPER_POINT.x;
				var localMouseY:Number = HELPER_POINT.y;
				var scale:Number =scaleX+event.delta*0.01
				
				if(scale>maxscale)//设置最多缩放比例
					scale = maxscale
				else if(scale<minscale)
					scale = minscale				
				stopTween();
				moveComplete(false)				
				scaleX = scale;
				scaleY = scale;
				x = currentPos.x- localMouseX*scale;
				y = currentPos.y- localMouseY *scale;		
				checkXY();	
			}
		}
        override public function set scale(value:Number):void
		{
			if(scaleX==value)
				return;
			if(value>=minscale&&value<=maxscale)
			{
				var ds:Number = scaleX-value;
				scaleX = value;
				scaleY = value;
				x += maxwidth*ds*.5;
				y += maxheight *ds*.5;				
				checkXY();	
			}
		}
		
		public function advanceTime(time:Number):void
		{
			if(_beginTouch)
			{
				this._previousVelocityX.unshift(this._velocityX);
				if(this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityX.pop();
				}
				this._previousVelocityY.unshift(this._velocityY);
				if(this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityY.pop();
				}
				time*=1000 
				this._velocityX = (this._currentTouchX - this._previousTouchX) / time;
				this._velocityY = (this._currentTouchY - this._previousTouchY) / time;
				this._previousTouchX = this._currentTouchX;
				this._previousTouchY = this._currentTouchY;
			}
		}
		/**
		 *更改窗口大小 
		 * 
		 */		
		public function resize():void
		{		
			minscale = Math.max(viewWidth/maxwidth,viewHeight/maxheight);
			if(scaleX<minscale)
			{
				scaleX = minscale;
				scaleY = minscale;
			}
			checkXY()
		}
		/**
		 *居中显示 
		 * 
		 */		
		public function showAtCenter():void
		{
			x = (viewWidth-maxwidth*scaleX)*.5;					
			y = (viewHeight-maxheight*scaleY)*.5;
			checkXY();
		}
		/**
		 * 按位置显示
		 */
		public function showAtPoint(mx:Number, my:Number):void
		{
			x = mx;
			y = my;
			checkXY();
		}
		/**
		 *开始触屏 
		 * @param p
		 * 
		 */		
		protected function startTouch(p:Point):void
		{
//			ismoveitem = false;
//				title = CityUtil.getTilePoint(pt.x,pt.y);
//				ismovebuilding =_MoveBuilder!=null&&checkbuildselect(title)==_MoveBuilder&&_MoveBuilder.data.MoveEnable
		}
		/**
		 *单指移动 
		 * 
		 */		
		protected function onefingermove(p:Point):void
		{
			//showbuildAtPixelPoint(_MoveBuilder,pt.x,pt.y-(_MoveBuilder.data.needGridNum-1)*CityUtil.tileHeight*.5)
		}
		/**
		 *点击事件 
		 * @param p
		 * 
		 */		
		protected function click(p:Point):void
		{
//			title = CityUtil.getTilePoint(pt.x,pt.y);
//			if(isclick)
//			{
//				isclick = false
//			}
//			else 
//			{
//				var bu:Builder = checkbuildselect(title);
//				if(cityType==1)
//				{							
//					if(!ismovebuilding)
//					{
//						
//						if(bu==null)
//							stopMoveBuilder()
//						else 
//							startMoveBuilder(bu);
//					}
//					//						trace(CityUtil.getTilePoint(pttt.x,pttt.y));
//				}
//				if(bu&&bu.data.clickEnable)
//				{
//					dispatchEvent(new CityEvent(CityEvent.BUILDER_CLICK, false,bu.data));
//				}
//			}
//			
//			
//			dispatchEventWith(Event.TRIGGERED,false,title)
		}
		protected function checkXY(checkComplete:Boolean = true):void
		{
			var gamewidth:Number = viewWidth;
			var gameheight:Number = viewHeight;
			if(maxwidth*scaleX<gamewidth)
				x = (gamewidth-maxwidth*scaleX)*.5
			else if(x>0)
				x = 0;
			else if(x<gamewidth-maxwidth*scaleX)
				x = gamewidth-maxwidth*scaleX;
			
			if(maxheight*scaleX<gameheight)
				y = (gameheight-maxheight*scaleX)*.5
			else if(y>0)
				y = 0;
			else if(y<gameheight-maxheight*scaleX)
				y =  gameheight-maxheight*scaleX;
			if(checkComplete)
				moveComplete();
					
		}
		protected function targetTween_onComplete():void
		{
			targetTween = null;
			moveComplete();
		}
		protected function targetTween_onUpdate():void
		{
			checkXY(false);
		}
		/**
		 *地图开始移动 
		 * @param value true 结束  false 开始  
		 * 
		 */		
		protected function moveComplete(value:Boolean = true):void
		{
			
		}
//		public function get scale():Number
//		{
//			return _scale;
//		}
//		
//		public function set scale(value:Number):void
//		{
//			_scale = value;
//			if(scale>maxscale)//设置最多缩放比例
//				scale = maxscale
//			if(scale<minscale)
//				scale = minscale
//			scaleX = scale;
//			scaleY = scale;
//			checkXY();
//		}
		
		override public function dispose():void {
			Starling.juggler.remove(this);
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
			stopTween();
			_previousVelocityX = null;
			_previousVelocityY = null;
			super.dispose();
		}
		
		private function stopTween():void
		{
			// TODO Auto Generated method stub
			if(this.targetTween)
			{
				Starling.juggler.remove(this.targetTween);
				this.targetTween = null;
			}
		}
		
	}
}