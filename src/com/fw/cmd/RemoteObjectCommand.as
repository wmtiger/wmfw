package com.fw.cmd {
	import org.puremvc.as3.interfaces.INotification;
	
	public class RemoteObjectCommand extends BaseRemoteCallCommand  {
		public function RemoteObjectCommand() {
			super();
		}
		
		override public function execute(notification:INotification):void {
			super.execute(notification);
			if (!stopCommand) {
//				ServiceLocator.getInstance().remoteObjectCall(serviceName, methodName, this);
			}
//			Console.debug("方法名: " + methodName, "参数: " + _arguments);
		}
	}
}