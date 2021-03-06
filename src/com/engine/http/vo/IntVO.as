package com.engine.http.vo {
	import com.netease.protobuf.Message;
	import com.netease.protobuf.ReadUtils;
	import com.netease.protobuf.WireType;
	import com.netease.protobuf.WriteUtils;
	import com.netease.protobuf.WritingBuffer;
	import com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_INT32;
	
	import flash.errors.IOError;
	import flash.utils.IDataInput;

	use namespace com.netease.protobuf.used_by_generated_code;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class IntVO extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.engine.http.vo.IntVO.value", "value", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var value$field:int;

		private var hasField$0:uint = 0;

		public function clearValue():void {
			hasField$0 &= 0xfffffffe;
			value$field = new int();
		}

		public function get hasValue():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set value(value:int):void {
			hasField$0 |= 0x1;
			value$field = value;
		}

		public function get value():int {
			return value$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, value$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var value$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (value$count != 0) {
						throw new flash.errors.IOError('Bad data format: IntVO.value cannot be set twice.');
					}
					++value$count;
					this.value = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
