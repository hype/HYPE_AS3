package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	import flash.display.Sprite;

	/**
	 * Make a property change in proportion to the distance from the mouse cursor
	 */
	public class SimpleProximity extends AbstractBehavior implements IBehavior {
		private var _prop:String;
		private var _base:Number;
		private var _max:Number;
		private var _radius:Number;
		private var _radiusSq:Number;
		private var _spring:Number;
		private var _ease:Number;
		private var _speed:Number;
		private var _range:Number;

		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param prop Target property
		 * @param base Base value of the property (when outside of the radius)
		 * @param max Value when the mouse cursor is directly on top of the target
		 * @param radius Radius of the circle in which this behavior will have an affect
		 * @param spring The springiness of the movement
		 * @param ease The ease of the movement
		 */
		public function SimpleProximity(target:Object, prop:String, base:Number, max:Number, radius:Number, spring:Number=0, ease:Number=1) {
			super(target);

			_prop = prop;
			_base = base;
			_max = max;
			_radius = radius;
			_radiusSq = radius * radius;			
			_spring = spring;
			_ease = ease;
			_speed = 0;
			_range = (_max - _base);
		}

		/**
		 * @private
		 */
		public function run(target:Object):void {
			var goal:Number;
			var value:Number = getProperty(_prop);
			var sprite:Sprite = target as Sprite;
			var dist:Number = Math.pow(sprite.y - sprite.parent.mouseY, 2) + 
							  Math.pow(sprite.x - sprite.parent.mouseX, 2);	
							  
			if (dist < _radiusSq) {
				goal = (1 - (dist / _radiusSq)) * _range + _base;
			} else {
				goal = _base;
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
		
		public function set max(max:Number):void {
			_max = max;
			_range = (_max - _base);
		}
		
		/**
		 * Value when the mouse is fully outside of the radius
		 */
		public function get base():Number {
			return _base;
		}
		
		public function set base(base:Number):void {
			_base = base;
			_range = (_max - _base);
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
