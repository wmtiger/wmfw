package com.engine.http
{
	import com.engine.http.events.HttpMessageEvent;
	import com.engine.message.IMsgCodec;
	import com.engine.message.MessageVO;
	import com.engine.message.StaticMessage;
	import com.engine.utils.Console;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	

	[Event(name="httpMessageReceived", type="com.coffeebean.engine.http.events.HttpMessageEvent")]
	[Event(name="httpMessageError", type="com.coffeebean.engine.http.events.HttpMessageEvent")]
	public class HttpWrapper extends EventDispatcher
	{
//		/** tokens dictionary */
//		private var _handlerMap:Map;
		/**
		 * Message url
		 */		
		public var url:String;
		private var token:String;
		/**
		 * Message coder and decoder
		 */ 
		private var _msgCodec:IMsgCodec;
//		private var allMessage:Array = [];
		public function set msgCodec(codec:IMsgCodec):void {
			this._msgCodec = codec;
		}
		public function HttpWrapper(_url:String)
		{
			url = _url;
//			_handlerMap = new Map();
		}
		
		private var _closed:Boolean;
		
		public function close():void {
			_closed = true;
		}
		
		public function open():void {
			_closed = false;
		}
		/**
		 * http 发送数据 
		 * @param msg
		 * @return 
		 * 
		 */		
		public function sendMessage(msg:MessageVO,result:Function,fault:Function):void 
		{
			if (_closed) {
				//TODO, 已经关闭
//				throw new Error("");
				return;
			}
			if(token!=null)
				msg.token = token;
//			msg.futureId = StaticMessage.generateKeyId();
			var request:URLRequest = new URLRequest(url)
			request.url = url;
//			msg.sendAt = Int64.fromNumber(new Date().time)
			request.method = URLRequestMethod.POST;
			var b:ByteArray = new ByteArray();
			msg.writeTo(b);
			encryptMsg(b);
			request.data = b;
			var loader:HttpLoader = new HttpLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(request);
			loader.msg = msg;
			loader.resultHandler = result;
			loader.faultHandler = fault;
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			// 超时处理
			loader.timeoutHandler = timeoutHandler;
			loader.startTimeoutChecking();
			totalSend += b.length;
//			allMessage.push(loader);
//			trace("Send Message: " + msg.action + ". Size: " + b.length * 0.001 + "k" + " * Total Size: " + totalSend * 0.001 + "k");
//			if (msg.phase == StaticMessage.REQUEST_PHASE) {
//				var token:MessageHandler = new MessageHandler();
//				token.id = msg.futureId.toString();;
//				_handlerMap.putValue(msg.futureId.toString(), token);
//				return token;
//			}
//			return null;
		}
		private function completeHandler(evt:Event):void
		{
			const loader:HttpLoader = evt.target as HttpLoader
//			var index:int = allMessage.indexOf(loader)
//			if(index!=-1)
//			{
//				allMessage.splice(index,1);
//			}
			const b:ByteArray = evt.target.data as  ByteArray;
			decryptMsg(b);
			const msg:MessageVO = new MessageVO();
			b.position = 0;
			msg.mergeFrom(b); 
			if(msg.hasToken)
				token = msg.token;
//			var handler:MessageHandler;
			if (msg.phase == StaticMessage.RESPONSE_OK_PHASE) {
				loader.resultHandler(msg)
//				Console.debug("receive futureId: " + msg.futureId);
//				handler = _handlerMap.remove(msg.futureId.toString());
//				if (handler) {
//					handler.resultHandler(msg);
//				} else {
//					dispatchEvent(new HttpMessageEvent(HttpMessageEvent.Http_MSG_RECEIVED,msg));
//				}
			} else if (msg.phase == StaticMessage.RESPONSE_FAILED_PHASE) {
				loader.faultHandler(msg)
//				handler = _handlerMap.remove(msg.futureId);
//				if (handler) {
//					handler.faultHandler(msg);
//				} else {
//					dispatchEvent(new HttpMessageEvent(HttpMessageEvent.Http_MSG_RECEIVED,msg));
//				}
			} else {
				//读出数据发送事件
				dispatchEvent(new HttpMessageEvent(HttpMessageEvent.Http_MSG_RECEIVED,msg));
			}
			loader.clear();
			loader.removeEventListener(Event.COMPLETE,completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			totalReceived += b.length;
			
//			trace("Received Message: " + msg.action + ". Size: " + b.length * 0.001 + "k" + " * Total Size: " + totalReceived * 0.001 + "k");
		}
		
		private static var totalSend:int;
		private static var totalReceived:int;
		
		private static var errorCount:int;
		private function errorHandler(evt:IOErrorEvent):void
		{
//			var index:int = allMessage.indexOf(loader)
//			if(index!=-1)
//			{
//				allMessage.splice(index,1);
//			}
			const loader:HttpLoader = evt.target as HttpLoader;
			const msg:MessageVO = loader.msg as MessageVO;
			Console.debug(msg.action + evt.text);
			dispatchEvent(new HttpMessageEvent(HttpMessageEvent.Http_MSG_ERROR,msg));
 			loader.faultHandler(null);
//				var handler:MessageHandler = _handlerMap.remove(msg.futureId.toString())
//				if (handler) 
//					loader.faultHandler(msg);			
			loader.clear();
			loader.removeEventListener(Event.COMPLETE,completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			errorCount++;
			if (errorCount > 3) {
//				SimpleFacade.getInstance().sendNotification('restart');
				errorCount = 0;
			}
		}
		
		private function timeoutHandler(loader:HttpLoader):void {
			const msg:MessageVO = loader.msg as MessageVO;
//			var index:int = allMessage.indexOf(loader)
//			if(index!=-1)
//			{
//				allMessage.splice(index,1);
//			}
			Console.debug("Timeout: " + msg.action);
//			dispatchEvent(new HttpMessageEvent(HttpMessageEvent.Http_MSG_ERROR,msg));
			loader.faultHandler(null);
			loader.clear();
			loader.removeEventListener(Event.COMPLETE,completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.close();
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
		
	}
}