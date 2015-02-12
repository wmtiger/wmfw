package com.engine.message
{
	import com.netease.protobuf.Int64;

	public class StaticMessage 
	{
		public static const REQUEST_PHASE:int = 1;
		public static const RESPONSE_OK_PHASE:int = 2;
		public static const RESPONSE_FAILED_PHASE:int = 3;
		public static const NO_RESPONSE:int = 0;
		
		private static var auto_id:int = 0; 
		
		public static function  generateKeyId():Int64 {
			var futureId:Int64 = Int64.fromNumber(auto_id);
			auto_id++;
			return futureId;
		}
		
		public function StaticMessage()
		{
		}
	}
}