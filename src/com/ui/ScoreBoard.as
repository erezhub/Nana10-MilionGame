package com.ui
{
	import cinabu.HebrewTextHandling;
	
	import com.events.GameEvent;
	import com.fxpn.util.DisplayUtils;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;
	
	import resources.score.ScoreBoardVisuals;
	
	public class ScoreBoard extends ScoreBoardVisuals
	{
		public function ScoreBoard()
		{
			menuBtn.addEventListener(MouseEvent.CLICK,onMainMenu);
			newGameBtn.addEventListener(MouseEvent.CLICK,onNewGame);
			fbBtn.addEventListener(MouseEvent.CLICK,onFacebook);
			cal_btn.addEventListener(MouseEvent.CLICK,onCal);
		}
		
		private function onNewGame(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.NEW_GAME));
		}
		
		private function onMainMenu(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.MAIN_MENU));
		}
		
		private function onFacebook(event:MouseEvent):void			
		{
			ExternalInterface.call("GameScorePublishInFacebook",parseInt(points.score_txt.text));
			dispatchEvent(new GameEvent(GameEvent.MAIN_MENU));
		}
		
		private function onCal(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("https://www.cal-online.co.il/balancetransfer/Pages/Welcome.aspx/?toolid=B4ACGG&ref=616151&utm_source=nana10&utm_medium=banner&utm_campaign=cal_0%25"),"_blank");
		}
		
		public function set score(value:int):void
		{
			points.score_txt.text = value.toString();
			points.score_txt.autoSize = TextFieldAutoSize.CENTER;
			DisplayUtils.align(pointBg,points,true,false);	
			HebrewTextHandling.actHTML = false;
			if (value > 600)
			{
				header_txt.text = HebrewTextHandling.reverseString("איזה אלופים! תענוג לשחק איתכם",25);
			}
			else if (value > 200)
			{				
				header_txt.text = HebrewTextHandling.reverseString("לא רע! עוד קצת מאמץ ואתם בראש הטבלה!",25);
			}
			else if (value)
			{
				header_txt.text = HebrewTextHandling.reverseString("חלש. תצטרכו להשקיע יותר כדי להיכנס לטבלת האלופים",25);
			}
			else
			{
				header_txt.text = HebrewTextHandling.reverseString("נפלת חזק! כדאי לנסות שוב",25);
			}
		}
	}
}