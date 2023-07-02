package com.ui
{
	import com.events.GameEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import resources.menu.BG;
	
	public class MainMenu extends BG
	{
		public function MainMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);	
		}
		
		private function onAddedToStage(event:Event):void
		{
			newGameBtn.addEventListener(MouseEvent.CLICK,onNewGame);
			newGameBtn.mouseEnabled = false;
			//prizesBtn.addEventListener(MouseEvent.CLICK,onPrizes);
			instructionsBtn.addEventListener(MouseEvent.CLICK,onInstructions);
			aboutBtn.addEventListener(MouseEvent.CLICK,onAbout);
			websiteBtn.addEventListener(MouseEvent.CLICK,onWebsite);
		}
		
		private function onNewGame(evnet:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.NEW_GAME));
		}
		
		private function onPrizes(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.PRIZES));
		}
		
		private function onInstructions(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.INSTRUCTIONS));	
		}
		
		private function onAbout(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.ABOUT));
		}
		
		private function onWebsite(event:MouseEvent):void
		{
			//dispatchEvent(new GameEvent(GameEvent.WEB_SITE));
			navigateToURL(new URLRequest("http://million.nana10.co.il/"),"_blank");
		}
		
		public function enabledNewGameBtn():void
		{
			newGameBtn.mouseEnabled = true;
		}
	}
}