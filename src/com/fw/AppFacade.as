package com.fw
{
	import com.engine.utils.Console;
	import com.engine.utils.Map;
	
	import flash.utils.getQualifiedClassName;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import starling.display.DisplayObjectContainer;
	
	public class AppFacade extends Facade
	{
		internal static const FACADE_ERROR:String = "Please call AppFacade.instance to init the Facade!";
		
		public static const STARTUP_APPFACADE:String = "startupAppFacade";
		
		private static var _instance:AppFacade;
		
		public var noResponseCommandMap:Map = new Map();
		
		public function AppFacade()
		{
			super();
		}
		
		public static function get instance():AppFacade
		{
			if (_instance == null)
				_instance = new AppFacade();
			return _instance as AppFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			// 以下这句在继承之后要加的
//			registerCommand(STARTUP_APPFACADE, StartupAppCmd);
		}
		
		public function startUp(rootView:DisplayObjectContainer):void
		{
			sendNotification(STARTUP_APPFACADE, rootView);
			removeCommand(STARTUP_APPFACADE); //PureMVC初始化完成，注销STARTUP_APPFACADE命令
		}
		
		public function registerMediatorByType(mediator:AbstractMediator):void {
			mediator.setMediatorName(getQualifiedClassName(mediator));
			
			if (hasMediator(mediator.getMediatorName())) {
				Console.warn("Register duplicate mediator by type: " + mediator.getMediatorName());
			} else {
				Console.info("Register mediator By type: " + mediator.getMediatorName());
			}
			
			super.registerMediator(mediator);
		}
		
		/**
		 * Another retrieve mediator method. By class name.
		 */ 
		public function retrieveMediatorByType(clazz:Class):AbstractMediator {
			var name:String = getQualifiedClassName(clazz);
			return retrieveMediator(name) as AbstractMediator;
		}
		
		public function hasMediatorByType(clazz:Class):Boolean {
			var name:String = getQualifiedClassName(clazz);
			return hasMediator(name);
		}
		
		public function removeMediatorByInstance(mediator:IMediator):IMediator {
			var name:String = getQualifiedClassName(mediator);
			Console.info("Mediator Removed: " + mediator.getMediatorName());
			return removeMediator(name);
		}
		
		public function removeMediatorByType(clz:Class):IMediator {
			var name:String = getQualifiedClassName(clz);
			return removeMediator(name);
		}
		
		/**
		 * Regiester proxy by class name.
		 */ 
		public function registerProxyByType(proxy:AbstractProxy):void {
			proxy.setProxyName(getQualifiedClassName(proxy));
			
			if (hasProxy(proxy.getProxyName())) {
				Console.warn("Register duplicate proxy by name: " + proxy.getProxyName());
			} else {
				Console.info("Register proxy by type: " + proxy.getProxyName());
			}
			super.registerProxy(proxy);
		}
		
		public function hasProxyByType(clazz:Class):Boolean {
			var name:String = getQualifiedClassName(clazz);
			return hasProxy(name);
		}
		
		/**
		 * Retrieve proxy by Class Name.
		 */ 
		public function retrieveProxyByType(clazz:Class):AbstractProxy {
			var name:String = getQualifiedClassName(clazz);
			return retrieveProxy(name) as AbstractProxy;
		}
		
		/**
		 * Remove proxy by name.
		 */ 
		public function removeProxyByType(clazz:Class):IProxy {
			var name:String = getQualifiedClassName(clazz);
			var proxy:IProxy = removeProxy(name);
			if (proxy != null) {
				Console.info("remove proxy by type: " + name);
			}
			return proxy;
		}
	}
}