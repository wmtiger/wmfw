package com.wm.fw.mgr 
{
	/**
	 * ...
	 * @author wmtiger
	 */
	public class SoundMgr 
	{
		private static var _instance:SoundMgr;
		
		public function SoundMgr() 
		{
			
		}
		
		static public function get instance():SoundMgr 
		{
			if (_instance == null) 
			{
				_instance = new SoundMgr();
			}
			return _instance;
		}
		
		private function playSystemSound(idx:int):void
		{
			//to do : 这里要完成播放音效接口
		}
		
		/**
		 * 播放光标音效
		 */
		public function playCursor():void
		{
			playSystemSound(0);
		}
		
		/**
		 * 播放确定音效
		 */
		public function playOk():void
		{
			playSystemSound(1);
		}
		
		/**
		 * 播放取消音效
		 */
		public function playCancel():void
		{
			playSystemSound(2);
		}
		
	}

}