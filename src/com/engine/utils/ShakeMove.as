package com.engine.utils
{
	import starling.animation.IAnimatable;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class ShakeMove extends EventDispatcher implements IAnimatable
	{
		private var _x:Number;
		private var _y:Number;
		private var _isComplete:Boolean;
		private var _toX:Number;
		private var _toY:Number;
		private var shock_TimeSpan:Number;
		private var _shock_RepeatTime:Number;
		private var _shock:int;
		private var _delay:Number=0;
		private var _recallfun:Function;
		/**
		 *震动 
		 * @param shock_RepeatTime
		 * 
		 */		
		public function ShakeMove()
		{
//			_shock_RepeatTime = shock_RepeatTime
		}
		/**
		 * 延迟时间
		 */
		public function get delay():Number
		{
			return _delay;
		}
		
		/**
		 * @private
		 */
		public function set delay(value:Number):void
		{
			_delay = value;
		}
		/**
		 * 
		 * @param fromX 初始x
		 * @param fromY 初始y
		 * @param shock_RepeatTime 震动时间 毫秒
		 * @param shock 震动幅度
		 * 
		 */		
		public function go(fromX:int, fromY:int, shock_RepeatTime:int=200, shock:int=10,recallfun:Function=null):void
		{
			_recallfun = recallfun;
			_isComplete = false;
			_x = fromX;
			_y = fromY;
			_shock_RepeatTime = shock_RepeatTime/1000;
			_shock = shock;
			_toX = 0;
			_toY = 0;
			shock_TimeSpan = 0;
		}
		public function onComplete():void
		{
			_isComplete = true;
			_toX = 0;
			_toY = 0;
			if(_recallfun!=null)
				_recallfun(this);
			_recallfun = null;
			dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
		}
		public function get toY():int
		{
			return _toY;
		}
		
		public function get toX():int
		{
			return _toX;
		}
		
		public function get fromY():int
		{
			return _y;
		}
		
		public function get fromX():int
		{
			return _x;
		}

		public function get x():Number
		{
			return _x+_toX;
		}
		
		public function get y():Number
		{
			return _y+_toY;
		}
		public  function get rotation():Number
		{
			return 0;	
		}
		public function get isComplete():Boolean
		{
			return _isComplete;
		}
				
		public function advanceTime(time:Number):void
		{
			if(!_isComplete)
			{
				if(_delay>0)
				{
					_delay-=time;
					return ;
				}
				shock_TimeSpan += time;
				if(shock_TimeSpan<_shock_RepeatTime)
				{
					if(_shock-->0)
					{
						var dy:int = 3;
						if(_shock>10)
						{
							dy = _shock/2;
						}
						if(_shock==0)
						{
							_toY = 0;
							_toX = 0;
						}else if(_shock%4==0)
						{
							_toY = -dy;
						}else if(_shock%4==2)
						{
							_toY = dy;
						}else if(_shock%4==1)
						{
							_toX = -dy;
						}else if(_shock%4==3)
						{
							_toX = dy;
						}
					}
					if(_recallfun)
						_recallfun(this);
				}else
				{			
					onComplete();
				}
			}
		}
//		private function void_un():Number
//		{
//			//返回整数类型的0到10的随机数减去10处于2的值所得的值，这个值就是震动的范围值了
//			return (Math.floor(Math.random() * _shock)) - (_shock*.5)
//		}
	}
}