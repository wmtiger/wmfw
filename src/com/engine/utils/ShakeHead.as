package com.engine.utils {
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 *	[摇头晃脑]
	 *  会让一个显示对象兴奋的摇起头来
	 * @author huangkan
	 * 
	 */
	public class ShakeHead implements IAnimatable{
		
		protected static const heads:Vector.<DisplayObject> = new <DisplayObject>[];

		/** 	让显示对象摇一下头		 */
		public static function go(dpo:DisplayObject, cbfun:Function = null, cbParams:Array = null):void{
			if(heads.indexOf(dpo)==-1){
				heads.push(dpo);
				Starling.current.juggler.add(new ShakeHead(dpo, cbfun, cbParams));
			}
		}
		
		protected var callbackFun:Function;
		protected var callbackParams:Array;
		protected var displayObject:DisplayObject;
		protected var startX:Number;
		protected var waste:Number;
		public function ShakeHead(dpo:DisplayObject, cbfun:Function = null, cbParams:Array = null){
			callbackFun = cbfun;
			callbackParams = cbParams;
			displayObject = dpo;
			startX = dpo.x;
			waste = 0;
		}
		
		public function advanceTime(time:Number):void{
			waste += time;
			if(waste>.3){
				heads.splice(heads.indexOf(displayObject),1);
				Starling.current.juggler.remove(this);
				if(callbackFun != null)
				{
					callbackFun.apply(null, callbackParams);
				}
				
				displayObject.x = startX;
			} else {
				displayObject.x = Math.sin(waste * 50) * 10 + startX;
			}
		}
		
	}
}