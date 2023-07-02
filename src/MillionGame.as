package
{
	import cinabu.HebrewTextHandling;
	
	import com.data.Question;
	import com.events.GameEvent;
	import com.fxpn.util.ContextMenuCreator;
	import com.fxpn.util.Debugging;
	import com.fxpn.util.DisplayUtils;
	import com.fxpn.util.MathUtils;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import com.ui.AboutScreen;
	import com.ui.InstructionsScreen;
	import com.ui.MainMenu;
	import com.ui.PrizesScreen;
	import com.ui.ScoreBoard;
	import com.ui.SoundsManager;
	import com.ui.Tips;
	import com.ui.game.GameBoard;
	import com.ui.game.LetterBox;
	import com.ui.game.PointsBox;
	import com.ui.game.TimerBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import resources.game.BG;
	import resources.game.Send;
	
	[SWF (width="775", height="520", backgroundColor="#342216")]
	public class MillionGame extends Sprite
	{
		private const STAGE_HEIGHT:int = 520;
		private var mainMenu:MainMenu;
		private var gameBoard:GameBoard;
		private var scoreBoard:ScoreBoard;
		private var instructions:InstructionsScreen;
		private var prizes:PrizesScreen;
		private var about:AboutScreen;
		private var tips:Tips;
		private var firstGame:Boolean;
		
		public function MillionGame()
		{
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			firstGame = true;
			contextMenu = ContextMenuCreator.setContextMenu("Nana10 (C) 2010 V 1.4.0");
		}
		
		private function onEnterFrame(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			mainMenu = new MainMenu();
			mainMenu.addEventListener(GameEvent.NEW_GAME,onNewGame);
			mainMenu.addEventListener(GameEvent.INSTRUCTIONS,onInstructions);
			mainMenu.addEventListener(GameEvent.ABOUT,onAbout);
			mainMenu.addEventListener(GameEvent.PRIZES,onPrizes);
			addChild(mainMenu);
			mainMenu.height = STAGE_HEIGHT;
			
			gameBoard = new GameBoard();
			addChild(gameBoard);
			gameBoard.visible = false;
			gameBoard.addEventListener(Event.COMPLETE,onGameBoardReady);
			gameBoard.addEventListener(GameEvent.FAILED,onFailed);
			gameBoard.addEventListener(GameEvent.MAIN_MENU, onMainMenu);
			gameBoard.height = STAGE_HEIGHT
			
			addChild(SoundsManager.getInstance());
			SoundsManager.getInstance().x = 11;
			SoundsManager.getInstance().y = 478;
			SoundsManager.getInstance().startGame();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onCredits);
		}
		
		private function onGameBoardReady(event:Event):void
		{
			mainMenu.enabledNewGameBtn();
		}
		
		private function onNewGame(event:GameEvent):void
		{
			if (firstGame)
			{
				firstGame = false;
				tips = new Tips();
				tips.addEventListener(GameEvent.NEW_GAME,onNewGameTips);
				//DisplayUtils.align(stage,tips,true,false);
				//tips.y = 47;
				addChild(tips);
				addChild(SoundsManager.getInstance());
				SoundsManager.getInstance().displayTips();
			}
			else
			{
				gameBoard.start();
				gameBoard.visible = true;
			}
			if (scoreBoard) scoreBoard.visible = false;
			if (instructions) instructions.visible = false;
			if (about) about.visible = false;
			if (prizes) prizes.visible = false;
		}	
		
		private function onNewGameTips(event:GameEvent):void
		{
			gameBoard.start();
			gameBoard.visible = true;
		}									   
		
		private function onMainMenu(event:GameEvent):void
		{
			if (scoreBoard) scoreBoard.visible = false;
			if (instructions) instructions.visible = false;
			if (about) about.visible = false;
			if (prizes) prizes.visible = false;
			gameBoard.visible = false;
			SoundsManager.getInstance().startGame();
		}
		
		private function onFailed(event:GameEvent):void
		{
			if (scoreBoard == null)
			{
				scoreBoard = new ScoreBoard();
				addChild(scoreBoard);
				addChild(SoundsManager.getInstance());
				scoreBoard.addEventListener(GameEvent.NEW_GAME,onNewGame);
				scoreBoard.addEventListener(GameEvent.MAIN_MENU, onMainMenu);
				scoreBoard.height = STAGE_HEIGHT;
			}
			scoreBoard.visible = true;
			scoreBoard.score = gameBoard.currentScore;
			SoundsManager.getInstance().startGame();
		}
		
		private function onInstructions(event:GameEvent):void
		{
			if (instructions == null)
			{
				instructions = new InstructionsScreen();
				addChild(instructions);
				addChild(SoundsManager.getInstance());
				instructions.addEventListener(GameEvent.NEW_GAME,onNewGame);
				instructions.addEventListener(GameEvent.MAIN_MENU, onMainMenu);	
				instructions.height = STAGE_HEIGHT;
			}
			instructions.visible = true;			
		}
		
		private function onPrizes(event:GameEvent):void
		{
			if (prizes == null)
			{
				prizes = new PrizesScreen();
				addChild(prizes);
				addChild(SoundsManager.getInstance());
				prizes.addEventListener(GameEvent.NEW_GAME, onNewGame);
				prizes.addEventListener(GameEvent.MAIN_MENU,onMainMenu);
				prizes.height = STAGE_HEIGHT;
			}
			prizes.visible = true;
		}
		
		private function onAbout(event:GameEvent):void
		{
			if (about == null)
			{
				about = new AboutScreen();
				addChild(about);
				addChild(SoundsManager.getInstance());
				about.addEventListener(GameEvent.NEW_GAME, onNewGame);
				about.addEventListener(GameEvent.MAIN_MENU,onMainMenu);
				about.height = STAGE_HEIGHT;
			}
			about.visible = true;
		}
		
		// this function is intended for ScorePlug mechanism, which follows the game's score
		private function get score():int
		{
			return gameBoard.currentScore;
		}
		
		private function onCredits(event:KeyboardEvent):void
		{
			if (String.fromCharCode(event.keyCode) == "E" && event.altKey && event.shiftKey && event.ctrlKey)
			{
				Debugging.alert("Created by eRez Huberman\nNana10 2010");
			}
		}
		
		public function facebookSuccess():void
		{
			Debugging.alert("facebook success - temp alert");
		}
	}
}