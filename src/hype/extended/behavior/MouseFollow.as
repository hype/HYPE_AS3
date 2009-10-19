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

	public class MouseFollow extends AbstractBehavior implements IBehavior {

		public function MouseFollow(target:Object) {
			super(target);
		}

		public function run(target:Object):void {
			var myTarget:DisplayObject = target as DisplayObject;
			
			myTarget.x = myTarget.stage.mouseX;
			myTarget.y = myTarget.stage.mouseY;
		}
	}
}
