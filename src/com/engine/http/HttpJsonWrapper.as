package com.engine.http
{
	import com.engine.message.IMsgCodec;
	import com.engine.utils.Console;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
//	[Event(name="httpMessageReceived", type="com.coffeebean.engine.http.events.HttpMessageEvent")]
//	[Event(name="httpMessageError", type="com.coffeebean.engine.http.events.HttpMessageEvent")]
	public class HttpJsonWrapper extends EventDispatcher
	{
//		/** tokens dictionary */
//		private var _handlerMap:Map;
		/**
		 * Message url
		 */		
//		public var url:String;
		private var token:String;
		/**
		 * Message coder and decoder
		 */ 
		private var _msgCodec:IMsgCodec;
//		private var allMessage:Array = [];
		public function set msgCodec(codec:IMsgCodec):void {
			this._msgCodec = codec;
		}
		public function HttpJsonWrapper()
		{
			
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
		public function sendMessage(url:String,result:Function,fault:Function):void 
		{
			if (_closed) {
				//TODO, 已经关闭
//				throw new Error("");
				return;
			}
		
			var request:URLRequest = new URLRequest(url)
			request.url = url;
			request.method = URLRequestMethod.POST;
			
			var loader:HttpLoader = new HttpLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
			loader.msg = url;
			loader.resultHandler = result;
			loader.faultHandler = fault;
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			// 超时处理
			loader.timeoutHandler = timeoutHandler;
			loader.startTimeoutChecking();
			
		}
		private function completeHandler(evt:Event):void
		{
			const loader:HttpLoader = evt.target as HttpLoader

			var rtn:String = String(loader.data);
			try{
				var obj:Object = JSON.parse(rtn);
				loader.resultHandler(obj);

			}catch (e:*)
			{
				loader.faultHandler(loader.msg);
				Console.debug(loader.msg + e.text);
			}			
			loader.clear();
			loader.removeEventListener(Event.COMPLETE,completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);			
		}
		
		
		private function errorHandler(evt:IOErrorEvent):void
		{
			const loader:HttpLoader = evt.target as HttpLoader;
			Console.debug(loader.msg + evt.text);
//			dispatchEvent(new HttpMessageEvent(HttpMessageEvent.Http_MSG_ERROR,loader.msg));
 			loader.faultHandler(loader.msg);	
			loader.clear();
			loader.removeEventListener(Event.COMPLETE,completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		private function timeoutHandler(loader:HttpLoader):void 
		{
			
			Console.debug("Timeout: " + loader.msg);
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