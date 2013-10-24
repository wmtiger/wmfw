package com.wm.fw.rpg.audio 
{
	/**
	 * ...
	 * @author wmTiger
	 */
	public class AudioFile 
	{
		/**
		 * 音频文件名称。
		 */
		private var _name:String = '';
		/**
		 * 音量（0～100）。背景音乐和音乐的默认值是 100 、背景音效和音效的默认值是 80。
		 */
		private var _volume:int = 100;
		/**
		 * 音调（50～150）。默认值是 100。
		 */
		private var _pitch:int = 100;
		
		public function AudioFile() 
		{
			
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get volume():int 
		{
			return _volume;
		}
		
		public function set volume(value:int):void 
		{
			_volume = value;
		}
		
		public function get pitch():int 
		{
			return _pitch;
		}
		
		public function set pitch(value:int):void 
		{
			_pitch = value;
		}
		
		public function clone():AudioFile
		{
			return new AudioFile();
		}
		
	}

}