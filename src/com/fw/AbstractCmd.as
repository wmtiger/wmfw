package com.fw
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AbstractCmd extends SimpleCommand 
	{
		
		protected function get appFacade():AppFacade {
			var r:AppFacade = facade as AppFacade;
			if (r == null) {
				throw Error(AppFacade.FACADE_ERROR);
			}
			return r;
		}
		
		protected function getProxyByType(servicecClz:Class):AbstractProxy {
			return appFacade.retrieveProxyByType(servicecClz);
		}
	}
}