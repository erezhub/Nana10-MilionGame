package com.ui
{
	import com.events.GameEvent;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import resources.prizes.BG;
	
	public class PrizesScreen extends BG
	{
		public function PrizesScreen()
		{
			mainMenu.addEventListener(MouseEvent.CLICK,onMainMenu);
			newGame.addEventListener(MouseEvent.CLICK,onNewGame);
			takanon_btn.addEventListener(MouseEvent.CLICK,onTakanon);
		}
		
		private function onNewGame(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.NEW_GAME));
		}
		
		private function onMainMenu(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.MAIN_MENU));
		}
		
		private function onTakanon(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.nana10.co.il/Article/?ArticleID=767251&sid=259"),"_blank");
		}
	}
}