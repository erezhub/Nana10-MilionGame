package com.ui.game
{
	import com.events.GameEvent;
	import com.fxpn.util.Debugging;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import resources.game.LetterBoxVisuals;
	
	public class LetterBox extends LetterBoxVisuals
	{
		private var _isEmpty:Boolean;
		private var _correntLetter:String;
		private var _isFixed:Boolean;
		
		public function LetterBox(letter:String, hidden:Boolean)
		{
			errorBG.visible = hilightBG.visible = false;
			//_txt.restrict = "-?א-ת'\"0-9";
			_txt.addEventListener(Event.CHANGE, onKeyTyped);
			if (!hidden)
			{
				_txt.text = letter;
				//_txt.type = TextFieldType.DYNAMIC;
				//_txt.selectable = false;
				_isFixed = true;
			}
			_correntLetter = letter;
			/*else
			{				
				_isEmpty = true;
			}*/
		}
		
		private function onKeyTyped(event:Event):void
		{
			if (_isFixed)
			{
				_txt.text = _correntLetter;//_txt.text.charAt(1);
				_txt.maxChars = 1;
			}
			_txt.autoSize = TextFieldAutoSize.CENTER;
			focous = false;
			dispatchEvent(new GameEvent(GameEvent.KEY_TYPED));
			event.stopPropagation();
		}
		
		public function clear():void
		{
			if (_isFixed)
			{
				_txt.text = _correntLetter;
			}
			else
			{
				_txt.text = "";
			}
			errorBG.visible = false;
		}
		
		public function set focous(value:Boolean):void
		{
			hilightBG.visible = value;
			if (value)
			{
				_txt.stage.focus = _txt;
				_txt.type = TextFieldType.INPUT;
				_txt.selectable = true;
				if (_isFixed) _txt.maxChars = 2;
			}
			else
			{
				_txt.stage.focus = null;
				_txt.type = TextFieldType.DYNAMIC;
				_txt.selectable = false;
			}
		}
		
		public function get focous():Boolean
		{
			return hilightBG.visible;
		}
		
		public function get isEmpty():Boolean
		{
			return _txt.length == 0;
		}
		
		public function get isCorrent():Boolean
		{
			return _txt.text == _correntLetter;
		}
		
		public function error(showAnswer:Boolean = false):void
		{
			errorBG.visible = true;
			focous = false;
			if (showAnswer)
			{
				_txt.text = _correntLetter;
			}
		}
		
		public function dispose():void
		{
			_txt.removeEventListener(Event.CHANGE, onKeyTyped);
		}
		
		public function get isFixed():Boolean
		{
			return _isFixed;
		}
		
		override public function toString():String
		{
			return _correntLetter;
		}
	}
}