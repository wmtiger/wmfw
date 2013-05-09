package com.wm.fw.mgr
{
	public class KeyBoardMgr
	{
		private var _instance:KeyBoardMgr;
		
		public function KeyBoardMgr()
		{
		}

		public function get instance():KeyBoardMgr
		{
			if(_instance == null)
			{
				_instance = new KeyBoardMgr();
			}
			return _instance;
		}

	}
}