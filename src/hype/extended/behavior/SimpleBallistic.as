package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	import flash.display.DisplayObject;

	/**
	 * Moves an object in a simplified ballistic path
	 */
	public class SimpleBallistic extends AbstractBehavior implements IBehavior {
		
		protected var _drag:Number;
		protected var _gravityX:Number;
		protected var _gravityY:Number;
		protected var _xSpeed:Number;
		protected var _ySpeed:Number;
		protected var _gravity:Number;
		protected var _gravityAngle:Number;
		
		/**
		 * Constructor
		 * 
		 * @param target Target display object
		 * @param drag The amount of atomospheric drag to add to both axes of movement
		 * @param minForce The minimum amount of force to apply to the object when it is shot
		 * @param maxForce The maximum amount of force to apply to the object when it is shot
		 * @param gravity The amount of gravitational force to apply to the target
		 * @param gravityAngle The angle of gravity (defaults to 90 degrees, straight down)
		 */
		public function SimpleBallistic(target:Object, drag:Number, minForce:Number, maxForce:Number, gravity:Number, gravityAngle:Number=90) {
			var angle:Number = Math.PI * 2 * Math.random();
			var force:Number = minForce + (Math.random() * (maxForce - minForce));
			
			super(target);
			
			_drag = drag;
			
			_gravity = gravity;
			_gravityAngle = gravityAngle;
			
			calculateGravity();

			_xSpeed = force * Math.cos(angle);
			_ySpeed = force * Math.sin(angle);
		}

		public function run(target:Object):void {
			var clip:DisplayObject = target as DisplayObject;
			
			_xSpeed += _gravityX;
			_ySpeed += _gravityY;
	
			_xSpeed *= _drag;
			_ySpeed *= _drag;
			
			clip.x += _xSpeed;
			clip.y += _ySpeed;
		}
		
		/**
		 * The amount of atomospheric drag to add to both axes of movement
		 */
		public function get drag():Number {
			return _drag;
		}
		
		public function set drag(drag:Number):void {
			_drag = drag;
		}
		
		/**
		 * The amount of gravitational force to apply to the target
		 */
		public function get gravity():Number {
			return _gravity;
		}
		
		public function set gravity(gravity:Number):void {
			_gravity = gravity;
			calculateGravity();
		}
		
		/**
		 * The angle of gravity
		 */
		public function get gravityAngle():Number {
			return _gravityAngle;
		}
		
		public function set gravityAngle(gravityAngle:Number):void {
			_gravityAngle = gravityAngle;
			calculateGravity();
		}		
		
		protected function calculateGravity():void {
			_gravityX = Math.cos(_gravityAngle * HypeMath.D2R) * _gravity;
			_gravityY = Math.sin(_gravityAngle * HypeMath.D2R) * _gravity;			
		}
	}
}


