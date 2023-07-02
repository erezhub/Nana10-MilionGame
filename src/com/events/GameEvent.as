package com.events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const KEY_TYPED:String = "keyTyped";
		public static const MAIN_MENU:String = "mainMenu";
		public static const NEW_GAME:String = "newGame";
		public static const INSTRUCTIONS:String = "instructions";
		public static const ABOUT:String = "about";
		public static const WEB_SITE:String = "webSite";
		public static const PRIZES:String = "prizes";
		public static const FAILED:String = "failed";
		public static const FINISHED_ANIMATION:String = "finishedAnimation";
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GameEvent(type,bubbles,cancelable);
		}
	}
}