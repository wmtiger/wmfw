package com.engine.utils
{
	public class ResourceBundleUtil
	{
		private static var _msg:Object;
		private static var _error:Object = {};
		static private var _msgInited:Boolean = false;
		static private var _errorInited:Boolean = false;
		
		public static function getMessage(key:String, ... params):String
		{
			var str:String = _msg[key];
			if (str)
			{
				str = replace(str, "\\n", "\n");
				return formatString(str, params);
			}
			return "";
		}
		
		public static function getError(key:String, ... params):String
		{
			var str:String = _error[key];
			if (str)
			{
				str = replace(str, "\\n", "\n");
				return formatString(str, params);
			}
			return "";
		}
		
		private static function formatString(format:String, args:Array):String
		{
			var len:int = args.length;
			for (var i:int = 0; i < len; ++i)
				format = format.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			
			return format;
		}
		
		static public function setMsgSourceData(value:String):void
		{
			if (_msgInited)
			{
				return;
			}
			_msg = {};
			var winfile:Boolean = value.indexOf("\r\n") >= 0;
			var splitMark:String = winfile ? "\r\n" : "\n";
			var arr:Array = value.split(splitMark);
			var len:int = arr.length;
			var kv:Array;
			for (var i:int = 0; i < len; i++)
			{
				if (!isIgoneLine(arr[i]))
				{
					kv = getArrKeyAndValue(arr[i]);
					_msg["" + kv[0]] = kv[1];
				}
			}
			_msgInited = true;
		}
		
		public static function getClearHeadSpace(str:String):String
		{
			// 第一个有效字符是#，此行为注释
			var len:int = str.length;
			for (var i:int = 0; i < len; i++)
			{
				if (str.charAt(i) == " ")
				{
					continue;
				}
				else
				{
					return str.substr(i);
				}
			}
			return str;
		}
		
		static public function setErrorSourceData(value:String):void
		{
			if (_errorInited)
			{
				return;
			}
			_error = {};
			//value = replace(value, " ", "");
			var winfile:Boolean = value.indexOf("\r\n") >= 0;
			var splitMark:String = winfile ? "\r\n" : "\n";
			var arr:Array = value.split(splitMark);
			var len:int = arr.length;
			var kv:Array;
			for (var i:int = 0; i < len; i++)
			{
				if (!isIgoneLine(arr[i]))
				{
					kv = getArrKeyAndValue(arr[i]);
					_error["" + kv[0]] = kv[1];
				}
			}
			_errorInited = true;
		}
		
		private static function getArrKeyAndValue(str:String):Array
		{
			var arr:Array = str.split("=");
			arr[0] = StringUtil.trim(arr[0]);
			var len:int = arr.length;
			var str2:String = arr[1];
			for (var i:int = 2; i < len; i++)
			{
				str2 += ("=" + arr[i]);
			}
			arr[1] = StringUtil.trim(str2);
			return arr;
		}
		
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//change to StringBuilder
			var sb:String = new String();
			var found:Boolean = false;
			
			var sLen:Number = input.length;
			var rLen:Number = replace.length;
			
			for (var i:Number = 0; i < sLen; i++)
			{
				if (input.charAt(i) == replace.charAt(0))
				{
					found = true;
					for (var j:Number = 0; j < rLen; j++)
					{
						if (!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}
					
					if (found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			//TODO : if the string is not found, should we return the original
			//string?
			return sb;
		}
		
		static private function isIgoneLine(str:String):Boolean
		{
			// 第一个有效字符是#，此行为注释
			var len:int = str.length;
			for (var i:int = 0; i < len; i++)
			{
				if (str.charAt(i) != "#" && str.charAt(i) == " ")
				{
					return false;
				}
				if (str.charAt(i) == "#")
				{
					return true;
				}
				if (str.charAt(i) == " ")
				{
					continue;
				}
			}
			return false;
		}
	}
}