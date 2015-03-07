package com.fw.view.comps
{
	import flash.geom.Matrix;
	
	import starling.display.QuadBatch;
	
	/**
	 * ...
	 * @author WmTiger
	 */
	public interface IClickQuadBatch 
	{
		function reflush():void;
		
		function addQuadBatch(quadBatch:QuadBatch, parentAlpha:Number = 1.0, modelViewMatrix:Matrix = null, blendMode:String = null):void;
	}
	
}