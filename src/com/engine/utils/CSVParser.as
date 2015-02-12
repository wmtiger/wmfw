package com.engine.utils
{
	public class CSVParser
	{
		public function CSVParser()
		{
		}
		
		public static function parserToList(txt:String, hasTitle:Boolean = true, enter:String = "\r", sp:String = ";"):Array
		{
			var list:Array = [];
			var arr:Array = txt.split(enter);
			var keys:Array = arr[0].split(sp);
			var len:int = arr.length;
			var keyLen:int = keys.length;
			var startIdx:int = hasTitle ? 2 : 1;
			for(var i:int = startIdx; i < len; i++)
			{
				var obj:Object = {};
				var values:Array = arr[i].split(sp);
				for(var j:int = 0; j < keyLen; j++)
				{
					obj[keys[j]] = values[j];
				}
				list.push(obj);
			}
			return list;
		}
	}
}