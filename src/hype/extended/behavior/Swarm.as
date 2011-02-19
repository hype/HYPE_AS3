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
		protected var _point:Point;
		protected var _speed:Number;
		protected var _turnEase:Number;
		protected var _twitch:Number;
		
		/**
		 * Constructor
		 * 
		 * @param target Target object (must have x and y properties)
		 * @param point Goal point
		 * @param speed Speed the target can travel
		 * @param turnEase Percentage the target can rotate toward it's goal in a given step
		 * @param twitch Angular range of a random "twitch" added to each movement
		 */
		public function Swarm(target:Object, point:Point, speed:Number, turnEase:Number, twitch:Number) {
			super(target);
			
			_point = point;
			_speed = speed;
			_turnEase = turnEase;
			_twitch = twitch;
		}
		
		/**
		 * @protected
		 */
		public function run(target:Object):void {
			var clip:DisplayObject = target as DisplayObject;
			var angle:Number = Math.atan2(_point.y - clip.y, _point.x - clip.x) * HypeMath.R2D;
			var deltaAngle:Number = HypeMath.getDegreeDistance(clip.rotation, angle);
			
			clip.rotation += deltaAngle * _turnEase + (Math.random() * _twitch * 2) - _twitch;
			clip.x += Math.cos(clip.rotation * HypeMath.D2R) * _speed;
			clip.y += Math.sin(clip.rotation * HypeMath.D2R) * _speed;
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
		 * Speed the target can travel
		 */
		public function get speed():Number {
			return _speed;
		}
		
		public function set speed(speed:Number):void {
			_speed = speed;
		}
		
		/**
		 * Percentage the target can rotate toward it's goal in a given step
		 */
		public function get turnEase():Number {
			return _turnEase;
		}
		
		public function set turnEase(turnEase:Number):void {
			_turnEase = turnEase;
		}
		
		/**
		 * Angular range of a random "twitch" added to each movement
		 */
		public function get twitch():Number {
			return _twitch;
		}
		
		public function set twitch(twitch:Number):void {
			_twitch = twitch;
		}
	}
}
