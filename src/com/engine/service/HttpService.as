package com.engine.service {
	import com.engine.http.HttpWrapper;

	public class HttpService extends AbstractRemoteService {
		public function HttpService() {
		}
      	
      	/**
      	 * Register all RemoteObjects in serviceLocator.
      	 */ 
      	override public function register(serviceLocator:IServiceLocator):void {
         	var accessors : XMLList = getAccessors(serviceLocator);
         
	        for (var i:uint = 0; i < accessors.length(); i++ ) {
	            var name : String = accessors[ i ];
	            var obj : Object = serviceLocator[ name ];
	            
	            if (obj is HttpWrapper) {
					services[ name ] = obj;
				}
			}
      	}
	}
}