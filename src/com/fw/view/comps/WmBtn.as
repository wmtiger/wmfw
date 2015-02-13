package com.fw.view.comps
{
	import com.engine.utils.ResourceBundleUtil;
	import com.fw.view.comps.style.StyleDef;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 * 此项目中的带文本按钮
	 * @author weism
	 */
	public class WmBtn extends CustomBtn
	{
		protected var _btnLabel:WmLabel;
		protected var _btnLabelStyle:String = StyleDef.FONT_NAME_FZY4;
		
		public function WmBtn()
		{
			super();
			scaleForDownSkin = false;
		}
		
		/**
		 * 创建 SgzBtn
		 * @param parentObj 父类
		 * @param styleName 文理名字
		 * @param label 按钮显示文字
		 * @return
		 */
		public static function createBtn(parent:DisplayObjectContainer, styleName:String = null,
				label:String = "", wid:int = 100, hei:int = 86, x:Number = 0, y:Number = 0):WmBtn
		{
			var btn:WmBtn = create(styleName ? styleName : StyleDef.BTN_DEF);
			parent.addChild(btn);
			btn.label = label;
			btn.width = wid;
			btn.height = hei;
			btn.setCoor(x, y);
			return btn;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			createChildren();
		}
		
		protected function createChildren():void
		{
			initLabel();
		}
		
		override public function set isEnabled(value:Boolean):void
		{
			if (this._isEnabled == value)
			{
				return;
			}
			super.isEnabled = value;
			if (!this._isEnabled)
			{
				this.touchable = false;
				this.currentState = STATE_DISABLED;
				
				if (_btnLabel)
				{
					_btnLabel.alpha = 0.6;
				}
				if (disabledSkin == null)
				{
					var image:Image = this.defaultSkin as Image;
					if (image)
						image.color = StyleDef.STYLE_COlOR_DARK;
				}
			}
			else
			{
				//might be in another state for some reason
				//let's only change to up if needed
				if (super.currentState == STATE_DISABLED)
				{
					this.currentState = STATE_UP;
				}
				this.touchable = true;
				if (_btnLabel)
				{
					_btnLabel.alpha = 1;
					image = this.defaultSkin as Image;
					if (image)
						image.color = StyleDef.STYLE_COlOR_WHITE;
				}
			}
		}
		
		protected function initLabel():void
		{
			_btnLabel = new WmLabel();
			_btnLabel.nameList.add(_btnLabelStyle);
			addChild(_btnLabel);
			if (_isEnabled)
			{
				_btnLabel.alpha = 1;
			}
			else
			{
				_btnLabel.alpha = 0.6;
			}
			
			if (_curStr && _btnLabel && _btnLabel.text != _curStr)
			{
				label = _curStr;
			}
		}
		private var _curStr:String;
		
		override public function set label(value:String):void
		{
			_curStr = value;
			if (_btnLabel)
			{
				_btnLabel.text = _curStr;
				_btnLabel.redraw();
				if (this.actualWidth <= _btnLabel.currentWidth)
				{
					this.actualWidth = _btnLabel.currentWidth + 20;
				}
				
				if (this.actualHeight <= _btnLabel.currentHeight)
				{
					this.actualHeight = _btnLabel.currentHeight + 28;
				}
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}
		
		override protected function scaleSkin():void
		{
			super.scaleSkin();
			_btnLabel.x = (actualWidth - _btnLabel.currentWidth) / 2 + labelOffsetX;
			_btnLabel.y = (actualHeight - _btnLabel.currentHeight) / 2 + labelOffsetY;
		}
		
		override public function get label():String
		{
			if (_btnLabel)
			{
				return _btnLabel.text;
			}
			return null;
		}
		
		/*
		override protected function set currentState(value:String):void
		{
			// 移动设备使用,无需hover态
			if (AppCfg.RUN_TYPE != "pc" && value == Button.STATE_HOVER)
			{
				value = Button.STATE_UP;
			}
			super.currentState = value;
		}
		*/
		
		public function set btnLabelStyle(style:String):void
		{
			_btnLabelStyle = style;
			if (_btnLabel)
				_btnLabel.nameList.add(_btnLabelStyle);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		public static function create(style:String):WmBtn
		{
			var button:WmBtn = new WmBtn();
			button.nameList.add(style);
			return button;
		}
		
		public function setLabel(value:String):WmBtn
		{
			this.label = value;
			return this;
		}
		
		public function setLabelRb(value:String):WmBtn
		{
			this.label = ResourceBundleUtil.getMessage(value);
			return this;
		}
		
		public function triggerThis(listener:Function):WmBtn
		{
			this.removeEventListeners(Event.TRIGGERED);
			this.addEventListener(Event.TRIGGERED, listener);
			return this;
		}
		
		public function setCoor(x:int, y:int):WmBtn
		{
			this.x = x;
			this.y = y;
			return this;
		}
		
		public function showAs(parent:DisplayObjectContainer, index:int = -1):WmBtn
		{
			if (index == -1)
				return parent.addChild(this) as WmBtn;
			else
				return parent.addChildAt(this, index) as WmBtn;
		}
	
	}

}