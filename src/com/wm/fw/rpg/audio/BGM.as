package com.wm.fw.rpg.audio 
{
	import com.wm.fw.rpg.utils.AudioUtil;
	/**
	 * ...
	 * @author wmTiger
	 */
	public class BGM extends AudioFile 
	{
		private var _last:BGM;
		private var _pos:int;
		
		public function BGM() 
		{
			super();
			_last = new BGM();
		}
		
		/**
		 * 返回正在播放背景音乐（BGM）。若是没有播放背景音乐，则返回 null。
		 * 还可以存储当前播放的背景音乐播放到的位置。
		 * @return
		 */
		protected function get last():BGM
		{
			_last.pos = AudioUtil.getCrtBgmPos();
			return _last;
		}
		
		public function get pos():int 
		{
			return _pos;
		}
		
		public function set pos(value:int):void 
		{
			_pos = value;
		}
		
		/**
		 * 停止播放背景音乐。
		 */
		protected function stop():void
		{
			AudioUtil.stopBgm();
			_last = new BGM();
		}
		
		/**
		 * 开始淡出背景音乐。time 是以毫秒计算的淡出时间长度。
		 * @param	time
		 */
		protected function fade(time:int = 0):void
		{
			AudioUtil.fadeBgm(time);
			_last = new BGM();
		}
		
		/**
		 * 开始播放背景音乐。
		 * 如果音乐文件是 mp3 格式，可以用 pos 参数指定播放的开始时间点。
		 * @param	pos
		 */
		public function play(pos:int = 0):void
		{
			if (name.length <= 0) 
			{
				AudioUtil.stopBgm();
				_last = new BGM();
			}
			else
			{
				AudioUtil.playBgm('assets/audio/bgm/' + name, volume, pitch, pos);
				_last = BGM(clone());
			}
		}
		
		/**
		 * 重放 BGM.last 所存储的背景音乐。
		 */
		public function replay():void
		{
			last.play();
		}
		
		override public function clone():AudioFile 
		{
			return new BGM();
		}
		
	}

}