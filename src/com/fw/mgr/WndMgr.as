package com.fw.mgr
{
	import com.fw.view.comps.base.IGameWnd;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;

	public class WndMgr
	{
		private static var _defaultWinParent:DisplayObjectContainer;
		private static var _intstance:WndMgr;
		
		private var _dict:Dictionary;
		
		public function WndMgr()
		{
			_dict = new Dictionary();
		}

		public static function get defaultWinParent():DisplayObjectContainer
		{
			return _defaultWinParent;
		}

		public static function set defaultWinParent(value:DisplayObjectContainer):void
		{
			_defaultWinParent = value;
		}

		public static function get intstance():WndMgr
		{
			if(_intstance == null)
				_intstance = new WndMgr();
			return _intstance;
		}
		
		private function hasWnd(key:String):Boolean
		{
			return (_dict[key] != null);
		}
		
		private function addWnd(key:String, wnd:IGameWnd):void
		{
			if (!hasWnd(key)) 
			{
				_dict[key] = wnd;
			}
		}
		
		private function getWnd(clsName:String):IGameWnd
		{
			var w:IGameWnd;
			for (var i:String in _dict) 
			{
				if (i.indexOf(clsName) >= 0) 
				{
					w = _dict[i];
					break;
				}
			}
			return w;
		}
		
		private function removeWnd(key:String):void
		{
			delete _dict[key];
		}
		
		/**
		 * 关闭窗口
		 */
		public function closeWindow(windowKey:*):void
		{
			var key:String = "" + windowKey;
//			trace("closeWindow", key);
			var w:IGameWnd = getWnd(key);
			if(w)
			{
				w.closeWnd();
				removeWnd(key);
			}
		}
		
		/**
		 * 关闭所有窗口
		 */
		public function closeAllWindows(exceptWindowCls:* = null):void {
			var key:String = ""+exceptWindowCls;
//			var key:String = "[class "+exceptWindowCls+"]";
			var w:IGameWnd;
			for (var i:String in _dict) 
			{
				if (i.indexOf(key) < 0) 
				{
					closeWindow(i);
				}
			}
		}
		
		/**
		 * 显示窗口
		 * @param window
		 */
		public function showWindow(cls:Class, position:Point = null, parent:DisplayObjectContainer = null, modal:Boolean = true,
									candispose:Boolean = true, fullScreen:Boolean = false, windowType:int = -1,
									isSingleton:Boolean = false, showMovie:Object = null):IGameWnd
		{
			var wnd:IGameWnd;
			var key:String = "" + cls;
//			trace("showWindow",key);
			if (!hasWnd(key)) 
			{
				wnd = new cls();
				addWnd(key,wnd);
			}
			else
			{
				wnd = getWnd(key);
			}
			wnd.show(position,parent,modal,candispose);
			return wnd;
		}
		
		/**
		 * 检察某类型的窗口是否是显示状态
		 * @param wndCls
		 * @return
		 */
		public function isWndShow(wndCls:Class):IGameWnd
		{
			var key:String = "" + wndCls;
			var wnd:IGameWnd;
			if (!hasWnd(key)) 
				wnd = getWnd(key);
			if(wnd && wnd.visible)
				return wnd;
			return null;
		}
		
		public function removeCacheWindow():void
		{
			// to do
		}
		
		public function isAllWndClose():Boolean
		{
			// to do
			return false;
		}
		
		public function isWndExist(wndCls:Class):Boolean
		{
			var key:String = "" + wndCls;
			return hasWnd(key);
		}
	}
}