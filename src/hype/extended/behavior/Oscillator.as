package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	/**
	 * Oscillates a property with a specifed wave function
	 */
	public class Oscillator extends AbstractBehavior implements IBehavior {
		protected static const TWO_PI:Number = Math.PI * 2;
		
		protected var _prop:String;
		protected var _waveFunction:Function;
		
		protected var _freq:Number;
		protected var _offset:Number;
		protected var _amp:Number;

		protected var _center:Number;		
		protected var _range:Number;
		protected var _step:Number;

		protected var _linkOffset:Boolean = false;
		
		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param prop Target property
		 * @param waveFunction Function that specifies the wave (from -1 to 1)
		 * @param freq Frequency of the wave (in number of steps)
		 * @param min Minimum value of the property
		 * @param max Maximum value of the property
		 * @param offset Initial offset of the wave function
		 * @param linkOffset Whether to link the offset to the frequency
		 */
		public function Oscillator(target:Object, prop:String, waveFunction:Function, freq:Number, min:Number, max:Number, offset:Number=0, linkOffset:Boolean=false) {
			super(target);
			
			_prop = prop;
			_waveFunction = waveFunction;
			_center = (max + min)/2;
			_range = max - min;
			_freq = 1/freq;
			_offset = offset;
			_step = 0;
			_amp = 1;
			_linkOffset = linkOffset;
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
		 * Whether changes to frequency automatically change the offset (defaults to false)
		 */
		public function set linkOffset(value:Boolean):void {
			_linkOffset = value;
		}
		
		public function get linkOffset():Boolean {
			return _linkOffset;
		}
		
		/**
		 * The frequency of the wave
		 */
		public function set frequency(value:Number):void {
			if (_linkOffset) {
				_offset = _offset * (1/_freq)/value;
			}
			
			_freq = 1/value;
		}
		
		public function get frequency():Number {
			return 1/_freq;
		}
		
		/**
		 * The offset of the wave
		 */
		public function set offset(value:Number):void {
			_offset = value;
		}
		
		public function get offset():Number {
			return _offset;
		}		
		
		/**
		 * The amplitude of the wave (where 1.0 is the initial size of the wave)
		 */
		public function set amplitude(value:Number):void {
			_amp = value;
		}
		
		public function get amplitude():Number {
			return _amp;
		}		
		
		/**
		 * Center value of the osciallator
		 */
		public function get center():Number {
			return _center;
		}
		
		public function set center(center:Number):void {
			_center = center;
		}		
		
		/**
		 * @protected
		 */
		public function run(target:Object) : void {
			var value:Number = _step + _offset;
			
			value = value - int(value);
			this.setProperty(_prop, _waveFunction(value) * _range/2 * _amp + _center);		
			
			_step += _freq;
			_step = _step - int(_step);
		}
	}
}
