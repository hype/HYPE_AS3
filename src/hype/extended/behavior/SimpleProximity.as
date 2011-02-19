package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	import flash.display.Sprite;

	/**
	 * Make a property change in proportion to the distance from the mouse cursor
	 */
	public class SimpleProximity extends AbstractBehavior implements IBehavior {
		protected var _prop:String;
		protected var _min:Number;
		protected var _max:Number;
		protected var _radius:Number;
		protected var _radiusSq:Number;
		protected var _spring:Number;
		protected var _ease:Number;
		protected var _speed:Number;
		protected var _range:Number;

		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param prop Target property
		 * @param spring The springiness of the movement
		 * @param ease The ease of the movement
		 * @param min Base value of the property (when outside of the radius)
		 * @param max Value when the mouse cursor is directly on top of the target
		 * @param radius Radius of the circle in which this behavior will have an affect
		 */
		public function SimpleProximity(target:Object, prop:String, spring:Number, ease:Number, min:Number, max:Number, radius:Number) {
			super(target);

			_prop = prop;
			_min = min;
			_max = max;
			_radius = radius;
			_radiusSq = radius * radius;			
			_spring = spring;
			_ease = ease;
			_speed = 0;
			_range = (_max - _min);
		}

		/**
		 * @protected
		 */
		public function run(target:Object):void {
			var goal:Number;
			var value:Number = getProperty(_prop);
			var sprite:Sprite = target as Sprite;
			var dist:Number = Math.pow(sprite.y - sprite.parent.mouseY, 2) + 
							  Math.pow(sprite.x - sprite.parent.mouseX, 2);	
							  
			if (dist < _radiusSq) {
				goal = (1 - (dist / _radiusSq)) * _range + _min;
			} else {
				goal = _min;
			}
			
			_speed = (_speed * _spring) + (HypeMath.getDistance(_prop, value, goal) * _ease);
			
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
		 * Value when the mouse is directly on top of the target
		 */	
		public function get max():Number {
			return _max;
		}
		
		public function set max(value:Number):void {
			_max = value;
			_range = (_max - _min);
		}
		
		/**
		 * Value when the mouse is fully outside of the radius
		 */
		public function get min():Number {
			return _min;
		}
		
		public function set min(value:Number):void {
			_min = value;
			_range = (_max - _min);
		}
		
		/**
		 * Radius of the interaction area
		 */
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(radius:Number):void {
			_radius = radius;
			_radiusSq = radius * radius;
		}
	}
}
