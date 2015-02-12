package com.engine.socket
{
	import com.engine.message.IMsgCodec;
	import com.engine.message.MessageVO;
	import com.engine.message.StaticMessage;
	import com.engine.socket.events.SocketMessageReceivedEvent;
	import com.engine.socket.handler.SocketHandler;
	import com.engine.utils.Console;
	import com.engine.utils.Map;
	
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * AMF Socket wrapper
	 */
	[Event(name="messageReceived", type="com.coffeebean.engine.socket.events.SocketMessageReceivedEvent")]
	public class SocketWrapper extends Socket {
		/** 消息头位数 */
		private var _headBytes:int;
		/** 消息头是否已读 */
		private var _headReaded:Boolean = false;
		/** 消息体长度 */
		private var _curMsgBodyLen:uint = 0;
		/** tokens dictionary */
		private var _handlerMap:Map;
		
		/**
		 * Message coder and decoder
		 */ 
		private var _msgCodec:IMsgCodec;
		public function set msgCodec(codec:IMsgCodec):void {
			this._msgCodec = codec;
		}
		
		public var ip:String;
		public var port:int;
//		private static var count:int = 0;
//		private static var receiveCount:int = 0;
//		private static var totalBytesSend:Number = 0;
//		private static var totalBytesReceived:Number = 0;
		
		public function SocketWrapper(host:String=null, port:int=0, headBytes:int=2) {
			super(host, port);
			this._headBytes = headBytes;
			if (this._headBytes != 1 && this._headBytes != 2 && this._headBytes != 4) {
				throw new Error("Head bytes must be 1 or 2 or 4");
			}
			
			_handlerMap = new Map();
	        addEventListener(ProgressEvent.SOCKET_DATA, socketData_handler);
		}
		
		public function sendMessage(msg:MessageVO):SocketHandler {
			if (!connected){
				Console.warn('[sendMessage] socket hasn\'t open!');
				return null;	
			}
			
//			msg.generateKeyId();
			msg.futureId = StaticMessage.generateKeyId();
			var bytes:ByteArray = new ByteArray();
			// make bytearrays' endian same as socket's
			bytes.endian = endian;
			bytes.writeObject(msg);
			encryptMsg(bytes);
			
			// write head
			switch (this._headBytes) {
				case 1:
					writeByte(bytes.length);
					break;
				case 2:
					writeShort(bytes.length);
					break;
				case 4:
					writeInt(bytes.length);
					break;
			}
			// write object
			writeBytes(bytes);
			flush();
			
//			totalBytesSend += bytes.bytesAvailable;
//			Console.info(++count + "Message send - ");
			if (msg.phase == StaticMessage.REQUEST_PHASE) {
				var token:SocketHandler = new SocketHandler();
				token.id = msg.futureId.toString();
				Console.debug("send futureId: " + token.id);
				_handlerMap.putValue(token.id, token);
				return token;
			}
			return null;
		}
		
		private function encryptMsg(bytes:ByteArray):void {
			if(_msgCodec) {
				_msgCodec.encryptMsg(bytes);
			}
		}
		
		private function decryptMsg(bytes:ByteArray):void {
			if(_msgCodec) {
				_msgCodec.decryptMsg(bytes);
			}
		}
		
	    private function socketData_handler(event:ProgressEvent):void {
        	parseData();
	    }
	    
	    private function parseData():void {
        	if (!connected) {
				Console.warn('[parseData] socket is not openning.');
				return;
        	}
        	
        	// message head not read yet.
        	if (_headReaded == false) {
        		// available bytes short than head len
	        	if (bytesAvailable < this._headBytes) {
	        		return;
	        	}
	        	//读取头信息，设置消息体内容长度
	        	switch (this._headBytes) {
	        		case 1:
	        			this._curMsgBodyLen = readUnsignedByte();
	        			break;
	        		case 2:
	        			this._curMsgBodyLen = readUnsignedShort();
	        			break;
	        		case 4:
	        			this._curMsgBodyLen = readInt();
	        			break;
	        	}
	        	
	        	// head readed...
	        	if (this._curMsgBodyLen > 0) {
		        	_headReaded = true;
	        	} else {
	        		return;
	        	}
        	}
        	
        	// 读取消息体
        	if (_headReaded && bytesAvailable >= this._curMsgBodyLen) {
        		var bytes:ByteArray = new ByteArray();
        		readBytes(bytes, 0, this._curMsgBodyLen);
        		// 解密bytearray
        		decryptMsg(bytes);
        		
        		_headReaded = false;
//        		totalBytesReceived += bytes.bytesAvailable;
//        		Console.info(++receiveCount + "Message received - ");
				
//        		handleReceivedMessage(bytes.readObject() as SocketMessage);
				var msg:MessageVO = new MessageVO()
				msg.mergeFrom(bytes)
				handleReceivedMessage( msg);
        	} else {
        		return;
        	}
        	
        	// 如果消息读取完毕，socket中还有数据，继续解析。
        	if (bytesAvailable >= this._headBytes) {
        		parseData();
        	}
	    }
	    
	    private function handleReceivedMessage(msg:MessageVO):void {
	    	var handler:SocketHandler;
	    	if (msg.phase == StaticMessage.RESPONSE_OK_PHASE) {
	    		Console.debug("receive futureId: " + msg.futureId);
	    		handler = _handlerMap.remove(msg.futureId);
	    		if (handler) {
	    			handler.resultHandler(msg);
	    		} else {
	    			dispatchEvent(new SocketMessageReceivedEvent(msg));
	    		}
	    	} else if (msg.phase == StaticMessage.RESPONSE_FAILED_PHASE) {
	    		handler = _handlerMap.remove(msg.futureId);
	    		if (handler) {
	    			handler.faultHandler(msg);
	    		} else {
	    			dispatchEvent(new SocketMessageReceivedEvent(msg));
	    		}
	    	} else {
		    	//读出数据发送事件
				dispatchEvent(new SocketMessageReceivedEvent(msg));
	    	}
	    }
	    
	    // =============================== public static functions =============================== // 
	    public static function readMsgHeader(bytes:ByteArray, headerBytes:int = 2):uint {
			var rtn:uint;
			switch (headerBytes) {
				case 1:
					rtn = bytes.readUnsignedByte();
					break;
				case 2:
					rtn = bytes.readUnsignedShort();
					break;
				case 4:
					rtn = bytes.readInt();
					break;
				default:
					throw new Error("header length must be 1 or 2 or 4");
					break;
			}
			bytes.position = bytes.position - headerBytes;
			return rtn;
		}
	}
}