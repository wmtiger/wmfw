package com.wm.fw.rpg.utils 
{
	/**
	 * ...
	 * @author wmTiger
	 */
	public class AudioUtil 
	{
		
		public function AudioUtil() 
		{
			
		}
		
		/**
		 * 开始播放背景音乐（BGM）。可以在参数中指定文件名、音量、频率和起始时间。
		 * 但是只有mp3格式的音频文件支持设定起始时间功能。
		 * @param	filename
		 * @param	volume
		 * @param	pitch
		 * @param	pos
		 */
		public static function playBgm(filename:String = '', volume:int = 0, pitch:int = 0, pos:int = 0):void
		{
			
		}
		
		/**
		 * 停止播放背景音乐（BGM）。
		 */
		public static function stopBgm():void
		{
			
		}
		
		/**
		 * 开始淡出背景音乐（BGM）。time 是以毫秒计算的淡出时间。
		 * @param	time
		 */
		public static function fadeBgm(time:int = 0):void
		{
			
		}
		
		/**
		 * 获取当前播放的背景音乐（BGM）在文件中的进行到的时间位置（仅支持mp3格式的音频文件）。
		 * 如果参数无效，则返回0。
		 * @return
		 */
		public static function getCrtBgmPos():int
		{
			return 0;
		}
		
		/**
		 * 开始播放背景音效（BGS）。可以在参数中指定文件名、音量、频率和起始时间。
		 * 但是只有mp3格式的音频文件支持设定起始时间功能。
		 * @param	filename
		 * @param	volume
		 * @param	pitch
		 * @param	pos
		 */
		public static function playBgs(filename:String = '', volume:int = 0, pitch:int = 0, pos:int = 0):void
		{
			
		}
		
		/**
		 * 停止播放背景音效（BGS）。
		 */
		public static function stopBgs():void
		{
			
		}
		
		/**
		 * 开始淡出背景音效（BGS）。time 是以毫秒计算的淡出时间。
		 */
		public static function fadeBgs(time:int):void
		{
			
		}
		
		/**
		 * 获取当前播放的背景音乐（BGS）在文件中的进行到的时间位置（仅支持mp3格式的音频文件）。
		 * 如果参数无效，则返回0。
		 * @return
		 */
		public static function getCrtBgsPos():int
		{
			return 0;
		}
		
		/**
		 * 开始播放事件音乐（ME），依次设置文件名、音量和音调。
		 * 播放事件音乐时，会将背景音乐暂停。
		 * @param	filename
		 * @param	volume
		 * @param	pitch
		 */
		public static function playMe(filename:String = '', volume:int = 0, pitch:int = 0):void
		{
			
		}
		
		/**
		 * 停止播放事件音乐（ME）。
		 */
		public static function stopMe():void
		{
			
		}
		
		/**
		 * 开始淡出事件音乐（ME）。time 是以毫秒计算的淡出时间。
		 */
		public static function fadeMe(time:int):void
		{
			
		}
		
		/**
		 * 开始播放事件音效（SE），依次设置文件名、音量和音调。
		 * 若是在极短时间内重复播放同一个事件音效，会进行过渡处理，以防出现声音撕裂现象。
		 * @param	filename
		 * @param	volume
		 * @param	pitch
		 */
		public static function playSe(filename:String = '', volume:int = 0, pitch:int = 0):void
		{
			
		}
		
		/**
		 * 停止播放事件音效（SE）。
		 */
		public static function stopSe():void
		{
			
		}
		
	}

}