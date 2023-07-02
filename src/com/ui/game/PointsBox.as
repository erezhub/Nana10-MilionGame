package com.ui.game
{	
	import flash.display.MovieClip;
	
	import gs.utils.FrameScriptManager;
	
	import mx.events.MoveEvent;
	
	import resources.game.PointsBoxVisuals;
	
	public class PointsBox extends PointsBoxVisuals
	{
		private var _currentScore:int;
		private var maxFrame:int = 10;
		
		public function PointsBox()
		{
			super();
			stop();
			var fsm:FrameScriptManager = new FrameScriptManager(this);
			fsm.setFrameScript(12,stopOnLastFrame);
			reset();
		}
				
		private function stopOnLastFrame():void
		{
			stop();
			reset();
		}
		
		public function updateScore(points:int):void
		{		
			points = Math.min(points,19) + 10;
			var one:int = points % 10;
			var ten:int = points / 10;
			var	nextFrame:int = container.p1.currentFrame - 1  + one;
			if (nextFrame < maxFrame)
			{
				container.p1.gotoAndStop(nextFrame + 1);
			}
			else
			{
				container.p1.gotoAndStop(nextFrame - maxFrame + 1);
				if (advance(container.p10))
				{
					if (advance(container.p100))
					{
						if (advance(container.p1000))
						{
							if (advance(container.p10000))
							{
								reset();
							}
						}
					}
				}					
			}
			
			nextFrame = container.p10.currentFrame - 1  + ten;
			if (nextFrame < maxFrame)
			{
				container.p10.visible = true;
				container.p10.gotoAndStop(nextFrame + 1);
				align();
			}
			else
			{
				container.p10.gotoAndStop(nextFrame - maxFrame + 1);
				if (advance(container.p100))
				{
					if (advance(container.p1000))
					{
						if (advance(container.p10000))
						{
							reset();
						}
					}
				}
			}
			centerPoints();
			//_currentScore+=points + 10;
			//points_txt.text = String(_currentScore);
		}
		
		private function advance(p:MovieClip):Boolean
		{
			var advanced:Boolean;
			p.visible = true;
			if (p.currentFrame < maxFrame)
			{
				p.nextFrame();
				advanced = false;
			}
			else
			{
				p.gotoAndStop(1);
				advanced = true;
			}
			align();
			return advanced;
		}
		
		public function get currentScore():int
		{			
			return getBoxPoints(container.p1,1) + getBoxPoints(container.p10,10) + getBoxPoints(container.p100,100) + getBoxPoints(container.p1000,1000) + getBoxPoints(container.p10000,10000);
		}
		
		private function getBoxPoints(p:MovieClip,facotr:int):int
		{
			if (p.visible == false || p.currentFrame == 1)
			{
				return 0;				
			}
			else
			{
				return (p.currentFrame - 1)*facotr;
			}
		}

		private function align():void
		{
			var ps:Array = [container.p10000,container.p1000,container.p100,container.p10,container.p1];
			var first:Boolean = true;
			for (var i:int = 0; i < ps.length; i++)
			{
				if (ps[i].visible)
				{
					if (first)
					{
						first = false;
						ps[i].x = 0;
					}
					else
					{
						ps[i].x = ps[i-1].x + ps[i-1].width - 1;
					}
				}
			}
		}
		
		private function get pointsWidth():Number
		{
			var w:Number = container.p1.width;
			if (container.p10.visible) 
			{
				w+=container.p10.width - 2;
				if (container.p100.visible)
				{
					w+=container.p100.width - 2;
					if (container.p1000.visible)
					{
						w+=container.p1000.width - 2;
						if (container.p10000.visible)
						{
							w+=container.p10000.width - 2;
						}
					}					
				}
			}
			return w;
		}
		
		private function centerPoints():void
		{
			container.x = bg.x + (bg.width - pointsWidth)/2
		}
		
		public function reset():void
		{
			with (container)
			{
				p10.visible = p100.visible = p1000.visible = p10000.visible = false;
				p1.x = 0;
				p1.gotoAndStop(1);
				p10.gotoAndStop(1);
				p100.gotoAndStop(1);
				p1000.gotoAndStop(1);
				p10000.gotoAndStop(1);
			}
			centerPoints();
		}
	}
}