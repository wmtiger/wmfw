package com.engine.http
{
	import com.engine.utils.sclearTimeout;
	import com.engine.utils.ssetTimeout;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class HttpLoader extends URLLoader
	{
		public var msg:Object;
		public var resultHandler:Function;
		public var faultHandler:Function;
		public var timeoutHandler:Function;
		
		public var timeoutTime:int = 20000;
		// 倒计时
		private var timeoutKey:int;
		
		public function HttpLoader(request:URLRequest=null)
		{
			super(request);
		}
		
		public function startTimeoutChecking():void {
			if (timeoutKey != 0) {
				sclearTimeout(timeoutKey);
			}
			
			timeoutKey = ssetTimeout(timeoutHandler, timeoutTime, this);
		}
		
		public function clear():void
		{
			msg = null;
			resultHandler = null;
			faultHandler = null;
			timeoutHandler = null;
			if (timeoutKey != 0) {
				sclearTimeout(timeoutKey);
				timeoutKey = 0;
			}
		}
		
	}
}