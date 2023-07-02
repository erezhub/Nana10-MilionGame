package
{
	import com.fxpn.util.Debugging;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class QuestionsEncoder extends Sprite
	{
		public function QuestionsEncoder()
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onDataLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onDataError);
			loader.load(new URLRequest("questions.xml"));
		}
		
		public function onDataLoaded(event:Event):void
		{			
			var xml:XML = new XML(event.target.data);
			trace(encrypt(xml.toString()));
			Debugging.alert("ready");
		}
		
		private function encrypt(txt:String = ''):String
		{
			var data:ByteArray = Hex.toArray(Hex.fromString(txt));
			var key:ByteArray = Hex.toArray(Hex.fromString('A5FC3C04DFD76BD9F2EF1AFAC54E43D0F7486C866B5C1C988B2973953ADDA064CC3F994B505220C1986F3446C1F09CB5DBBCD163631203F6BBDBADF55C724592'));	
			var type:String='des3-ecb';
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(type, key, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt(data);
			return Base64.encodeByteArray(data);
		}
		
		public function onDataError(event:IOErrorEvent):void
		{
			Debugging.alert("error");
		}
	}
}