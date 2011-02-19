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
	 * Makes the target follow the mouse with ease
	 */
	public class MouseFollowEase extends AbstractBehavior implements IBehavior {

		protected var _ease:Number;

		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param ease Ease of the movement
		 */
		public function MouseFollowEase(target:Object, ease:Number) {
			super(target);
			_ease = ease;
		}

		/**
		 * @protected
		 */
		public function run(target:Object):void {
			var myTarget:DisplayObject = target as DisplayObject;
			
			myTarget.x += (myTarget.stage.mouseX - myTarget.x) * _ease;
			myTarget.y += (myTarget.stage.mouseY - myTarget.y) * _ease;
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
	}
}
