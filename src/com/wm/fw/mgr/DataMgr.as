package com.wm.fw.mgr 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
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
		
		private function makeFileName(idx:int):String
		{
			return 'save/' + idx + '.save';
		}
		
		public function saveFile(idx:int, obj:Object):void
		{
			var fileBytes:ByteArray = new ByteArray();
			fileBytes.writeObject(obj);
			var file:File = File.applicationStorageDirectory.resolvePath(makeFileName(idx));
			var fs:FileStream = new FileStream();
			fs.close();
			try 
			{
				fs.open(file, FileMode.UPDATE);
				fs.writeBytes(fileBytes);
				fs.close();
			}
			catch (err:Error)
			{
				fs.close();
			}
		}
		
		public function get saveFileMax():int
		{
			return 9;
		}
		
	}

}