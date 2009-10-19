/**
 *
 *   Joshua Davis
 *   http://www.joshuadavis.com
 *   studio@joshuadavis.com
 *
 *   Sep 27, 2009
 *
 */
 
package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	public class VariableVibration extends AbstractBehavior implements IBehavior {

		private var _prop:String;
		private var _spring:Number;
		private var _ease:Number;
		private var _vibrationRange:Number; 
		private var _speed:Number;

		public function VariableVibration(target:Object, prop:String, spring:Number, ease:Number, vibrationRange:Number) {
			super(target);
			
			_prop = prop;
			_spring = spring;
			_ease = ease;
			_vibrationRange = vibrationRange;
			_speed = 0;
		}

		public function run(target:Object):void {
			var goal:Number;
			var value:Number = getProperty(_prop);
			
			goal = value + (Math.random() * _vibrationRange) - (_vibrationRange / 2);
			_speed = (_speed * _spring) + HypeMath.getDistance(_prop, value, goal) * _ease;			

			setProperty(_prop, value + _speed);
		}
	}
}
