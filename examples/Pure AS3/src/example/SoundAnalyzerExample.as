package example {
	import hype.framework.rhythm.SimpleRhythm;
	import hype.framework.sound.SoundAnalyzer;

	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class SoundAnalyzerExample extends AbstractExample {
		
		private var _soundAnalyzer:SoundAnalyzer;
		private var _trackRhythm:SimpleRhythm;
		private var _sound:Sound;
		
		/*
		 * Note: When run in the Flash standalone player or out of a LOCAL (i.e. not over a server) HTML file
		 * the anlyzation data will either not appear or quickly stop working. This does not occur when the 
		 * SWF is served via a webserver. This has to do with security settings in the Flash Player.
		 */
		public function SoundAnalyzerExample(area:Rectangle) {
			super(area);
			

			_soundAnalyzer = new SoundAnalyzer();
			_soundAnalyzer.start();

			_trackRhythm = new SimpleRhythm(track);
			_trackRhythm.start();

			_sound = new Sound();
			_sound.load(new URLRequest("http://hype.joshuadavis.com/HYPE/examples/SoundAnalyzer/Blevin_Blectum/Gular_Flutter/Foyer_Fire.mp3"));
			_sound.play();			
			
		}
		
		private function track(rhythm:SimpleRhythm):void {
			var freq:Number;
			var i:int;
			
			rhythm;
			
			graphics.clear();
			graphics.lineStyle(0, 0xFF9900);
			graphics.moveTo(64, 300);

			for (i = 0; i < 256; ++i) {
				freq = _soundAnalyzer.getFrequencyIndex(i, 300, 40);
				graphics.lineTo( 64 + (i*2), freq);
			}
		}		
	}
}
