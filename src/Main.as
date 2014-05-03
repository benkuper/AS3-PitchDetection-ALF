package  
{
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Main extends Sprite 
	{
		private var m:Microphone;
		
		private var datf:DATF;
		
		public var frameSize:uint = 4096;
		public var hopSize:uint = 2048;
		public var soundBytes:ByteArray;
		
		public function Main():void 
		{
			m = Microphone.getMicrophone();
			m.addEventListener(SampleDataEvent.SAMPLE_DATA, SampleData);
			datf = new DATF(hopSize, false, frameSize, 0);
			
		}
		
		private function SampleData(e:SampleDataEvent):void 
		{
			soundBytes = new ByteArray();
			
			graphics.clear();
			graphics.lineStyle(1, 0);
			var i:int = 0;
			var len:int = e.data.bytesAvailable / 4; //float is 4 bytes
			
			while(e.data.bytesAvailable)     { 
				var sample:Number = e.data.readFloat(); 
				soundBytes.writeFloat(sample); 
				graphics.moveTo(i * stage.stageWidth / len, stage.stageHeight / 2);
				graphics.lineTo(i * stage.stageWidth / len, stage.stageHeight / 2 + sample * 100);
				i++;
			} 
			
			
			soundBytes.position = 0;
			datf.resetAll();
			datf.setFrame(soundBytes, "float");
			
			var pitch:Number = datf.getPitch();
			var volume:Number = datf.getIntensity();
			
			if (volume < 50) pitch = 0;
			
			graphics.beginFill(0xff0000);
			graphics.drawCircle(pitch, stage.stageHeight / 4, 10);
			graphics.drawRect(10, 10, volume, 10);
		}
		
	}
	
}