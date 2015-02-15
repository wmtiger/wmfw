package com.fw.view.comps
{
	import com.fw.view.comps.style.StyleDef;
	
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import feathers.core.FeathersControl;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class WmLabel extends FeathersControl
	{
		// the name container with the registered bitmap fonts
		private static const BITMAP_FONT_DATA_NAME:String = "starling.display.TextField.BitmapFonts";
		private static const DEFAULT_FONT_SCALE:Number = 0.3;
		
		private var mFontSize:Number;
		private var mColor:uint;
		private var mText:String;
		private var mFontName:String;
		private var mLeading:Number;
		private var mHAlign:String;
		private var mVAlign:String;
		private var mBold:Boolean;
		private var mItalic:Boolean;
		private var mUnderline:Boolean;
		private var mAutoScale:Boolean;
		private var mAutoSize:String;
		private var mKerning:Boolean;
		private var mNativeFilters:Array;
		private var mRequiresRedraw:Boolean;
		private var mIsRenderedText:Boolean;
		private var mTextBounds:Rectangle;
		private var mBatchable:Boolean;
		private var mWordWrap:Boolean;
		private var mBorderColor:uint = 0x000000;
		private var mStyleSheet:StyleSheet;
		private var mHitArea:DisplayObject;
		private var mBorder:DisplayObjectContainer;
		
		private var mImage:Image;
		private var mQuadBatch:QuadBatch;
		private var _autoWidth:Boolean;
		private var _autoHeight:Boolean;
		private var _isHtml:Boolean;
		private var _quality:int;
		private var _defColor:uint = 0x3E0F00;
		// this object will be used for text rendering
		private static var sNativeTextField:flash.text.TextField = new flash.text.TextField();
		
		public var maxLabelWidth:int;
		
		/**
		 * 默认字体的偏移值,修改默认字体后统一调整的。
		 */
		public var offsetY:Number = 0;
		
		/** Create a new text field with the given properties. */
		public function WmLabel(width:int = -1, height:int = -1, isHtml:Boolean = false, bold:Boolean = false)
		{
			mText = "";
			mFontSize = 22;
			mColor = _defColor;
			mHAlign = HAlign.CENTER;
			mVAlign = VAlign.CENTER;
			mLeading = 0;
			mBorder = null;
			mKerning = true;
			mWordWrap = true;
			mBold = bold;
			mAutoSize = TextFieldAutoSize.NONE;
			this.fontName = StyleDef.FONT_NAME_FZY4;
			_isHtml = isHtml;
			
			if (width == -1)
			{
				_autoWidth = true;
				width = 10;
			}
			
			if (height == -1)
			{
				_autoHeight = true;
				height = 10;
			}
			mHitArea = new Quad(width, height);
			mHitArea.alpha = 0.0;
			addChild(mHitArea);
			
			addEventListener(Event.FLATTEN, onFlatten);
		}
		
		/**
		 * 创建 WmLabel
		 * @param parentObj 父类
		 * @param styleName 文理名字
		 * @param label 按钮显示文字
		 * @return
		 */
		public static function createWmLabel(parent:DisplayObjectContainer, wid:int = -1, hei:int = -1, x:Number = 0, y:Number = 0,
											text:String = "", color:uint = 0xffffff, filters:Array = null):WmLabel
		{
			var label:WmLabel = new WmLabel();
			parent.addChild(label);
			label.text = text;
			label.width = wid;
			label.height = hei;
			label.x = x;
			label.y = y;
			label.color = color;
			if(filters == null)
				label.filters = [];
			else
				label.filters = filters;
			return label;
		}
		
		public function get quality():int
		{
			return _quality;
		}
		
		/**
		 * 新加属性，品质，与武将及武器兼容
		 * @param value
		 * ['<font color="#FFFFFF" >','</font>'],
		   ['<font color="#33FF00" >','</font>'],
		   ['<font color="#0066ff" >','</font>'],
		   ['<font color="#8855aa" >','</font>'],
		   ['<font color="#ff9900" >','</font>'],
		   ['<font color="#ff0000" >','</font>']
		 */
		public function set quality(value:int):void
		{
			_quality = value;
			switch (_quality)
			{
				case 0: 
					this.color = 0xFFFFFF;
					break;
				case 1: 
					this.color = 0x33FF00;
					break;
				case 2: 
					this.color = 0x0066ff;
					break;
				case 3: 
					this.color = 0x8855aa;
					break;
				case 4: 
					this.color = 0xff9900;
					break;
				case 5: 
					this.color = 0xff0000;
					break;
				
				default: 
				{
					this.color = 0xFFFFFF;
					break;
				}
			}
		}
		
		/**
		 *默认文字颜色
		 * @return
		 *
		 */
		public function get defColor():uint
		{
			return _defColor;
		}
		
		public function set format(val:TextFormat):void
		{
			mColor = int(val.color)
			mFontSize = int(val.size);
			mBold = val.bold;
			mFontName = val.font;
			mLeading = int(val.leading);
			mRequiresRedraw = true;
		}
		
		public function set filters(value:Array):void
		{
			this.nativeFilters = value;
		}
		
		/** Disposes the underlying texture data. */
		public override function dispose():void
		{
			removeEventListener(Event.FLATTEN, onFlatten);
			if (mImage)
				mImage.texture.dispose();
			if (mQuadBatch)
				mQuadBatch.dispose();
			super.dispose();
		}
		
		private function onFlatten():void
		{
			if (mRequiresRedraw)
				redraw();
		}
		
		/** @inheritDoc */
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mRequiresRedraw)
				redraw();
			super.render(support, parentAlpha);
		}
		
		/** Forces the text field to be constructed right away. Normally,
		 *  it will only do so lazily, i.e. before being rendered. */
		public function redraw():void
		{
			if (mRequiresRedraw)
			{
				if (mIsRenderedText)
					createRenderedContents();
				else
					createComposedContents();
				
				updateBorder();
				
				var txtFormat:TextFormat = sNativeTextField ? sNativeTextField.defaultTextFormat : null;
				//由于嵌入的字体基线在低于设备字体的基线所以，当使用设备字体时需要往下偏一点点
				if (sNativeTextField && !sNativeTextField.embedFonts && txtFormat && txtFormat.font == StyleDef.FONT_NAME_FZY4)
				{
					offsetY = Math.round(int(sNativeTextField.defaultTextFormat.size) * DEFAULT_FONT_SCALE);
				}
				else
				{
					offsetY = 0;
				}
				
				if (mImage)
				{
					mImage.y = offsetY;
				}
				
				mRequiresRedraw = false;
			}
		}
		
		// TrueType font rendering
		
		private function createRenderedContents():void
		{
			if (mQuadBatch)
			{
				mQuadBatch.removeFromParent(true);
				mQuadBatch = null;
			}
			
			if (mTextBounds == null)
				mTextBounds = new Rectangle();
			
			var scale:Number = Starling.contentScaleFactor;
			var bitmapData:BitmapData = renderText(scale, mTextBounds);
			var format:String = "BGRA_PACKED" in Context3DTextureFormat ? "bgraPacked4444" : "bgra";
			
			mHitArea.width = bitmapData.width / scale;
			mHitArea.height = bitmapData.height / scale;
			
			var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, scale, format);
			texture.root.onRestore = function():void
			{
				var bitmapData:BitmapData = renderText(scale, mTextBounds)
				texture.root.uploadBitmapData(bitmapData);
				bitmapData.dispose();
			};
			
			bitmapData.dispose();
			
			if (mImage == null)
			{
				mImage = new Image(texture);
				mImage.touchable = false;
				addChild(mImage);
			}
			else
			{
				mImage.texture.dispose();
				mImage.texture = texture;
				mImage.readjustSize();
			}
		}
		
		/** formatText is called immediately before the text is rendered. The intent of formatText
		 *  is to be overridden in a subclass, so that you can provide custom formatting for TextField.
		 *  <code>textField</code> is the flash.text.TextField object that you can specially format;
		 *  <code>textFormat</code> is the default TextFormat for <code>textField</code>.
		 */
		protected function formatText(textField:flash.text.TextField, textFormat:TextFormat):void
		{
		
		}
		
		private function renderText(scale:Number, resultTextBounds:Rectangle):BitmapData
		{
			var width:Number = mHitArea.width * scale;
			var height:Number = mHitArea.height * scale;
			var hAlign:String = mHAlign;
			var vAlign:String = mVAlign;
			
			if (isHorizontalAutoSize)
			{
				if (maxLabelWidth > 0)
				{
					width = maxLabelWidth * Starling.contentScaleFactor;
				}
				else
				{
					width = 2048;
				}
				hAlign = HAlign.LEFT;
			}
			if (isVerticalAutoSize)
			{
				height = 2048;
				vAlign = VAlign.TOP;
			}
			
			var textFormat:TextFormat = new TextFormat(mFontName, mFontSize * scale, mColor, mBold, mItalic, mUnderline, null, null, hAlign, null, null, null, mLeading);
			textFormat.kerning = mKerning;
			sNativeTextField.styleSheet = null;
			sNativeTextField.defaultTextFormat = textFormat;
			sNativeTextField.styleSheet = mStyleSheet;
			
			sNativeTextField.width = width;
			sNativeTextField.height = height;
			sNativeTextField.antiAliasType = AntiAliasType.ADVANCED;
			sNativeTextField.selectable = false;
			sNativeTextField.multiline = true;
			sNativeTextField.wordWrap = mWordWrap;
			
			if (_isHtml)
			{
				sNativeTextField.htmlText = mText;
			}
			else
			{
				sNativeTextField.text = mText;
			}
			sNativeTextField.embedFonts = true;
			sNativeTextField.filters = mNativeFilters;
			
			// we try embedded fonts first, non-embedded fonts are just a fallback
			if (sNativeTextField.textWidth == 0.0 || sNativeTextField.textHeight == 0.0)
				sNativeTextField.embedFonts = false;
			
			formatText(sNativeTextField, textFormat);
			
			if (mAutoScale)
				autoScaleNativeTextField(sNativeTextField);
			
			var textWidth:Number = sNativeTextField.textWidth;
			var textHeight:Number = sNativeTextField.textHeight;
			
			if (isHorizontalAutoSize)
				sNativeTextField.width = width = Math.ceil(textWidth + 6);
			if (isVerticalAutoSize)
				sNativeTextField.height = height = Math.ceil(textHeight + 5);
			var xOffset:Number = 0.0;
			if (hAlign == HAlign.LEFT)
				xOffset = 2; // flash adds a 2 pixel offset
			else if (hAlign == HAlign.CENTER)
				xOffset = (width - textWidth) / 2.0;
			else if (hAlign == HAlign.RIGHT)
				xOffset = width - textWidth - 2;
			
			var yOffset:Number = 0.0;
			if (vAlign == VAlign.TOP)
				yOffset = 2; // flash adds a 2 pixel offset
			else if (vAlign == VAlign.CENTER)
				yOffset = (height - textHeight) / 2.0;
			else if (vAlign == VAlign.BOTTOM)
				yOffset = height - textHeight - 2;
			
			if (height <= 0)
			{
				height = mFontSize * scale;
			}
			
			if (yOffset < 0)
			{
				yOffset = 0;
			}
			
			var bitmapData:BitmapData = new BitmapData(Math.min(2048, width), Math.min(2048, height), true, 0x0);
			var drawMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, int(yOffset) - 2);
			var drawWithQualityFunc:Function = "drawWithQuality" in bitmapData ? bitmapData["drawWithQuality"] : null;
			
			// Beginning with AIR 3.3, we can force a drawing quality. Since "LOW" produces
			// wrong output oftentimes, we force "MEDIUM" if possible.
			
			if (drawWithQualityFunc is Function)
				drawWithQualityFunc.call(bitmapData, sNativeTextField, drawMatrix, null, null, null, false, StageQuality.MEDIUM);
			else
				bitmapData.draw(sNativeTextField, drawMatrix);
			sNativeTextField.text = "";
			
			// update textBounds rectangle
			resultTextBounds.setTo(xOffset / scale, yOffset / scale, textWidth / scale, textHeight / scale);
			
			return bitmapData;
		}
		
		private function autoScaleNativeTextField(textField:flash.text.TextField):void
		{
			var size:Number = Number(textField.defaultTextFormat.size);
			var maxHeight:int = textField.height - 4;
			var maxWidth:int = textField.width - 4;
			
			while (textField.textWidth > maxWidth || textField.textHeight > maxHeight)
			{
				if (size <= 4)
					break;
				
				var format:TextFormat = textField.defaultTextFormat;
				format.size = size--;
				textField.setTextFormat(format);
			}
		}
		
		// bitmap font composition
		
		private function createComposedContents():void
		{
			if (mImage)
			{
				mImage.removeFromParent(true);
				mImage = null;
			}
			
			if (mQuadBatch == null)
			{
				mQuadBatch = new QuadBatch();
				mQuadBatch.touchable = false;
				addChild(mQuadBatch);
			}
			else
				mQuadBatch.reset();
			
			var bitmapFont:BitmapFont = getBitmapFont(mFontName);
			if (bitmapFont == null)
				throw new Error("Bitmap font not registered: " + mFontName);
			
			var width:Number = mHitArea.width;
			var height:Number = mHitArea.height;
			var hAlign:String = mHAlign;
			var vAlign:String = mVAlign;
			
			if (isHorizontalAutoSize)
			{
				width = int.MAX_VALUE;
				hAlign = HAlign.LEFT;
			}
			if (isVerticalAutoSize)
			{
				height = int.MAX_VALUE;
				vAlign = VAlign.TOP;
			}
			
			bitmapFont.fillQuadBatch(mQuadBatch, width, height, mText, mFontSize, mColor, hAlign, vAlign, mAutoScale, mKerning);
			
			mQuadBatch.batchable = mBatchable;
			
			if (mAutoSize != TextFieldAutoSize.NONE)
			{
				mTextBounds = mQuadBatch.getBounds(mQuadBatch, mTextBounds);
				
				if (isHorizontalAutoSize)
					mHitArea.width = mTextBounds.x + mTextBounds.width;
				if (isVerticalAutoSize)
					mHitArea.height = mTextBounds.y + mTextBounds.height;
				
				if (mHitArea.height == 0)
				{
					//trace("0");
				}
			}
			else
			{
				// hit area doesn't change, text bounds can be created on demand
				mTextBounds = null;
			}
		}
		
		private function updateBorder():void
		{
			if (mBorder == null)
				return;
			
			var width:Number = mHitArea.width;
			var height:Number = mHitArea.height;
			
			var topLine:Quad = mBorder.getChildAt(0) as Quad;
			var rightLine:Quad = mBorder.getChildAt(1) as Quad;
			var bottomLine:Quad = mBorder.getChildAt(2) as Quad;
			var leftLine:Quad = mBorder.getChildAt(3) as Quad;
			var centerQuad:Quad = mBorder.getChildAt(4) as Quad;
			
			topLine.width = width;
			topLine.height = 1;
			bottomLine.width = width;
			bottomLine.height = 1;
			leftLine.width = 1;
			leftLine.height = height;
			rightLine.width = 1;
			rightLine.height = height;
			rightLine.x = width - 1;
			bottomLine.y = height - 1;
			centerQuad.x = centerQuad.y = 1;
			centerQuad.width = width - 2;
			centerQuad.height = height - 2;
			centerQuad.color = mBorderColor;
			topLine.color = rightLine.color = bottomLine.color = leftLine.color = mColor;
		}
		
		// properties
		
		private function get isHorizontalAutoSize():Boolean
		{
			return this._autoWidth || mAutoSize == TextFieldAutoSize.HORIZONTAL || mAutoSize == TextFieldAutoSize.BOTH_DIRECTIONS;
		}
		
		private function get isVerticalAutoSize():Boolean
		{
			return this._autoHeight || mAutoSize == TextFieldAutoSize.VERTICAL || mAutoSize == TextFieldAutoSize.BOTH_DIRECTIONS;
		}
		
		/** Returns the bounds of the text within the text field. */
		public function get textBounds():Rectangle
		{
			if (mRequiresRedraw)
				redraw();
			if (mTextBounds == null)
				mTextBounds = mQuadBatch.getBounds(mQuadBatch);
			return mTextBounds.clone();
		}
		
		/** @inheritDoc */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle
		{
			if (mRequiresRedraw)
				redraw();
			return mHitArea.getBounds(targetSpace, resultRect);
		}
		
		/** @inheritDoc */
		public override function set width(value:Number):void
		{
			// different to ordinary display objects, changing the size of the text field should 
			// not change the scaling, but make the texture bigger/smaller, while the size 
			// of the text/font stays the same (this applies to the height, as well).
			if (value == -1)
			{
				_autoWidth = true;
				value = 10;
			}
			else
				_autoWidth = false;
			mHitArea.width = value;
			mRequiresRedraw = true;
		}
		
		public function get currentWidth():Number
		{
			return mHitArea.width;
		}
		
		/** @inheritDoc */
		public override function set height(value:Number):void
		{
			if (value == -1)
			{
				_autoHeight = true;
				value = 10;
			}
			else
				_autoHeight = false;
			mHitArea.height = value;
			mRequiresRedraw = true;
		}
		
		public function get currentHeight():Number
		{
			return mHitArea.height;
		}
		
		/** The displayed text. */
		public function get text():String
		{
			return mText;
		}
		
		public function set text(value:String):void
		{
			if (value == null)
				value = "";
			if (mText != value)
			{
				mText = value;
				mRequiresRedraw = true;
			}
		}
		
		/** The name of the font (true type or bitmap font). */
		public function get fontName():String
		{
			return mFontName;
		}
		
		public function set fontName(value:String):void
		{
			if (mFontName != value)
			{
				if (value == BitmapFont.MINI && bitmapFonts[value] == undefined)
					registerBitmapFont(new BitmapFont());
				
				mFontName = value;
				mRequiresRedraw = true;
				mIsRenderedText = getBitmapFont(value) == null;
			}
		}
		
		/** The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for
		 *  the original size. */
		public function get fontSize():Number
		{
			return mFontSize;
		}
		
		public function set fontSize(value:Number):void
		{
			if (mFontSize != value)
			{
				mFontSize = value;
				mRequiresRedraw = true;
			}
		}
		
		/** The color of the text. For bitmap fonts, use <code>Color.WHITE</code> to use the
		 *  original, untinted color. @default black */
		public function get color():uint
		{
			return mColor;
		}
		
		public function set color(value:uint):void
		{
			if (mColor != value)
			{
				mColor = value;
				mRequiresRedraw = true;
			}
		}
		
		public function set wordWrap(value:Boolean):void
		{
			mWordWrap = value;
			mRequiresRedraw = true;
		}
		
		/** The horizontal alignment of the text. @default center @see starling.utils.HAlign */
		public function get hAlign():String
		{
			return mHAlign;
		}
		
		public function set hAlign(value:String):void
		{
			if (!HAlign.isValid(value))
				throw new ArgumentError("Invalid horizontal align: " + value);
			
			if (mHAlign != value)
			{
				mHAlign = value;
				mRequiresRedraw = true;
			}
		}
		
		/** The vertical alignment of the text. @default center @see starling.utils.VAlign */
		public function get vAlign():String
		{
			return mVAlign;
		}
		
		public function set vAlign(value:String):void
		{
			if (!VAlign.isValid(value))
				throw new ArgumentError("Invalid vertical align: " + value);
			
			if (mVAlign != value)
			{
				mVAlign = value;
				mRequiresRedraw = true;
			}
		}
		
		/** Draws a border around the edges of the text field. Useful for visual debugging.
		 *  @default false */
		public function get border():Boolean
		{
			return mBorder != null;
		}
		
		public function set border(value:Boolean):void
		{
			if (value && mBorder == null)
			{
				mBorder = new Sprite();
				addChild(mBorder);
				
				for (var i:int = 0; i < 5; ++i)
					mBorder.addChild(new Quad(1.0, 1.0));
				
				updateBorder();
			}
			else if (!value && mBorder != null)
			{
				mBorder.removeFromParent(true);
				mBorder = null;
			}
		}
		
		/** Indicates whether the text is bold. @default false */
		public function get bold():Boolean
		{
			return mBold;
		}
		
		public function set bold(value:Boolean):void
		{
			if (mBold != value)
			{
				mBold = value;
				mRequiresRedraw = true;
			}
		}
		
		/** Indicates whether the text is italicized. @default false */
		public function get italic():Boolean
		{
			return mItalic;
		}
		
		public function set italic(value:Boolean):void
		{
			if (mItalic != value)
			{
				mItalic = value;
				mRequiresRedraw = true;
			}
		}
		
		/** Indicates whether the text is underlined. @default false */
		public function get underline():Boolean
		{
			return mUnderline;
		}
		
		public function set underline(value:Boolean):void
		{
			if (mUnderline != value)
			{
				mUnderline = value;
				mRequiresRedraw = true;
			}
		}
		
		/** Indicates whether kerning is enabled. @default true */
		public function get kerning():Boolean
		{
			return mKerning;
		}
		
		public function set kerning(value:Boolean):void
		{
			if (mKerning != value)
			{
				mKerning = value;
				mRequiresRedraw = true;
			}
		}
		
		/** Indicates whether the font size is scaled down so that the complete text fits
		 *  into the text field. @default false */
		public function get autoScale():Boolean
		{
			return mAutoScale;
		}
		
		public function set autoScale(value:Boolean):void
		{
			if (mAutoScale != value)
			{
				mAutoScale = value;
				mRequiresRedraw = true;
			}
		}
		
		/** Specifies the type of auto-sizing the TextField will do.
		 *  Note that any auto-sizing will make auto-scaling useless. Furthermore, it has
		 *  implications on alignment: horizontally auto-sized text will always be left-,
		 *  vertically auto-sized text will always be top-aligned. @default "none" */
		public function get autoSize():String
		{
			return mAutoSize;
		}
		
		public function set autoSize(value:String):void
		{
			if (mAutoSize != value)
			{
				mAutoSize = value;
				mRequiresRedraw = true;
			}
		}
		
		/**
		 * 文本格式设置规则
		 */
		public function get styleSheet():StyleSheet
		{
			return mStyleSheet;
		}
		
		public function set styleSheet(value:StyleSheet):void
		{
			if (mStyleSheet != value)
			{
				mStyleSheet = value;
				mRequiresRedraw = true;
			}
		}
		
		public function set isHtml(html:Boolean):void
		{
			if (_isHtml != html)
			{
				_isHtml = html;
				mRequiresRedraw = true;
			}
		}
		
		public function get isHtml():Boolean
		{
			return _isHtml;
		}
		
		/**
		 *行间距
		 * @return
		 *
		 */
		public function get leading():Number
		{
			return mLeading;
		}
		
		public function set leading(value:Number):void
		{
			if (mLeading != value)
			{
				mLeading = value;
				mRequiresRedraw = true;
			}
		}
		
		/** Indicates if TextField should be batched on rendering. This works only with bitmap
		 *  fonts, and it makes sense only for TextFields with no more than 10-15 characters.
		 *  Otherwise, the CPU costs will exceed any gains you get from avoiding the additional
		 *  draw call. @default false */
		public function get batchable():Boolean
		{
			return mBatchable;
		}
		
		public function set batchable(value:Boolean):void
		{
			mBatchable = value;
			if (mQuadBatch)
				mQuadBatch.batchable = value;
		}
		
		/** The native Flash BitmapFilters to apply to this TextField.
		 *  Only available when using standard (TrueType) fonts! */
		public function get nativeFilters():Array
		{
			return mNativeFilters;
		}
		
		public function set nativeFilters(value:Array):void
		{
			if (!mIsRenderedText)
				throw(new Error("The TextField.nativeFilters property cannot be used on Bitmap fonts."));
			
			mNativeFilters = value.concat();
			mRequiresRedraw = true;
		}
		
		/** Makes a bitmap font available at any TextField in the current stage3D context.
		 *  The font is identified by its <code>name</code> (not case sensitive).
		 *  Per default, the <code>name</code> property of the bitmap font will be used, but you
		 *  can pass a custom name, as well. @returns the name of the font. */
		public static function registerBitmapFont(bitmapFont:BitmapFont, name:String = null):String
		{
			if (name == null)
				name = bitmapFont.name;
			bitmapFonts[name.toLowerCase()] = bitmapFont;
			return name;
		}
		
		/** Unregisters the bitmap font and, optionally, disposes it. */
		public static function unregisterBitmapFont(name:String, dispose:Boolean = true):void
		{
			name = name.toLowerCase();
			
			if (dispose && bitmapFonts[name] != undefined)
				bitmapFonts[name].dispose();
			
			delete bitmapFonts[name];
		}
		
		/** Returns a registered bitmap font (or null, if the font has not been registered).
		 *  The name is not case sensitive. */
		public static function getBitmapFont(name:String):BitmapFont
		{
			return bitmapFonts[name.toLowerCase()];
		}
		
		/** Stores the currently available bitmap fonts. Since a bitmap font will only work
		 *  in one Stage3D context, they are saved in Starling's 'contextData' property. */
		private static function get bitmapFonts():Dictionary
		{
			var fonts:Dictionary = Starling.current.contextData[BITMAP_FONT_DATA_NAME] as Dictionary;
			
			if (fonts == null)
			{
				fonts = new Dictionary();
				Starling.current.contextData[BITMAP_FONT_DATA_NAME] = fonts;
			}
			return fonts;
		}
		
		//以下为创建时的快捷方式，改善代码整洁度。Ctrl+Shit+G查看使用demo。
		public static function create(text:String = ''):WmLabel
		{
			var sglabel:WmLabel = new WmLabel();
			sglabel.text = text;
			return sglabel;
		}
		
		public function setCoor(x:int, y:int):WmLabel
		{
			this.x = x;
			this.y = y;
			return this;
		}
		
		public function addStyle(style:String = null):WmLabel
		{
			nameList.add(style ? style : StyleDef.LABEL_DEF);
			return this;
		}
		
		public function showAs(parent:DisplayObjectContainer):WmLabel
		{
			return parent.addChild(this) as WmLabel;
		}
	
	}
}

