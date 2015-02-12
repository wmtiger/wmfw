package com.engine.service
{
	public class SimpleResponder implements Responder
	{
		public function SimpleResponder()
		{
		}
		public var responderFunc:Function;
		
		public function result(event:Object):void
		{
			if (responderFunc != null) {
				responderFunc.call(null, event);
			}
		}
		
		public function fault(event:Object):void
		{
//			if (responderFunc != null) {
//				responderFunc.call(null, event);
//			}
		}
		
		public function get arguments():Object
		{
			return null;
		}
		
		public function set arguments(value:Object):void
		{
		}
	}
}