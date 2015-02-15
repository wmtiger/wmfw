package com.engine.http.vo{
	import com.netease.protobuf.Message;
	import com.netease.protobuf.ReadUtils;
	import com.netease.protobuf.WireType;
	import com.netease.protobuf.WriteUtils;
	import com.netease.protobuf.WritingBuffer;
	import com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_BOOL;
	
	import flash.errors.IOError;
	import flash.utils.IDataInput;

	use namespace com.netease.protobuf.used_by_generated_code;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class BoolVO extends com.netease.protobuf.Message {
		
		public function BoolVO(){}
		/**
		 *  @private
		 */
		public static const VALUE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.engine.http.vo.BoolVO.value", "value", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var value$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearValue():void {
			hasField$0 &= 0xfffffffe;
			value$field = new Boolean();
		}

		public function get hasValue():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set value(value:Boolean):void {
			hasField$0 |= 0x1;
			value$field = value;
		}

		public function get value():Boolean {
			return value$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, value$field);
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
						throw new flash.errors.IOError('Bad data format: BoolVO.value cannot be set twice.');
					}
					++value$count;
					this.value = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
