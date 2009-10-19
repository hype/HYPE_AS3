package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.sound.SoundAnalyzer;

	/**
	 * @author 
	 */
	public class OctaveTracker extends AbstractBehavior implements IBehavior {
		
		private var _prop:String;
		private var _soundAnalyzer:SoundAnalyzer;
		private var _octave:uint;
		private var _min:Number;
		private var _max:Number;
		
		public function OctaveTracker(target:Object, prop:String, soundAnalyzer:SoundAnalyzer, octave:uint, min:Number, max:Number) {
			super(target);
			
			_prop = prop;
			_soundAnalyzer = soundAnalyzer;
			_octave = octave;
			_min = min;
			_max = max;
			
			setProperty(_prop, _min);
		}
		
		public function run(target:Object):void {
			var value:Number = _soundAnalyzer.getOctave(_octave, _min, _max);

			setProperty(_prop, value);
		}
	}
}
