package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	/**
	 * Oscillates a property with a specifed wave function
	 */
	public class Oscillator extends AbstractBehavior implements IBehavior {
		private static const TWO_PI:Number = Math.PI * 2;
		
		private var _prop:String;
		private var _waveFunction:Function;
		private var _freq:Number;
		private var _freqStep:Number;
		private var _freqGoal:Number;
		private var _min:Number;
		private var _minStep:Number;
		private var _minGoal:Number;
		private var _step:Number;
		private var _amp:Number;
		private var _ampStep:Number;
		private var _ampGoal:Number;
		
		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param prop Target property
		 * @param waveFunction Function that specifies the wave (from -1 to 1)
		 * @param freq Frequency of the wave (in number of steps)
		 * @param min Minimum value of the property
		 * @param max Maximum value of the property
		 * @param start Initial value of the wave function
		 */
		public function Oscillator(target:Object, prop:String, waveFunction:Function, freq:Number, min:Number, max:Number, start:Number=0) {
			super(target);
			
			_prop = prop;
			_waveFunction = waveFunction;
			_minGoal = _min = min;
			_minStep = 0;
			_ampGoal = _amp = max - min;
			_ampStep = 0;
			_freqGoal = _freq = 1/freq;
			_freqStep = 0;
			
			_step = start;
		}
		
		/**
		 * Sine wave function
		 */
		public static function sineWave(step:Number):Number {
			return Math.sin(TWO_PI * step);
		}
		
		/**
		 * Square wave function
		 */
		public static function squareWave(step:Number):Number {
			return step < 0.5 ? 1 : -1;
		}
		
		/**
		 * Triangle wave function
		 */
		public static function triangleWave(step:Number):Number {
			return 1 - 4 * Math.abs(Math.round(step) - step);
		}
		
		/**
		 * Saw wave function
		 */
		public static function sawWave(step:Number):Number {
			return 2 * ( step - Math.round(step));
		}			
		
		/**
		 * Change the frequency of the wave
		 * 
		 * @param freq New frequency
		 * @param steps Number of steps to take to change frequency
		 */
		public function changeFrequency(freq:Number, steps:int=0):void {
			if (steps > 0) {
				_freqGoal = 1/freq;
				_freqStep = (_freqGoal - _freq) / steps;	
			} else {
				_freq = 1/freq;
			}
		}
		
		/**
		 * @private
		 */
		public function run(target:Object) : void {
			this.setProperty(_prop, (_waveFunction(_step) / 2 + 0.5) * _amp + _min);
			
			if (_freqStep != 0) {
				if (Math.abs(_freqGoal - _freq) < 0.001) {
					_freq = _freqGoal;
					_freqStep = 0;
				} else {
					_freq += _freqStep;
				}
			}			
			
			if (_ampStep != 0) {
				if (Math.abs(_ampGoal - _amp) < 0.1) {
					_amp = _ampGoal;
					_ampStep = 0;
				} else {
					_amp += _ampStep;
				}
			}
			
			if (_minStep != 0) {
				if (Math.abs(_minGoal - _min) < 0.1) {
					_min = _minGoal;
					_minStep = 0;
				} else {
					_min += _minStep;
				}
			}			
			
			_step += _freq;
			_step = _step - Math.floor(_step);
		}
	}
}
