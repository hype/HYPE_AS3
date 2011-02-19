package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	/**
	 * Vibrates a property in an unbounded manner
	 */
	public class VariableVibration extends AbstractBehavior implements IBehavior {

		protected var _prop:String;
		protected var _spring:Number;
		protected var _ease:Number;
		protected var _vibrationRange:Number; 
		protected var _speed:Number;

		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param prop Target property
		 * @param spring Springiness of the vibration
		 * @param ease Ease of the vibration
		 * @param vibrationRange The amount the vibration can vary (total distance, so 4 would result in a vibration from -2 to 2)
		 */
		public function VariableVibration(target:Object, prop:String, spring:Number, ease:Number, vibrationRange:Number) {
			super(target);
			
			_prop = prop;
			_spring = spring;
			_ease = ease;
			_vibrationRange = vibrationRange;
			_speed = 0;
		}

		/**
		 * @protected
		 */
		public function run(target:Object):void {
			var goal:Number;
			var value:Number = getProperty(_prop);
			
			goal = value + (Math.random() * _vibrationRange) - (_vibrationRange / 2);
			_speed = (_speed * _spring) + HypeMath.getDistance(_prop, value, goal) * _ease;			

			setProperty(_prop, value + _speed);
		}
		
		/**
		 * Springiness of the vibration
		 */
		public function get spring():Number {
			return _spring;
		}
		
		public function set spring(spring:Number):void {
			_spring = spring;
		}
		
		/**
		 * Ease of the vibration
		 */
		public function get ease():Number {
			return _ease;
		}
		
		public function set ease(ease:Number):void {
			_ease = ease;
		}
		
		/**
		 * Range of the vibration
		 */
		public function get vibrationRange():Number {
			return _vibrationRange;
		}
		
		public function set vibrationRange(vibrationRange:Number):void {
			_vibrationRange = vibrationRange;
		}
	}
}
