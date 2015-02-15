package com.fw.cmd {
	
	import com.engine.message.StaticMessage;
	import com.engine.service.ServiceLocator;
	import com.fw.cmd.BaseRemoteCallCommand;
	
	import org.puremvc.as3.interfaces.INotification;
	

	public class HttpCommand extends BaseRemoteCallCommand {
		public function HttpCommand() {
			super();
		}
		
		override public function execute(notification:INotification):void {
			super.execute(notification);
			if (!stopCommand) {
				ServiceLocator.getInstance().httpCall(serviceName, methodName, commandType, this);
			}
		}
		protected function get commandType():int {
			return StaticMessage.NO_RESPONSE;
		}
		/**
		 * 是否远程调用
		 */ 
		protected function get isRemoteCall():Boolean {
			return true;
		}
	}
}