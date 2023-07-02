package com.data
{
	public class Question
	{
		private var _text:String;
		private var _fullAnswer:String;
		//private var _partialAnswer:String;
		private var _level:int;
		
		public function Question(text:String,fullAnswer:String,level:int)
		{
			_text = text;
			_fullAnswer = fullAnswer;
			//_partialAnswer = partialAnswer;
			_level = level;
		}

		public function get text():String
		{
			return _text;
		}

		public function get fullAnswer():String
		{
			return _fullAnswer;
		}

		/*public function get partialAnswer():String
		{
			return _partialAnswer;
		}*/

		public function get level():int
		{
			return _level;
		}


	}
}