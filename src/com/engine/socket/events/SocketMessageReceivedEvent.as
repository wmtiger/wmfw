package com.engine.socket.events {
	
	import com.engine.message.MessageVO;
	
	import flash.events.Event;
	
	public class SocketMessageReceivedEvent extends Event {
		public static const SOCKET_MSG_RECEIVED:String = "messageReceived";
		
		public var msg:MessageVO;
		
		public function SocketMessageReceivedEvent(msg:MessageVO) {
			super(SOCKET_MSG_RECEIVED, true);
			this.msg = msg;
		}		
	}
}