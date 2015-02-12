package com.engine.service {
	import com.engine.http.HttpJsonWrapper;
	import com.engine.http.HttpWrapper;
	import com.engine.message.MessageVO;
	import com.engine.message.ParamVO;
	import com.engine.socket.SocketWrapper;
	import com.engine.socket.handler.SocketHandler;
	import com.engine.utils.Console;
	
	public dynamic class ServiceLocator implements IServiceLocator {
		private static var instance:ServiceLocator;
		
//		private static var _remoteObjectSer:RORemoteService;
//		public function get remoteObjectSer():RORemoteService {
//			if (_remoteObjectSer == null) {
//				_remoteObjectSer = new RORemoteService();
//				_remoteObjectSer.register(this);
//			}
//			return _remoteObjectSer;
//		}
//		
//		private static var _httpSer:HttpRemoteService;
//		public function get httpSer():HttpRemoteService {
//			if (_httpSer == null) {
//				_httpSer = new HttpRemoteService();
//				_httpSer.register(this);
//			}
//			return _httpSer;
//		}
		private static var _httpSer:HttpService;
		public function get httpSer():HttpService {
			if (_httpSer == null) {
				_httpSer = new HttpService();
				_httpSer.register(this);
			}
			return _httpSer;
		}
		private static var _httpJsonSer:HttpJsonService;
		public function get httpJsonSer():HttpJsonService {
			if (_httpJsonSer == null) {
				_httpJsonSer = new HttpJsonService();
				_httpJsonSer.register(this);
			}
			return _httpJsonSer;
		}	
        private static var _socketSer:SocketService;
		public function get socketSer():SocketService {
			if (_socketSer == null) {
				_socketSer = new SocketService();
				_socketSer.register(this);
			}
			return _socketSer;
		}
		
		public function resetSocket(id:String, socket:SocketWrapper):void {
			_socketSer.setService(id, socket);
		}
		
		public function connectSocket(id:String, ip:String = null, port:int = 0):void {
			var socket:SocketWrapper = getSocketService(id);
			
			if (socket == null) {
				throw new Error("Socket with ID: <" + id + "> not exist!");
			}
			
			if (socket.connected) {
				socket.close();
			}
			
			if (ip == null) {
				ip = socket.ip;
			}
			
			if (port == 0) {
				port = socket.port;
			}
			
			socket.connect(ip, port);
		}
		
		public static function getInstance():ServiceLocator {
	        if (instance == null) {
				instance = new ServiceLocator();
			}
            
			return instance;
		}
		
		public function ServiceLocator() {
			if (instance != null) {
				throw new Error("Only one ServiceLocator instance can be instantiated");
			}
            
			instance = this;
		}

//		public function getRemoteObjectService(name:String):RemoteObject {
//			if (remoteObjectSer.hasService(name)) {
//				return remoteObjectSer.getService(name) as RemoteObject;
//			}
//			return null;
//		}
//		
//		public function getHttpService(name:String):HTTPService {
//			if (httpSer.hasService(name)) {
//				return httpSer.getService(name) as HTTPService;
//			}
//			return null;
//		}
		public function getHttpService(name:String):HttpWrapper {
			if (httpSer.hasService(name)) {
				return httpSer.getService(name) as HttpWrapper;
			}
			return null;
		}
		public function getHttpJsonService(name:String):HttpJsonWrapper {
			if (httpJsonSer.hasService(name)) {
				return httpJsonSer.getService(name) as HttpJsonWrapper;
			}
			return null;
		}	
		public function getSocketService(name:String):SocketWrapper {
			if (socketSer.hasService(name)) {
				return socketSer.getService(name) as SocketWrapper;
			}
			return null;
		}
		
//		public function remoteObjectCall(name:String, method:String, responder:Responder):void {
//			if (getRemoteObjectService(name) == null) {
//				Console.error("Can not find any Remote Object with name: " + name);
//				return;
//			}
//			
//			var operation:AbstractOperation = getRemoteObjectService(name).getOperation(method);
//			operation.arguments = responder.arguments;
//			
//			var token:AsyncToken = operation.send();
//			
//			token.resultHandler = responder.result;
//            token.faultHandler = responder.fault;
//		}
		
//		public function HTTPCall(name:String, method:String, responder:Responder):void {
//			if (getHttpService(name) == null) {
//				Console.error("Can not find any Http Service with name: " + name);
//				return;
//			}
//			
//			var token:AsyncToken = getHttpService(name).send(responder.arguments);
//			token.resultHandler = responder.result;
//            token.faultHandler = responder.fault;
//		}
		
		public function call(name:String, method:String, phase:int, responder:Responder, params:ParamVO = null):void
		{
			if(getHttpService(name) != null)
				httpCall(name, method, phase, responder, params)
			else if(getSocketService(name) != null)	
				socketCall(name, method, phase, responder, params)
			else if(getHttpJsonService(name)!=null)
				httpJsonCall(name, method, phase, responder, params)
		}
		
		/**
		 * http call 必定有返回
		 */ 
		public function httpCall(name:String, method:String, phase:int, responder:Responder, params:ParamVO = null):void {
			if (getHttpService(name) == null) {
				Console.error("Can not find any Http Service with name: " + name);
				return;
			}
			var msg:MessageVO = new MessageVO();
			msg.action = int(method);
		    msg.phase = phase;
			if (params) {
				msg.data = params;
			} else if (responder) {
				msg.data = responder.arguments as ParamVO;
			}
			getHttpService(name).sendMessage(msg,responder.result,responder.fault);
//			if(token)
//			{
//				token.resultHandler = responder.result;
//                token.faultHandler = responder.fault;
//			}
			
		}
		/**
		 * http json call 必定有返回
		 */ 
		public function httpJsonCall(name:String, url:String, phase:int, responder:Responder, params:ParamVO = null):void {
			if (getHttpJsonService(name) == null) {
				Console.error("Can not find any Http Service with name: " + name);
				return;
			}
			getHttpJsonService(name).sendMessage(url,responder.result,responder.fault);
		}
		public function socketCall(name:String, method:String, phase:int, responder:Responder, params:ParamVO = null):void {
			if (getSocketService(name) == null) {
				Console.error("Can not find any Http Service with name: " + name);
				return;
			}
			
			var msg:MessageVO = new MessageVO();
			msg.action = int(method);
			msg.phase = phase;
			if (params) {
				msg.data = params;
			} else if (responder) {
				msg.data = responder.arguments as ParamVO;
			}
//			msg.sendAt = SystemTimer.getCurrentSystemTime();
			
			var token:SocketHandler = getSocketService(name).sendMessage(msg);
			if (token) {
				token.resultHandler = responder.result;
	            token.faultHandler = responder.fault;
			}
		}
		
	}
}