package com.ui.game
{
	import com.events.GameEvent;
	import com.ui.SoundsManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import gs.utils.FrameScriptManager;
	
	import recources.animation.Woman;
	
	import resources.animation.AnimationMask;
	import resources.animation.ManAnimation;
	import resources.sounds.Fall;
	
	public class FallingAnimation extends Sprite
	{
		private var mc:MovieClip;
		private var fallSound:Fall;
		private var soundChannel:SoundChannel;
		
		public function FallingAnimation()
		{
			if (Math.random() > 0.5)
			{
				mc = new Woman();
			}
			else
			{
				mc = new ManAnimation();	
			}
			addChild(mc);
			mc.stop();
			mc.scaleX = mc.scaleY = 0.1;
			mc.mask = new AnimationMask();
			mc.mask.x = -57;
			mc.mask.y = -170;
			addChild(mc.mask);
			var fsm:FrameScriptManager = new FrameScriptManager(mc);
			fsm.setFrameScript("lastFrame",stopOnLastFrame);
			
			//fallSound = new Fall();
		}
		
		private function stopOnLastFrame():void
		{
			mc.stop();
			//soundChannel.stop();			
			dispatchEvent(new GameEvent(GameEvent.FINISHED_ANIMATION));
		}
		
		public function play():void
		{
			mc.gotoAndPlay(2);
			SoundsManager.getInstance().failed();
			//soundChannel = fallSound.play();
		}
		
		public function reset():void
		{
			mc.gotoAndStop(1);
		}
	}
}