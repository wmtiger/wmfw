package com.engine.message{
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * </br> 快速创建ParamVO的方法，不需再按如下方法创建ParamVO类型了
	 * </br>   var vo:ParamVO = new ParamVO();
	 * </br>   vo.strValue = ['a','b','c'];
	 * </br>   vo.intValue = [1,2,3];
	 * </br>   sendNotification('commandName',vo);
	 * </br>
	 * </br> 而可以使用以下方法
	 * </br>   sendNotification('commandName',PvoWriter.str('a','b','c').int(1,2,3).pvo);
	 * </br>
	 * </br> 还可以直接使用数组甚至混合使用
	 * </br>   sendNotification('commandName',PvoWriter.str('a','b','c').int([1,2,3]).pvo);
	 * 
	 * 	 * @author huangkan
	 */
	public class PvoWriter{
		
		public function PvoWriter(){}
		
		public static function parse(data:ByteArray):ParamVO{
			var pvo:ParamVO = new ParamVO();
			pvo.mergeFrom(data);
			return pvo;
		}
		
		
		public static function str(...args):PvoWriter{
			return new PvoWriter().str.apply(null,args);
		}
		public static function int(...args):PvoWriter{
			return new PvoWriter().int.apply(null,args);
		}
		public static function long(...args):PvoWriter{
			return new PvoWriter().long.apply(null,args);
		}
		public static function data(...args):PvoWriter{
			return new PvoWriter().data.apply(null,args);
		}
		
		public var pvo:ParamVO = new ParamVO();
		
		public function str(...args):PvoWriter{
			if(args[0] is Array) pvo.strValues=args[0];
			else pvo.strValues = args;
			return this;
		}
		public function int(...args):PvoWriter{
			if(args[0] is Array) pvo.intValues=args[0];
			else pvo.intValues = args;
			return this;
		}
		public function long(...args):PvoWriter{
			if(args[0] is Array) pvo.longValues=args[0];
			else pvo.longValues = args;
			return this;
		}
		public function data(...args):PvoWriter{
			if(args[0] is Array) pvo.data=args[0];
			else pvo.data = args;
			return this;
		}
		
		
	}
}