package com.ui
{
	import com.events.GameEvent;
	
	import flash.events.MouseEvent;
	
	import resources.instructions.BG;

	public class InstructionsScreen extends BG
	{
		public function InstructionsScreen()
		{
			mainMenu.addEventListener(MouseEvent.CLICK,onMainMenu);
			newGame.addEventListener(MouseEvent.CLICK,onNewGame);
		}
		
		private function onNewGame(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.NEW_GAME));
		}
		
		private function onMainMenu(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.MAIN_MENU));
		}
	}
}