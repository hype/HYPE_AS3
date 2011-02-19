package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	/**
	 * Vibrates a property with in a set range
	 */
	public class FixedVibration extends AbstractBehavior implements IBehavior {

		protected var _prop:String;
		protected var _spring:Number;
		protected var _ease:Number;
		protected var _min:Number;
		protected var _max:Number;
		protected var _range:Number; 
		protected var _speed:Number;

		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param prop Target property
		 * @param spring Springiness of movement
		 * @param ease Ease of movement
		 * @param min Minimum range of the vibration
		 * @param max Maximum range of the vibration
		 * @param isRelative Whether min and max are absolute or relative to the property's current value
		 */
		public function FixedVibration(target:Object, prop:String, spring:Number, ease:Number, min:Number, max:Number, isRelative:Boolean) {
			super(target);

			if (isRelative) {
				min += getProperty(prop);
				max += getProperty(prop);
			}

			_prop = prop;
			_spring = spring;
			_ease = ease;
			_min = min;
			_max = max;
			_speed = 0;
			_range = Math.abs(_max - _min);
		}

		/**
		 * @protected
		 */
		public function run(target:Object):void {
			var goal:Number;
			var value:Number = getProperty(_prop);
			
			goal = _min + (Math.random() * _range);
			_speed = (_speed * _spring) + HypeMath.getDistance(_prop, value, goal) * _ease;

			setProperty(_prop, value + _speed);
		}
		
		/**
		 * Springiness of the movement
		 */
		public function get spring():Number {
			return _spring;
		}
		
		public function set spring(spring:Number):void {
			_spring = spring;
		}
		
		/**
		 * Ease of the movement
		 */
		public function get ease():Number {
			return _ease;
		}
		
		public function set ease(ease:Number):void {
			_ease = ease;
		}
		
		/**
		 * Minimum range of the vibration
		 */
		public function get min():Number {
			return _min;
		}
		
		public function set min(min:Number):void {
			_min = min;
			_range = Math.abs(_max - _min);
		}
		
		/**
		 * Maximum range of the vibration
		 */	
		public function get max():Number {
			return _max;
		}
		
		public function set max(max:Number):void {
			_max = max;
		}
	}
}


