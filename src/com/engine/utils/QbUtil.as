package com.engine.utils
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;

	public class QbUtil
	{
		public function QbUtil()
		{
		}
		
		public static function addTexture(texture:Texture, x:int=0, y:int=0,quadBatch:QuadBatch=null):QuadBatch{
			if(quadBatch==null) quadBatch = new QuadBatch();
			quadBatch.addImage(addImage(texture,x,y));
			return quadBatch;
		}
		
		public static function addImage(texture:Texture, x:int=0, y:int=0, container:DisplayObjectContainer=null):Image{
			var image:Image = new Image(texture);
			image.x = x;   image.y = y;
			if(container!=null)container.addChild(image);
			return image;
		}
	}
}