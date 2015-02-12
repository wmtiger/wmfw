package com.engine.message {
	import com.netease.protobuf.Message;
	import com.netease.protobuf.ReadUtils;
	import com.netease.protobuf.WireType;
	import com.netease.protobuf.WriteUtils;
	import com.netease.protobuf.WritingBuffer;
	import com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.RepeatedFieldDescriptor$TYPE_BYTES;
	import com.netease.protobuf.fieldDescriptors.RepeatedFieldDescriptor$TYPE_INT32;
	import com.netease.protobuf.fieldDescriptors.RepeatedFieldDescriptor$TYPE_INT64;
	import com.netease.protobuf.fieldDescriptors.RepeatedFieldDescriptor$TYPE_STRING;
	
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	use namespace com.netease.protobuf.used_by_generated_code;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ParamVO extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const STRVALUES:RepeatedFieldDescriptor$TYPE_STRING = new RepeatedFieldDescriptor$TYPE_STRING("com.engine.message.ParamVO.strValues", "strValues", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		[ArrayElementType("String")]
		public var strValues:Array = [];

		/**
		 *  @private
		 */
		public static const INTVALUES:RepeatedFieldDescriptor$TYPE_INT32 = new RepeatedFieldDescriptor$TYPE_INT32("com.engine.message.ParamVO.intValues", "intValues", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("int")]
		public var intValues:Array = [];

		/**
		 *  @private
		 */
		public static const LONGVALUES:RepeatedFieldDescriptor$TYPE_INT64 = new RepeatedFieldDescriptor$TYPE_INT64("com.engine.message.ParamVO.longValues", "longValues", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("Int64")]
		public var longValues:Array = [];

		/**
		 *  @private
		 */
		public static const DATA:RepeatedFieldDescriptor$TYPE_BYTES = new RepeatedFieldDescriptor$TYPE_BYTES("com.engine.message.ParamVO.data", "data", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		[ArrayElementType("flash.utils.ByteArray")]
		public var data:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var strValues$index:uint = 0; strValues$index < this.strValues.length; ++strValues$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.strValues[strValues$index]);
			}
			for (var intValues$index:uint = 0; intValues$index < this.intValues.length; ++intValues$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.intValues[intValues$index]);
			}
			for (var longValues$index:uint = 0; longValues$index < this.longValues.length; ++longValues$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, this.longValues[longValues$index]);
			}
			for (var data$index:uint = 0; data$index < this.data.length; ++data$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_BYTES(output, this.data[data$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.strValues.push(com.netease.protobuf.ReadUtils.read$TYPE_STRING(input));
					break;
				case 2:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_INT32, this.intValues);
						break;
					}
					this.intValues.push(com.netease.protobuf.ReadUtils.read$TYPE_INT32(input));
					break;
				case 3:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_INT64, this.longValues);
						break;
					}
					this.longValues.push(com.netease.protobuf.ReadUtils.read$TYPE_INT64(input));
					break;
				case 4:
					this.data.push(com.netease.protobuf.ReadUtils.read$TYPE_BYTES(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
