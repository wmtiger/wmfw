package com.engine.message {
	import com.netease.protobuf.Int64;
	import com.netease.protobuf.Message;
	import com.netease.protobuf.ReadUtils;
	import com.netease.protobuf.WireType;
	import com.netease.protobuf.WriteUtils;
	import com.netease.protobuf.WritingBuffer;
	import com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_BOOL;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_INT32;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_INT64;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_MESSAGE;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_STRING;
	
	import flash.errors.IOError;
	import flash.utils.IDataInput;

	use namespace com.netease.protobuf.used_by_generated_code;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class MessageVO extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ACTION:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.engine.message.MessageVO.action", "action", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var action$field:int;

		private var hasField$0:uint = 0;
		
		public function MessageVO()
		{
			
		}

		public function clearAction():void {
			hasField$0 &= 0xfffffffe;
			action$field = new int();
		}

		public function get hasAction():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set action(value:int):void {
			hasField$0 |= 0x1;
			action$field = value;
		}

		public function get action():int {
			return action$field;
		}

		/**
		 *  @private
		 */
		public static const PHASE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.engine.message.MessageVO.phase", "phase", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var phase$field:int;

		public function clearPhase():void {
			hasField$0 &= 0xfffffffd;
			phase$field = new int();
		}

		public function get hasPhase():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set phase(value:int):void {
			hasField$0 |= 0x2;
			phase$field = value;
		}

		public function get phase():int {
			return phase$field;
		}

		/**
		 *  @private
		 */
		public static const DATA:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.engine.message.MessageVO.data", "data", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return ParamVO; });

		private var data$field:ParamVO;

		public function clearData():void {
			data$field = null;
		}

		public function get hasData():Boolean {
			return data$field != null;
		}

		public function set data(value:ParamVO):void {
			data$field = value;
		}

		public function get data():ParamVO {
			return data$field;
		}

		/**
		 *  @private
		 */
		public static const SENDAT:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.engine.message.MessageVO.sendAt", "sendAt", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sendAt$field:Int64;

		public function clearSendAt():void {
			sendAt$field = null;
		}

		public function get hasSendAt():Boolean {
			return sendAt$field != null;
		}

		public function set sendAt(value:Int64):void {
			sendAt$field = value;
		}

		public function get sendAt():Int64 {
			return sendAt$field;
		}

		/**
		 *  @private
		 */
		public static const FUTUREID:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.engine.message.MessageVO.futureId", "futureId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var futureId$field:Int64;

		public function clearFutureId():void {
			futureId$field = null;
		}

		public function get hasFutureId():Boolean {
			return futureId$field != null;
		}

		public function set futureId(value:Int64):void {
			futureId$field = value;
		}

		public function get futureId():Int64 {
			return futureId$field;
		}

		/**
		 *  @private
		 */
		public static const CLIENTNUMID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.engine.message.MessageVO.clientNumId", "clientNumId", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var clientNumId$field:String;

		public function clearClientNumId():void {
			clientNumId$field = null;
		}

		public function get hasClientNumId():Boolean {
			return clientNumId$field != null;
		}

		public function set clientNumId(value:String):void {
			clientNumId$field = value;
		}

		public function get clientNumId():String {
			return clientNumId$field;
		}

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.engine.message.MessageVO.name", "name", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var name$field:String;

		public function clearName():void {
			name$field = null;
		}

		public function get hasName():Boolean {
			return name$field != null;
		}

		public function set name(value:String):void {
			name$field = value;
		}

		public function get name():String {
			return name$field;
		}

		/**
		 *  @private
		 */
		public static const ERRORCODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.engine.message.MessageVO.errorCode", "errorCode", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var errorCode$field:int;

		public function clearErrorCode():void {
			hasField$0 &= 0xfffffffb;
			errorCode$field = new int();
		}

		public function get hasErrorCode():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set errorCode(value:int):void {
			hasField$0 |= 0x4;
			errorCode$field = value;
		}

		public function get errorCode():int {
			return errorCode$field;
		}

		/**
		 *  @private
		 */
		public static const ISENCRYPT:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.engine.message.MessageVO.isEncrypt", "isEncrypt", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var isEncrypt$field:Boolean;

		public function clearIsEncrypt():void {
			hasField$0 &= 0xfffffff7;
			isEncrypt$field = new Boolean();
		}

		public function get hasIsEncrypt():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set isEncrypt(value:Boolean):void {
			hasField$0 |= 0x8;
			isEncrypt$field = value;
		}

		public function get isEncrypt():Boolean {
			return isEncrypt$field;
		}

		/**
		 *  @private
		 */
		public static const TOKEN:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.engine.message.MessageVO.token", "token", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var token$field:String;

		public function clearToken():void {
			token$field = null;
		}

		public function get hasToken():Boolean {
			return token$field != null;
		}

		public function set token(value:String):void {
			token$field = value;
		}

		public function get token():String {
			return token$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasAction) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, action$field);
			}
			if (hasPhase) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, phase$field);
			}
			if (hasData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, data$field);
			}
			if (hasSendAt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, sendAt$field);
			}
			if (hasFutureId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, futureId$field);
			}
			if (hasClientNumId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, clientNumId$field);
			}
			if (hasName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, name$field);
			}
			if (hasErrorCode) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, errorCode$field);
			}
			if (hasIsEncrypt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, isEncrypt$field);
			}
			if (hasToken) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, token$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var action$count:uint = 0;
			var phase$count:uint = 0;
			var data$count:uint = 0;
			var sendAt$count:uint = 0;
			var futureId$count:uint = 0;
			var clientNumId$count:uint = 0;
			var name$count:uint = 0;
			var errorCode$count:uint = 0;
			var isEncrypt$count:uint = 0;
			var token$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (action$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.action cannot be set twice.');
					}
					++action$count;
					this.action = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (phase$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.phase cannot be set twice.');
					}
					++phase$count;
					this.phase = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (data$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.data cannot be set twice.');
					}
					++data$count;
					this.data = new ParamVO();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.data);
					break;
				case 4:
					if (sendAt$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.sendAt cannot be set twice.');
					}
					++sendAt$count;
					this.sendAt = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 5:
					if (futureId$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.futureId cannot be set twice.');
					}
					++futureId$count;
					this.futureId = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 6:
					if (clientNumId$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.clientNumId cannot be set twice.');
					}
					++clientNumId$count;
					this.clientNumId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (errorCode$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.errorCode cannot be set twice.');
					}
					++errorCode$count;
					this.errorCode = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (isEncrypt$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.isEncrypt cannot be set twice.');
					}
					++isEncrypt$count;
					this.isEncrypt = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 10:
					if (token$count != 0) {
						throw new flash.errors.IOError('Bad data format: MessageVO.token cannot be set twice.');
					}
					++token$count;
					this.token = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
