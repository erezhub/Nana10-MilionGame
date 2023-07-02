package com.ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	
	import resources.MuteBtn;
	import resources.sounds.Correct;
	import resources.sounds.Fall;
	import resources.sounds.Openner;
	import resources.sounds.Timer;
	import resources.sounds.TipsSound;
	
	public class SoundsManager extends Sprite
	{
		private static var _soundsManager:SoundsManager;
		
		private var btn:MuteBtn;
		private var opener:Openner;
		private var openerChannel:SoundChannel;
		private var timer:Timer;
		private var timerChannel:SoundChannel;
		private var fall:Fall;
		private var failedChannel:SoundChannel;
		private var corrent:Correct;
		private var correntChannel:SoundChannel;
		private var tips:TipsSound;
		private var tipsChannel:SoundChannel;
		private var openerPlaying:Boolean;
		private var so:SharedObject;
		
		public function SoundsManager()
		{
			btn = new MuteBtn();
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.CLICK, onToggleMute);
			addChild(btn);
			
			opener = new Openner();
			timer = new Timer();
			fall = new Fall();
			corrent = new Correct();
			tips = new TipsSound();
			soundTransform = new SoundTransform(1);
			
			so = SharedObject.getLocal("million");
			if (so != null)
			{
				if (so.data.v == 0)
				{
					btn.gotoAndStop("off");
					soundTransform = new SoundTransform(0);
				}
			}
		}
		
		public static function getInstance():SoundsManager
		{
			if (_soundsManager == null)
			{
				_soundsManager = new SoundsManager();
			}
			return _soundsManager;
		}
		
		private function onToggleMute(event:MouseEvent):void
		{			
			if (btn.currentLabel == "on")
			{
				btn.gotoAndStop("off");
				soundTransform = new SoundTransform(0);
				so.data.v = 0;
			}
			else
			{
				btn.gotoAndStop("on");
				soundTransform = new SoundTransform(1);
				so.data.v = 1;
			}
			if (openerChannel) openerChannel.soundTransform = soundTransform;
			if (timerChannel) timerChannel.soundTransform = soundTransform;
			if (failedChannel) failedChannel.soundTransform = soundTransform;
			if (correntChannel) correntChannel.soundTransform = soundTransform;
			if (tipsChannel) tipsChannel.soundTransform = soundTransform;
		}
		
		public function startGame():void
		{			
			if (!openerPlaying)
			{
				openerChannel = opener.play(0,int.MAX_VALUE);
			}
			if (openerChannel) openerChannel.soundTransform = soundTransform;
			openerPlaying = true;
			if (timerChannel) timerChannel.stop();
		}
		
		public function startTimer(firstQuestion:Boolean):void
		{
			if (openerChannel) openerChannel.stop();			
			openerPlaying = false;
			if (timerChannel != null) timerChannel.stop();
			timerChannel = timer.play(firstQuestion ? 0 : 500);
			if (timerChannel) timerChannel.soundTransform = soundTransform;
			if (tipsChannel) tipsChannel.stop();
		}
		
		public function failed():void
		{
			failedChannel = fall.play();
			if (failedChannel) failedChannel.soundTransform = soundTransform;
		}
		
		public function correntAnswer():void
		{
			correntChannel = corrent.play();
			if (correntChannel) correntChannel.soundTransform = soundTransform;
		}
		
		public function displayTips():void
		{
			tipsChannel = tips.play();
			if (tipsChannel) tipsChannel.soundTransform = soundTransform;
			if (openerChannel) openerChannel.stop();
			openerPlaying = false;
		}
	}
}