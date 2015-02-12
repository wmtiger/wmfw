package com.fw
{
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import com.engine.utils.Map;
	
	public class AbstractMediator extends Mediator {
		private var _listeners:Map;
		
		/**
		 * set the mediator name by AppFacade.
		 */ 
		internal function setMediatorName(mediatorName:String):void {
			this.mediatorName = mediatorName;
		}
		
		/**
		 * Regiester/Retrieve by mediator class name for all AbstraceMediator 
		 */ 
		public function AbstractMediator(viewComponent:Object) {
			super(null, viewComponent);
		}
		
		/**
		 * sub classes override this.
		 * @param map listeners
		 */
		protected function listNotificationListeners(listeners:Map):void {
		}
		
		public final override function listNotificationInterests():Array {
			if (_listeners == null) {
				_listeners = new Map();
				listNotificationListeners(_listeners);
			}
			return _listeners.keys();
		}
		
		public final override function handleNotification(notification:INotification):void {
			if (notification == null){
				return;
			}
			
			var handler:Function = _listeners.getValue(notification.getName());
			if (handler != null){
				handler.apply(null, [notification]);
			}
		}
		
		public override function onRemove():void {
			super.onRemove();
			this.setViewComponent(null);
			_listeners.clear();
		}
		
		/**
		 * Use simpleFacade instead of facade. 
		 */
		protected function get appFacade():AppFacade {
			var r:AppFacade = facade as AppFacade;
			if (r == null) {
				throw Error(AppFacade.FACADE_ERROR);
			}
			return r;
		}
		
		protected function getServiceByType(clazz:Class):AbstractProxy {
			return appFacade.retrieveProxyByType(clazz);
		}
	}
}