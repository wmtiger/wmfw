package com.engine.service {
	public interface Responder {
		function result(event:Object):void;

		function fault(event:Object):void;
		
		function get arguments():Object;
		function set arguments(value:Object):void;
   }   
}