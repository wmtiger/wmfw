package com.fw.cmd {
	import com.engine.service.Responder;
	import com.fw.AbstractCmd;
	
	import org.puremvc.as3.interfaces.INotification;
	

	public class BaseRemoteCallCommand extends AbstractCmd implements Responder {
		protected var _showLoadingPopup:Boolean = true;
		protected var stopCommand:Boolean;
		
		public function BaseRemoteCallCommand() {
			super();
		}
		
		override public function execute(notification:INotification):void {
			parseArguments(notification.getBody());
			/*if (notification.getType() == LoadingManager.SHOW_LOADING && !stopCommand) {
				_showLoadingPopup = true;
				LoadingManager.getInstance().show(this);
			} else { // default DO NOT show the loading
				_showLoadingPopup = false;
			}*/
		}
		
		// 如果需要处理参数，覆盖此方法
		public function parseArguments(arg:Object):void {
			_arguments = arg;
		}
		
		// 覆盖此方法, 设置RemoteObject的name
		protected function get serviceName():String {
			return "";
		}
		
		// 覆盖此方法, 设置远程方法名
		protected function get methodName():String {
			return "";
		}
		
		protected var _arguments:Object;
		public function get arguments():Object {
			return _arguments;
		}
		
		public function set arguments(value:Object):void {
			_arguments = value;
		}
		
		public function result(event:Object):void {
			response();
		}
		
		public function fault(event:Object):void {
			response();
		}
		
		protected function response():void {
			if (_showLoadingPopup) {
//				LoadingManager.getInstance().hide(this);
			}
		}
		
	}
}