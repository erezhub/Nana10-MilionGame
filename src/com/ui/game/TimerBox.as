package com.ui.game
{
	import com.fxpn.util.StringUtils;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import gs.utils.FrameScriptManager;
	
	import resources.game.TimerBoxVisuals;
	
	
	public class TimerBox extends TimerBoxVisuals
	{	
		private const TIMEOUT:int = 20000;
		private var timer:Timer;
		private var origTime:int;
		
		public function TimerBox()
		{
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			super.stop();
			var fsm:FrameScriptManager = new FrameScriptManager(this);
			fsm.setFrameScript(12,stopOnLastFrame);
		}
		
		private function onTimer(event:TimerEvent):void
		{
			if (timer_mc == null) return;
			if (getTimer() - origTime < TIMEOUT)
			{
				var currTime:String = StringUtils.turnNumberToTime(TIMEOUT/1000 - (getTimer() - origTime)/1000,false,false,true);
				currTime = currTime.substr(3,5);
				var arr:Array = currTime.split(":");
				timer_mc.seconds_txt.text = arr[0];
				timer_mc.centi_txt.text = arr[1];
			}
			else
			{
				timer_mc.seconds_txt.text = timer_mc.centi_txt.text = "00";
				dispatchEvent(new Event(Event.COMPLETE));
				timer.stop();
			}
		}
		
		public function start():void
		{
			timer_mc.seconds_txt.text = TIMEOUT/1000; 
			timer_mc.centi_txt.text = "00";
			origTime = getTimer();
			timer.reset();
			timer.start();
		}
		
		private function stopOnLastFrame():void
		{
			super.stop();
		}
		
		override public function stop():void
		{
			timer.stop();
		}
		
		public function get answerTime():int
		{
			return parseInt(timer_mc.seconds_txt.text);
		}
	}
}