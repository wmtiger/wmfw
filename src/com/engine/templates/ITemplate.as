package com.engine.templates
{
	public interface ITemplate
	{
		
		function initTemps(name:String):void;
		
		function getTempById(id:Number):ITemplate;
		
		function getProp(id:Number, propname:String):*;
		
		function getCrtProp(propname:String):*;
			
		function get id():Number;
		
		function get name():String;
		
		function get hasNext():Boolean;
		
		function get hasPrev():Boolean;
		
		function get nextTemp():ITemplate;
		
		function get prevTemp():ITemplate;
		
		function get firstTemp():ITemplate;
		
		function get lastTemp():ITemplate;
		
	}
}