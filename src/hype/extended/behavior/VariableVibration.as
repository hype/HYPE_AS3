package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	/**
	 * Vibrates a property in an unbounded manner
	 */
	public class VariableVibration extends AbstractBehavior implements IBehavior {

		private var _prop:String;
		private var _spring:Number;
		private var _ease:Number;
		private var _vibrationRange:Number; 
		private var _speed:Number;

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
		 * @private
		 */
		public function run(target:Object):void {
			var goal:Number;
			var value:Number = getProperty(_prop);
			
			goal = value + (Math.random() * _vibrationRange) - (_vibrationRange / 2);
			_speed = (_speed * _spring) + HypeMath.getDistance(_prop, value, goal) * _ease;			

			setProperty(_prop, value + _speed);
		}
	}
}
