package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	/**
	 * @author bhall
	 */
	public class Osscillator extends AbstractBehavior implements IBehavior {
		private var _prop:String;
		private var _freq:Number;
		private var _min:Number;
		private var _max:Number;
		private var _offset:Number;
		private var _value:Number;
		
		public function Osscillator(target:Object, prop:String, freq:Number, min:Number, max:Number, offset:Number=0) {
			super(target);
			
			_prop = prop;
			_min = min;
			_max = max;
			_offset = offset;
			
			frequency = freq;
		}
		
		public function set frequency(freq:Number):void {
			var value:Number = getProperty(_prop);
			
			if (value > _max || value < _min) {
				value = _min;
			}
			
			value = (value - _min) / (_max - _min);
			
			_value = Math.asin(value);
		}
		
		public function get frequency():Number {
			return _freq;
		}	
		
		public function run(target:Object) : void {
			
		}
	}
}
