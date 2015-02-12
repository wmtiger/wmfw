package com.engine.http.events
{
	import com.engine.message.MessageVO;
	
	import flash.events.Event;
	
	public class HttpMessageEvent extends Event {
		/**
		 *接收数据 
		 */		
		public static const Http_MSG_RECEIVED:String = "httpMessageReceived";
		/**
		 *数据发送失败 
		 */		
		public static const Http_MSG_ERROR:String = "httpMessageError";
		
		public var msg:MessageVO;
		
		public function HttpMessageEvent(type:String,msg:MessageVO) {
			super(type, true);
			this.msg = msg;
		}		
	}
}