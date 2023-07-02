package com.ui.game
{
	import cinabu.HebrewTextHandling;
	
	import com.adobe.utils.ArrayUtil;
	import com.data.Question;
	import com.events.GameEvent;
	import com.fxpn.util.Debugging;
	import com.fxpn.util.DisplayUtils;
	import com.fxpn.util.MathUtils;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.ArrayUtil;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import com.ui.SoundsManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	import recources.animation.Woman;
	
	import resources.game.BG;
	import resources.game.Send;
	
	public class GameBoard extends BG
	{
		private var lettersContainer:Sprite;
		private var lettersArray:Array;
		private var questions:Array;
		private var easyQuestions:Array;
		private var medQuestion:Array;
		private var hardQuestion:Array;
		private var origEasyQuestions:Array;
		private var origMedQuestions:Array;
		private var origHardQuestions:Array;
		private var currLevel:int;
		private var currQuestion:int;
		private var currLetterBox:LetterBox;
		private var sendBtn:Send;
		private var timerBox:TimerBox;
		private var pointsBox:PointsBox;
		private var retryRimter:Timer;
		private var animation:FallingAnimation;
		private var canSend:Boolean;
		private var previouslyAnswered:int;
		
		public function GameBoard()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			retryRimter = new Timer(500,1);
			
			currQuestion = 0;
		}
		
		private function onAddedToStage(event:Event):void
		{
			lettersContainer = new Sprite();
			lettersContainer.y = 168;//185;
			addChild(lettersContainer);
			
			timerBox = new TimerBox();
			timerBox.x = 499;//614; 
			timerBox.y = 236;////255;
			timerBox.addEventListener(Event.COMPLETE,onTimerComplete);
			addChild(timerBox);
			
			pointsBox = new PointsBox();
			pointsBox.x = 163;//69;
			pointsBox.y = 235;//254;
			addChild(pointsBox);
			
			sendBtn = new Send();
			sendBtn.addEventListener(MouseEvent.CLICK, onSend);
			sendBtn.x = 320;//324;
			sendBtn.y = 237;
			addChild(sendBtn);
			
			animation = new FallingAnimation();
			animation.x = 388;//392;
			animation.y = 466;//480;
			addChild(animation);
			animation.addEventListener(GameEvent.FINISHED_ANIMATION,onAnimationFinished);
			
			mainMenu.addEventListener(MouseEvent.CLICK,onMainMenu);
			
			loadData();
			
			stage.addEventListener(KeyboardEvent.KEY_UP,onEnter);
		}
		
		private function loadData():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onDataLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onDataError);
			var dataURL:String;
			if (loaderInfo.url.indexOf("http") == -1 || loaderInfo.url.indexOf("erezh") != -1)
			{
				dataURL = "data.txt";	
			}
			else 
			{
				dataURL = "http://f.nanafiles.co.il/sitefiles/Games/score/MillionGame/data.txt";
			}
			urlLoader.load(new URLRequest(dataURL));
		}
		
		private function onDataLoaded(event:Event):void
		{
			easyQuestions = [];
			hardQuestion = [];
			medQuestion = [];
			origEasyQuestions = [];
			origHardQuestions = [];
			origMedQuestions = [];
			questions = [easyQuestions,medQuestion,hardQuestion];
			var data:XML = new XML(decrypt(event.target.data));
			for each (var questionData:XML in data.question)
			{
				if (questionData.@answer.toString().length > 19) continue;
				var question:Question = new Question(questionData.@question,questionData.@answer,questionData.@level);
				switch (question.level)
				{
					case 1:
						easyQuestions.push(question);
						origEasyQuestions.push(question);
						break;
					case 2:
						medQuestion.push(question);
						origMedQuestions.push(question);
						break;
					case 3:
						hardQuestion.push(question);
						origHardQuestions.push(question);
						break;
				}
				//questions.push();
			}
			dispatchEvent(new Event(Event.COMPLETE));
			//startBtn.enabled = true;
		}
		
		private function onDataError(event:IOErrorEvent):void
		{
			Debugging.alert("error loading data");
		}
		
		private function decrypt(txt:String = ''):String
		{
			var key:ByteArray = Hex.toArray(Hex.fromString('A5FC3C04DFD76BD9F2EF1AFAC54E43D0F7486C866B5C1C988B2973953ADDA064CC3F994B505220C1986F3446C1F09CB5DBBCD163631203F6BBDBADF55C724592'));
			var type:String='des3-ecb';
			var data:ByteArray = Base64.decodeToByteArray(txt);
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(type, key, pad);
			pad.setBlockSize(mode.getBlockSize());
			try
			{
				mode.decrypt(data);
			}
			catch (e:Error)
			{
				trace(e.message);
			}
			return Hex.toString(Hex.fromArray(data));
		}
		
		private function displayQuestion():void
		{	
			clearPreviousQuestion();
			var firstQuestion:Boolean = currLevel == 0 && currQuestion == 0;
			SoundsManager.getInstance().startTimer(firstQuestion);			
			var question:Question = pickQuestion();
			//keysTyped = 0;
			HebrewTextHandling.actHTML = true;
			question_txt.text = HebrewTextHandling.reverseString(question.text,35);
			//DisplayUtils.align(this,question_txt,true,false);

			var correctAnswer:Array = question.fullAnswer.split("");
			var answerLength:int = correctAnswer.length;
			var hintLetters:Array = [];
			for (var j:int = 0; j < answerLength; j++)
			{
				if (correctAnswer[j] == "\"" || correctAnswer[j] == "'")
				{
					hintLetters.push(j);
				}
			}
			var hintIndex:int;
			if ((question.level == 1 && answerLength > 5 && hintLetters.length == 0) || 
				(question.level == 2 && answerLength < 8  && hintLetters.length == 0) || 
				(question.level == 2 && hintLetters.length == 1) ||
				(question.level == 3 && answerLength < 5  && hintLetters.length == 0) ||
				(question.level == 3 && answerLength < 9 && hintLetters.length == 1) ||
				(question.level == 3 && hintLetters.length == 2))
			{
				hintLetters.push(addHintLetter(0,answerLength-1,question.fullAnswer));
			}
			else if (question.level == 2 || 
					(question.level == 3 && answerLength < 9) ||
					(question.level == 3 && hintLetters.length == 1))
			{
				hintLetters.push(addHintLetter(0,answerLength/2,question.fullAnswer));
				hintLetters.push(addHintLetter(answerLength/2+1,answerLength-1,question.fullAnswer));
			}
			else if (question.level == 3)
			{
				hintLetters.push(addHintLetter(0,answerLength/3,question.fullAnswer));
				hintLetters.push(addHintLetter(answerLength/3+1,2*answerLength/3,question.fullAnswer));
				hintLetters.push(addHintLetter(2*answerLength/3+1,answerLength-1,question.fullAnswer));
			}
			var space:Boolean;
			var hidden:Boolean;
			var currX:Number = 0;
			for (var i:int = 0; i < answerLength; i++)
			{
				var currLetter:String = correctAnswer[i];
				if (currLetter == " ")
				{
					space = true;
					continue;
				}
				hidden = false;
				if (hintLetters.length &&  hintLetters[0] == i)
				{
					hintLetters.shift();	
				}
				else					
				{
					hidden = true;
				}
				var letterBox:LetterBox = new LetterBox(currLetter,hidden);
				letterBox.x = currX - letterBox.width - (space ? letterBox.width : 0);
				currX = letterBox.x;
				space = false;
				//if (hidden)
				//{
					lettersArray.push(letterBox);
					letterBox.addEventListener(GameEvent.KEY_TYPED,onKeyTyped);
					letterBox.addEventListener(MouseEvent.MOUSE_DOWN, onLetterClicked);
				//}
				lettersContainer.addChild(letterBox);
			}
			lettersContainer.x = stage.stageWidth - (stage.stageWidth - lettersContainer.width)/2;
			currLetterBox = lettersArray[0];
			currLetterBox.focous = true;
			sendBtn.mouseEnabled = false;
			sendBtn.gotoAndStop("off");
			if (firstQuestion)
			{
				retryRimter.addEventListener(TimerEvent.TIMER_COMPLETE,onDelayTimer);
				retryRimter.start();
			}
			else
			{
				timerBox.start();
			}
		}
		
		private function onDelayTimer(event:TimerEvent):void
		{
			timerBox.start();
			retryRimter.removeEventListener(TimerEvent.TIMER_COMPLETE,onDelayTimer);
			retryRimter.addEventListener(TimerEvent.TIMER_COMPLETE,onReset);
		}
		
		private function addHintLetter(from:int,to:int, question:String):int
		{
			var hintIndex:int = MathUtils.randomInteger(from,to);
			while (question.charAt(hintIndex) == " ")
			{
				hintIndex = MathUtils.randomInteger(from,to);	
			}
			return hintIndex;
		}
		
		private function pickQuestion():Question
		{
			var questionIndex:int = MathUtils.randomInteger(0,questions[currLevel].length-1);
			var question:Question = questions[currLevel][questionIndex];
			(questions[currLevel] as Array).splice(questionIndex,1);
			currQuestion++;
			if (currQuestion == 11 && (currLevel == 0 || currLevel == 1))
			{
				currQuestion = 0;
				currLevel++;
			}
			return question;
		}
		
		private function onKeyTyped(event:GameEvent):void
		{
			/*keysTyped++;
			Debugging.firebug("add",keysTyped,lettersContainer.numChildren);
			if (keysTyped == lettersContainer.numChildren) sendBtn.gotoAndStop("on");*/			
			var currLB:LetterBox = event.target as LetterBox;
			for (var i:int = 0; i < lettersArray.length; i++)
			{
				if (currLB == lettersArray[i])
				{
					if (i == lettersArray.length - 2 && lettersArray[i+1].isFixed == true)
					{
						sendBtn.gotoAndStop("on");
						currLetterBox = lettersArray[i+1];
						currLetterBox.focous = true;
					}
					else if (i == lettersArray.length - 1)
					{
						sendBtn.gotoAndStop("on");	
					}
					else
					{
						currLetterBox = lettersArray[i+1];
						currLetterBox.focous = true;			
					}
					break;
				}
			}
			canSend = true;
			for (i = 0; i < lettersArray.length; i++)
			{
				if (lettersArray[i].isEmpty)
				{
					canSend = false;
					break;
				}
			}
			if (canSend)
			{
				sendBtn.gotoAndStop("on");
			}
			else
			{
				sendBtn.gotoAndStop("off");
			}
		}
		
		private function onLetterClicked(event:MouseEvent):void
		{
			currLetterBox.focous = false;
			currLetterBox = event.currentTarget as LetterBox;
			currLetterBox.focous = true;
		}	
		
		private function clearPreviousQuestion():void
		{
			for (var i:int = lettersContainer.numChildren - 1; i >= 0; i--)
			{
				var letterBox:LetterBox = lettersContainer.getChildAt(i) as LetterBox;
				letterBox.dispose();
				letterBox.removeEventListener(Event.CHANGE,onKeyTyped);
				letterBox.removeEventListener(MouseEvent.MOUSE_DOWN, onLetterClicked);
				lettersContainer.removeChild(letterBox);
			}
			lettersArray = [];
			question_txt.text = "";
		}
		
		private function onEnter(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.ENTER:
					//if (currLetterBox == lettersArray[lettersArray.length-1] && (!currLetterBox.focous || currLetterBox.isFixed)) onSend();
					if (canSend) onSend();
					break;
				case Keyboard.BACKSPACE:
					sendBtn.gotoAndStop("off");
					canSend = false;
					if (currLetterBox == lettersArray[lettersArray.length-1] && !currLetterBox.focous && !currLetterBox.isFixed)
					{
						currLetterBox.focous = true;
						//sendBtn.gotoAndStop("off");
						currLetterBox.clear();
						//keysTyped--;
					}
					else
					{
						if (currLetterBox == lettersArray[lettersArray.length-1] && currLetterBox.isFixed) sendBtn.gotoAndStop("off");
						for (var i:int = lettersArray.length - 1; i> 0; i--)
						{
							if (currLetterBox == lettersArray[i])
							{	
								if (i == 1 && lettersArray[0].isFixed)
								{
									currLetterBox.clear();
									break;
								}
								if (!currLetterBox.isEmpty && !currLetterBox.isFixed)
								{
									currLetterBox.clear();
									//keysTyped--;
									break;
								}
								currLetterBox.focous = false;
								//Debugging.firebug(currLetterBox,lettersArray[i-1]);
								if (lettersArray[i-1].isFixed)
								{
									currLetterBox = lettersArray[i-2];
								}
								else
								{
									currLetterBox = lettersArray[i-1];
								}
								currLetterBox.focous = true;
								currLetterBox.clear();
								//keysTyped--;
								break;
							}
						}
					}
					//Debugging.firebug("delete",keysTyped);
					break;					
			}
		}
		
		public function start():void
		{		
			currLevel = currQuestion = 0;			
			displayQuestion();	
			timerBox.gotoAndPlay(2);
			pointsBox.gotoAndPlay(2);
			pointsBox.reset();
			animation.reset();
			previouslyAnswered+= answeredQuestions;
		}
		
		private function onTimerComplete(event:Event):void
		{
			animation.play();
			canSend = false;
			sendBtn.gotoAndStop("off");
			for (var i:int = 0; i < lettersContainer.numChildren; i++)
			{
				(lettersContainer.getChildAt(i) as LetterBox).error(true);
			}
		}
		
		private function onAnimationFinished(event:GameEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.FAILED));	
		}	
		
		private function onSend(event:MouseEvent = null):void
		{			
			var error:Boolean;
			for (var i:int = 0; i < lettersArray.length; i++)
			{
				if (lettersArray[i].isCorrent == false)
				{
					error = true;
					break;
				}
			}
			if (error)
			{
				for (i = 0; i < lettersContainer.numChildren; i++)
				{
					//lettersArray[i].error();
					(lettersContainer.getChildAt(i) as LetterBox).error();
				}
				retryRimter.reset();
				retryRimter.start();
				sendBtn.mouseEnabled = false;
				sendBtn.gotoAndStop("off");
				//keysTyped = 0;
				//dispatchEvent(new GameEvent(GameEvent.FAILED));
			}
			else
			{
				pointsBox.updateScore(timerBox.answerTime);
				SoundsManager.getInstance().correntAnswer();
				if (questions[currLevel].length)
				{
					displayQuestion();
				}
				/*else 
				{
					if (currLevel == 0)
					{
						questions[currLevel] = com.adobe.utils.ArrayUtil.copyArray(origEasyQuestions);
					}
					else if (currLevel == 1)
					{
						questions[currLevel] = com.adobe.utils.ArrayUtil.copyArray(origMedQuestions);
					}
					else
					{
						questions[currLevel] = com.adobe.utils.ArrayUtil.copyArray(origHardQuestions);
						currLevel = 0;
						if (questions[currLevel].length == 0) questions[currLevel] = com.adobe.utils.ArrayUtil.copyArray(origEasyQuestions);
					}
					displayQuestion();
				}*/
				else
				{
					dispatchEvent(new GameEvent(GameEvent.FAILED));
					timerBox.stop();	
				}
			}
		}
		
		private function onReset(event:TimerEvent):void
		{
			for (var i:int = 0; i < lettersContainer.numChildren; i++)
			{
				var lb:LetterBox = lettersContainer.getChildAt(i) as LetterBox;
				lb.clear();
				lb.focous = false;
			}
			currLetterBox = lettersArray[0];
			currLetterBox.focous = true;
		}
		
		private function onMainMenu(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.MAIN_MENU));
			timerBox.stop();
		}
				
		public function get currentScore():int
		{
			return pointsBox.currentScore;
		}
		
		public function get answeredQuestions():int
		{
			return (origEasyQuestions.length - easyQuestions.length) + 
				   (origMedQuestions.length - medQuestion.length) + 
				   (origHardQuestions.length - hardQuestion.length) - 1 - previouslyAnswered;
		}
	}
}