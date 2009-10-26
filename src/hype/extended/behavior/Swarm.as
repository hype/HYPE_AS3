package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;
	import hype.framework.core.HypeMath;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Makes the target object chase after a point
	 */
	public class Swarm extends AbstractBehavior implements IBehavior {
		private var _point:Point;
		private var _speed:Number;
		private var _turnEase:Number;
		private var _twitch:Number;
		
		/**
		 * Constructor
		 * 
		 * @param target Target object (must have x and y properties)
		 * @param point Goal point
		 * @param speed Speed the target can travel
		 * @param turnEase Percentage the target can turn to it's goal
		 * @param twitch Range of a random "twitch" added to each movement
		 */
		public function Swarm(target:Object, point:Point, speed:Number, turnEase:Number, twitch:Number) {
			super(target);
			
			_point = point;
			_speed = speed;
			_turnEase = turnEase;
			_twitch = twitch;
		}
		
		/**
		 * The goal point the target is made to move towards
		 */
		public function get point():Point {
			return _point;
		}
		
		public function set point(value:Point):void {
			_point = value;
		}
		
		/**
		 * @private
		 */
		public function run(target:Object):void {
			var clip:DisplayObject = target as DisplayObject;
			var angle:Number = Math.atan2(_point.y - clip.y, _point.x - clip.x) * HypeMath.R2D;
			var deltaAngle:Number = HypeMath.getDegreeDistance(clip.rotation, angle);
			
			clip.rotation += deltaAngle * _turnEase + (Math.random() * _twitch * 2) - _twitch;
			clip.x += Math.cos(clip.rotation * HypeMath.D2R) * _speed;
			clip.y += Math.sin(clip.rotation * HypeMath.D2R) * _speed;
		}
	}
}
