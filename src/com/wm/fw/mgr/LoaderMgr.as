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
	public class LoaderMgr 
	{
		private static var _instance:LoaderMgr;
		
		public function LoaderMgr() 
		{
			
		}
		
		static public function get instance():LoaderMgr 
		{
			if (_instance == null) 
			{
				_instance = new LoaderMgr();
			}
			return _instance;
		}
		
		/**
		 * 加载数据，同步加载
		 * @param	url
		 */
		public function loadData(url:String):Object
		{
			var fileBytes:ByteArray = new ByteArray();
			var file:File = File.applicationDirectory.resolvePath(url);
			var fs:FileStream = new FileStream();
			fs.close();
			try 
			{
				fs.open(file, FileMode.READ);
				fs.readBytes(fileBytes);
				fs.close();
				fileBytes.position = 0;
				return fileBytes.readObject();
			}
			catch (err:Error)
			{
				return null;
			}
			return null;
		}
		
	}

}