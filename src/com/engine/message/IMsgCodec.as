package com.engine.message
{
	import flash.utils.ByteArray;
	
	public interface IMsgCodec {
		function encryptMsg(bytes:ByteArray):void;
		
		function decryptMsg(bytes:ByteArray):void;
	}
}