package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	public class SimpleBallistic extends AbstractBehavior implements IBehavior {
		
		private var _prop:String;
		private var _friction:Number;
		private var _gravity:Number;
		private var _angle:Number;
		private var _magnitude:Number;
		private var _xSpeed:Number;
		private var _ySpeed:Number;
		
		public function SimpleBallistic(target:Object, prop:String, friction:Number, gravity:Number) {
			super(target);
			
			_prop = prop;
			_friction = friction;
			_gravity = gravity;
			
			_angle = Math.PI * 2 * Math.random();
			_magnitude = 2 + Math.random() * 2;

			_xSpeed = _magnitude * Math.cos(_angle);
			_ySpeed = _magnitude * Math.sin(_angle);
		}
		
		public function run(target:Object):void {
			var xPos:Number = getProperty("x");
			var yPos:Number = getProperty("y");
			
			_ySpeed += _gravity;
	
			_xSpeed *= _friction;
			_ySpeed *= _friction;
			
			setProperty("x", xPos + _xSpeed);
			setProperty("y", yPos + _ySpeed);
		}
	}
}


