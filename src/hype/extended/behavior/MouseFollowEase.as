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

	public class MouseFollowEase extends AbstractBehavior implements IBehavior {

		private var _ease:Number;

		public function MouseFollowEase(target:Object, ease:Number) {
			super(target);
			_ease = ease;
		}

		public function run(target:Object):void {
			var myTarget:DisplayObject = target as DisplayObject;
			
			myTarget.x += (myTarget.stage.mouseX - myTarget.x) * _ease;
			myTarget.y += (myTarget.stage.mouseY - myTarget.y) * _ease;
		}
	}
}
