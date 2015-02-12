package com.fw
{
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AbstractProxy extends Proxy
	{
		public function AbstractProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		public function setProxyName(proxyName:String):void {
			this.proxyName = proxyName;
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