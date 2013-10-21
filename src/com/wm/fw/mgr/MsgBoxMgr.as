package com.wm.fw.mgr
{
	public class MsgBoxMgr
	{
		private static var _instance:MsgBoxMgr;
		
		public function MsgBoxMgr()
		{
		}
		
		static public function get instance():MsgBoxMgr 
		{
			if (_instance == null) 
			{
				_instance = new MsgBoxMgr();
			}
			return _instance;
		}
		
		public function msgBox(str:String):void
		{
			trace('MSG:' + str);
		}
		
	}
}