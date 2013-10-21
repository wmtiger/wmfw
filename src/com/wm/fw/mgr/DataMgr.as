package com.wm.fw.mgr 
{
	/**
	 * ...
	 * @author wmtiger
	 */
	public class DataMgr 
	{
		private static var _instance:DataMgr;
		
		private var _lastSaveFileIndex:int = -1;
		
		private var _actors:Object;
		
		public function DataMgr() 
		{
			
		}
		
		static public function get instance():DataMgr 
		{
			if (_instance == null) 
			{
				_instance = new DataMgr();
			}
			return _instance;
		}
		
		public function init():void 
		{
			_lastSaveFileIndex = -1;
			loadNormalDatabase();
			createGameObject();
		}
		
		public function startNewGame():void
		{
			
		}
		
		private function loadNormalDatabase():void
		{
			_actors = LoaderMgr.instance.loadData('database/actors.data');
		}
		
		private function createGameObject():void 
		{
			
		}
		
		private function isSaveFileExist(idx:int):Boolean
		{
			
		}
		
	}

}