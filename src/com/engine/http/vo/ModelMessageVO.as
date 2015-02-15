package com.engine.http.vo {
	import com.engine.message.ParamVO;
	import com.netease.protobuf.Message;
	import com.netease.protobuf.ReadUtils;
	import com.netease.protobuf.WireType;
	import com.netease.protobuf.WriteUtils;
	import com.netease.protobuf.WritingBuffer;
	import com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_INT32;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_MESSAGE;
	
	import flash.errors.IOError;
	import flash.utils.IDataInput;

	use namespace com.netease.protobuf.used_by_generated_code;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ModelMessageVO extends com.netease.protobuf.Message {
		
		public function ModelMessageVO(){}
		/**
		 *  @private
		 */
		public static const ACTION:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.engine.http.vo.ModelMessageVO.action", "action", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var action$field:int;

		private var hasField$0:uint = 0;

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
		public static const DATA:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.engine.http.vo.ModelMessageVO.data", "data", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return ParamVO; });

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
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasAction) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, action$field);
			}
			if (hasData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, data$field);
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
			var data$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (action$count != 0) {
						throw new flash.errors.IOError('Bad data format: ModelMessageVO.action cannot be set twice.');
					}
					++action$count;
					this.action = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (data$count != 0) {
						throw new flash.errors.IOError('Bad data format: ModelMessageVO.data cannot be set twice.');
					}
					++data$count;
					this.data = new ParamVO();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.data);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
