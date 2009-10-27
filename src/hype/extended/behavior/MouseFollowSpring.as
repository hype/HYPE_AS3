/**
 *
 *   Joshua Davis
 *   http://www.joshuadavis.com
 *   studio@joshuadavis.com
 *
 *   Sep 25, 2009
 *
 */
 
package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	import flash.display.DisplayObject;

	/**
	 * Makes the target follow the mouse with springiness
	 */
	public class MouseFollowSpring extends AbstractBehavior implements IBehavior {

		private var _spring:Number;
		private var _ease:Number;
		private var _xSpeed:Number;
		private var _ySpeed:Number;

		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param spring Springiness of the movement
		 * @param ease Ease of the movement
		 */
		public function MouseFollowSpring(target:Object, spring:Number, ease:Number) {
			super(target);
			_spring = spring;
			_ease = ease;
			_xSpeed = 0;
			_ySpeed = 0;
		}

		/**
		 * @private
		 */
		public function run(target:Object):void {
			var myTarget:DisplayObject = target as DisplayObject;
			
			_xSpeed = (_xSpeed * _spring) + (myTarget.stage.mouseX - myTarget.x) * _ease;
			_ySpeed = (_ySpeed * _spring) + (myTarget.stage.mouseY - myTarget.y) * _ease;
			myTarget.x += _xSpeed;
			myTarget.y += _ySpeed;
		}
	}
}


