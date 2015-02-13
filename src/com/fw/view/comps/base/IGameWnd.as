package com.fw.view.comps.base
{
	import flash.geom.Point;
	
	import feathers.core.IFeathersControl;
	
	import starling.display.DisplayObjectContainer;

	public interface IGameWnd extends IFeathersControl
	{
		
		/*窗口的标题*/		
		function set title(value:String):void;
		function get title():String;
		
		/**
		 * 显示 
		 * @param position
		 * @param parent
		 */		
		function show(position:Point=null,parent:DisplayObjectContainer=null, modal:Boolean = true, candispose:Boolean = true):void;
		
		/**
		 * 关闭
		 */
		function close():void;
		
		/**
		 * 是否可以回收
		 * @return 
		 */
		function get canDispose():Boolean;
		
		function get needFadeIn():Boolean;
		
		function set needFadeIn(value:Boolean):void;
		
		function get needFadeOut():Boolean;
		
		function set needFadeOut(value:Boolean):void;
		
	}
}