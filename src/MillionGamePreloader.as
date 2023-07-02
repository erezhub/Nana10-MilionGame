package
{
	import com.fxpn.util.ContextMenuCreator;
	import com.fxpn.util.Debugging;
	import com.fxpn.util.DisplayUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import resources.LoadingAnimation;
	
	[SWF (width="775", height="517", backgroundColor="#ffffff")]
	public class MillionGamePreloader extends Sprite
	{
		private var loadingAnimation:LoadingAnimation;
		private var loader:Loader;
		private var player:MovieClip;
		private var firstTime:Boolean = true;
		
		public function MillionGamePreloader()
		{
			addEventListener(Event.ENTER_FRAME, onInit);
		}
		
		private function onInit(event:Event):void
		{
			//removeEventListener(Event.ENTER_FRAME, onInit);
			if (firstTime)
			{
				firstTime = false;
				contextMenu = ContextMenuCreator.setContextMenu("Nana10 (C) 2010");
				
				// add the loading animation to the stage
				loadingAnimation = new LoadingAnimation();
				addChild(loadingAnimation);
				DisplayUtils.align(stage,loadingAnimation);
				
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
				loader.load(new URLRequest("MillionGame.swf"));
			}
			else if (player && player.gameBoard)
			{
				trace(player.score);
			}
			
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			loadingAnimation.progress_txt.text = Math.round(100 * event.bytesLoaded / event.bytesTotal) + "%";
		}
		
		private function onLoaded(event:Event):void
		{
			player = event.target.content as MovieClip;//DisplayObject;
			addChild(player);
			removeChild(loadingAnimation);
		}
		
		private function onError(event:IOErrorEvent):void
		{
			Debugging.alert("שגיאה בטעינת המשחק");
			Debugging.firebug(event.text);
		}
	}
}