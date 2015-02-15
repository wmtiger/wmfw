package com.fw.cmd {

	import com.engine.message.StaticMessage;
	import com.engine.service.ServiceLocator;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class SocketCommand extends BaseRemoteCallCommand {
		public function SocketCommand() {
			super();
		}
		
		protected function get isSingleThread():Boolean {
			return false;
		}
		
		protected function get isThreadWorking():Boolean {
			return false;
		}
		
		protected function setThreadWorking(value:Boolean):void {
		}
		
		override public function execute(notification:INotification):void {
			if (isSingleThread) {
				if (isThreadWorking) {
//					FloatingWordsManager.getInstance().simpleFloatingStage("您的操作太快了");
					return;
				} else {
					setThreadWorking(true);
				}
			}
			
			if (commandType == StaticMessage.NO_RESPONSE) {
//				notification.setType(LoadingManager.HIDE_LOADING);
			}
			super.execute(notification);
			if (!stopCommand) {
				if (isRemoteCall) {
					ServiceLocator.getInstance().socketCall(serviceName, methodName, commandType, this);
				} else {
					setThreadWorking(false);
					localExecute();
				}
			} else if (isSingleThread) {
				setThreadWorking(false);
			}
//			Console.debug("Socket action: " + methodName, "参数: " + _arguments);
		}
		
		override final protected function response():void {
			setThreadWorking(false);
			super.response();
		}
		
		/**
		 * 如果非远程调用, 则调用localExecute, _arguments已经设置
		 */ 
		protected function localExecute():void {
		}
		
		/**
		 * 是否远程调用
		 */ 
		protected function get isRemoteCall():Boolean {
			return true;
		}
		
		/**
		 * if command type is NO_RESPONSE, resultHandler and faultHandler will not be invoked.
		 */ 
		protected function get commandType():int {
			return StaticMessage.NO_RESPONSE;
		}
		
	}
}