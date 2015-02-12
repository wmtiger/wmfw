package com.fw.view.comps
{
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	
	import starling.events.Event;

	public class WmTabBar extends TabBar
	{
		public var buttonStyles:Array;
		public var buttons:Array;
//		public var buttonCountNames:Array;
		private var _theName:String;
		
		/**
		 * Constructor.
		 */
		public function WmTabBar()
		{
			_distributeTabSizes = false;
		}
		
		override public function get name():String
		{
			return _theName;
		}
		
		/**
		 * @private
		 */
		override public function set name(value:String):void
		{
			_theName = value;
		}
		
		override protected function refreshTabs(isFactoryInvalid:Boolean):void
		{
			var oldIgnoreSelectionChanges:Boolean = this._ignoreSelectionChanges;
			this._ignoreSelectionChanges = true;
			var oldSelectedIndex:int = this.toggleGroup.selectedIndex;
			this.toggleGroup.removeAllItems();
			var temp:Vector.<ToggleButton> = this.inactiveTabs;
			this.inactiveTabs = this.activeTabs;
			this.activeTabs = temp;
			this.activeTabs.length = 0;
			this._layoutItems.length = 0;
			temp = null;
			if(isFactoryInvalid)
			{
				this.clearInactiveTabs();
			}
			else
			{
				if(this.activeFirstTab)
				{
					this.inactiveTabs.shift();
				}
				this.inactiveFirstTab = this.activeFirstTab;
				
				if(this.activeLastTab)
				{
					this.inactiveTabs.pop();
				}
				this.inactiveLastTab = this.activeLastTab;
			}
			this.activeFirstTab = null;
			this.activeLastTab = null;
			
			const itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			const lastItemIndex:int = itemCount - 1;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				
				if (buttonStyles) {
					tab = createTabByStyle(item, buttonStyles[i]);
				} else {
					if(buttons)
					{
						tab = createTabByButtons(item, buttons[i]);
					}
					else
					{
						if(i == 0)
						{
							var tab:ToggleButton = this.activeFirstTab = this.createFirstTab(item);
						}
						else if(i == lastItemIndex)
						{
							tab = this.activeLastTab = this.createLastTab(item);
						}
						else
						{
							tab = this.createTab(item);
						}
					}
				}
				this.toggleGroup.addItem(tab);
				this.activeTabs.push(tab);
				this._layoutItems[i] = tab;
			}
			
			this.clearInactiveTabs();
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			if(oldSelectedIndex >= 0)
			{
				var newSelectedIndex:int = this.activeTabs.length - 1;
				if(oldSelectedIndex < newSelectedIndex)
				{
					newSelectedIndex = oldSelectedIndex;
				}
				//removing all items from the ToggleGroup clears the selection,
				//so we need to set it back to the old value (or a new clamped
				//value). we want the change event to dispatch only if the old
				//value and the new value don't match.
				this._ignoreSelectionChanges = oldSelectedIndex == newSelectedIndex;
				this.toggleGroup.selectedIndex = newSelectedIndex;
				this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			}
			dispatchEventWith(Event.COMPLETE);
		}
		
		protected function createTabByButtons(item:Object, btn:ToggleButton):ToggleButton
		{
			btn.isToggle = true;
//			btn['data'] = item;
			this.addChild(btn);
			return btn;
		}
		
		public function getAllBtns():Vector.<ToggleButton>
		{
			return activeTabs;
		}
		
		protected function createTabByStyle(item:Object, _styleName:String):ToggleButton
		{
			if (this.inactiveTabs.length == 0)
			{
				var tab:ToggleButton = this._tabFactory();
				if(_styleName)
				{
					tab.nameList.add(_styleName);
				}
				else
				{
					tab.nameList.add(this.tabName);
				}
				
				tab.isToggle = true;
				this.addChild(tab);
			}
			else
			{
				tab = this.inactiveTabs.shift();
			}
			this._tabInitializer(tab, item);
			return tab;
		}
		
		override protected function refreshTabStyles():void
		{
			super.refreshTabStyles();
			/*
			const itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				var button:ToggleButton = this.activeTabs[i];
				
				var theName:String;
				if (buttonCountNames) {
					theName = buttonCountNames[i];
				} else {
					theName = this.name + button.label;
				}
				if (theName) {
					CountTipManager.removeCountSprite(theName, true);
					var countTip:CountTipSprite;
					
					if (item.hasOwnProperty("count"))
					{
						if (int(item.count) > 0)
						{
							countTip = CountTipManager.createCountSprite(theName);
							button.addChild(countTip);
							CountTipManager.updateCount(theName, int(item.count));
						}
					} else if (button.label || buttonCountNames) {
						if (CountTipManager.getCount(theName) != 0) {
							countTip = CountTipManager.createCountSprite(theName);
							button.addChild(countTip);
						}
					}
				}
			}*/
		}
		
		public function refreshCount():void {
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		public override function set dataProvider(value:ListCollection):void{
			super.dataProvider = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}
	}
}