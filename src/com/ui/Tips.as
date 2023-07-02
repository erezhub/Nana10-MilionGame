package com.ui
{
	import com.events.GameEvent;
	import com.fxpn.display.ShapeDraw;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import resources.menu.TipsVisuals;
	
	public class Tips extends TipsVisuals
	{
		public function Tips()
		{
			btn.addEventListener(MouseEvent.CLICK,onClick);
			//addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onClick(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.NEW_GAME));
			visible = false;
		}
		
		private function onAddedToStage(event:Event):void 
		{
			var bg:Shape = ShapeDraw.drawSimpleRect(stage.stageWidth,stage.stageHeight,0xaaaaaa,0.5);
			bg.x = -x;
			bg.y = -y;
			addChildAt(bg,0);
		}
	}
}