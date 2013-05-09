package com.wm.fw.mgr
{
	public class WmSwfMgr
	{
		private static var _instance:WmSwfMgr;
		
		public function WmSwfMgr()
		{
		}

		public static function get instance():WmSwfMgr
		{
			if(_instance == null)
			{
				_instance = new WmSwfMgr();
			}
			return _instance;
		}

	}
}