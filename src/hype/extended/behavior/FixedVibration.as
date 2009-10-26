package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	/**
	 * Vibrates a property with in a set range
	 */
	public class FixedVibration extends AbstractBehavior implements IBehavior {

		private var _prop:String;
		private var _spring:Number;
		private var _ease:Number;
		private var _min:Number;
		private var _range:Number; 
		private var _speed:Number;

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

			_range = max - min;
			_prop = prop;
			_spring = spring;
			_ease = ease;
			_min = min;
			_speed = 0;
		}

		/**
		 * @private
		 */
		public function run(target:Object):void {
			var goal:Number;
			var value:Number = getProperty(_prop);
			
			goal = _min + (Math.random() * _range);
			_speed = (_speed * _spring) + HypeMath.getDistance(_prop, value, goal) * _ease;

			setProperty(_prop, value + _speed);
		}
	}
}


