package com.wm.fw.mgr 
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author wmtiger
	 */
	public class CacheMgr 
	{
		private static var _instance:CacheMgr;
		
		private var _dictBitmapDataBitmapData:Dictionary;
		
		public function CacheMgr() 
		{
			_dictBitmapData = new Dictionary();
		}
		
		static public function get instance():CacheMgr 
		{
			if (_instance == null) 
			{
				_instance = new CacheMgr();
			}
			return _instance;
		}
		
		public function contains(key:String):Boolean
		{
			return _dictBitmapData[key] != null;
		}
		
		/**
		 * 缓存位图
		 * @param	key
		 * @param	bmd
		 * @param	change	如果key已经有了，true代表替换，false代表不替换
		 */
		public function cacheBitmapData(key:String, bmd:BitmapData, change:Boolean = false):void
		{
			if (change) 
			{
				_dictBitmapData[key] = bmd;
			}
			else
			{
				if (!contains(key)) 
				{
					_dictBitmapData[key] = bmd;
				}
			}
		}
		
		public function getBitmapData(key:String):BitmapData
		{
			return _dictBitmapData[key];
		}
		
		public function clear(key:String):void
		{
			
		}
		
		public function clearAll():void
		{
			
		}
		
	}

}