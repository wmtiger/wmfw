package com.fw.mgr
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class TimerMgr
	{
		public static const TIME_UPDATED:String = "timerUpdated";
		public static const TIME_UPDATED_2S:String = 'timerUpdated_2s';
		public static const TIME_UPDATED_3S:String = 'timerUpdated_3s';
		public static const TIME_UPDATED_5S:String = 'timerUpdated_5s';
		public static const TIME_UPDATED_7S:String = 'timerUpdated_7s';
		
		private static var timer:Timer;
		private static var dispacher:EventDispatcher = new EventDispatcher();
		
		private static var sysTime:Number;
		public static var serverTimeOffset:int; // 与服务器偏移时间
		public static var OPEN_SERV_TIME:Number = 0;//开服时间 时间戳
		
		/**
		 * 更新serverTime
		 */
		public static function set systemTime(value:Number):void
		{
			sysTime = value;
			serverTimeOffset = sysTime - new Date().time;
			if (!timer)
			{
				timer = new Timer(1000, 0);
				timer.addEventListener(TimerEvent.TIMER, onTimer_handler);
				timer.start();
			}
		}
		/**
		 * 
		 * 监听时间器，每隔N秒发布一次
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 	注：第一次发布事件一定是小于等于监听时间的，如设置7秒，第一次事件一定是小于等于7秒的
		 */		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
//			dispacher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			dispacher.addEventListener(type, listener);
		}
		
		public static function hasEventListener(type:String):Boolean
		{
			return dispacher.hasEventListener(type);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
//			dispacher.removeEventListener(type, listener, useCapture);
			dispacher.removeEventListener(type, listener);
		}
		
		/**
		 * 获取Date格式的Server时间
		 */
		public static function getServerDate():Date
		{
			return new Date(sysTime);
		}
		
		/**
		 * 获取系统的日期 
		 * @return 
		 * 
		 */
		public static function getServerDay():int
		{
			return getServerDate().day;
		}
		/**
		 * 获取系统的年
		 * @return 
		 * 
		 */
		public static function getServerYear():int
		{
			return getServerDate().getFullYear();
		}
		
		/**
		 * 获取精确的Server时间
		 * 单位：ms
		 */
		public static function getFixedServerTime():Number
		{
			return new Date().time + serverTimeOffset;
		}
		
		/**
		 * 获取Server时间
		 * 单位：ms
		 */
		public static function getServerTime():Number
		{
			return sysTime;
		}
		
		public static function getCurrentSystemTime():Number
		{
			return new Date().time;
		}
		
		private static function onTimer_handler(e:TimerEvent):void {
			sysTime += 1000;
			
			dispacher.dispatchEvent(new Event(TIME_UPDATED));
			
			if(timer.currentCount%2 == 0){
				dispacher.dispatchEvent(new Event(TIME_UPDATED_2S));
			}
			if(timer.currentCount%3 == 0){
				dispacher.dispatchEvent(new Event(TIME_UPDATED_3S));
			}
			if(timer.currentCount%5 == 0){
				dispacher.dispatchEvent(new Event(TIME_UPDATED_5S));
			}
			if(timer.currentCount%7 == 0){
				dispacher.dispatchEvent(new Event(TIME_UPDATED_7S));
			}
		}
		
		/**
		 * 获取格式化的时间组成由时和分组成
		 * 比如 17：00 返回 1700 
		 * @return 
		 * 
		 */
		public static function getFormatServerHour():int
		{
			var serverDt:Date = getServerDate();
			
			return serverDt.hours*100+ serverDt.minutes;
		}
		
		public static function getNeedhour(hours:Number):int
		{
			return hours * 60 * 60;
		}
		public static function getNeedHourms(hours:Number):Number
		{
			return hours * 60 * 60 * 1000;
		}
		
	}
}