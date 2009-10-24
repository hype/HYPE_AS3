package hype.framework.layout {
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Abstract base class all Layouts must inherit from
	 */
	public class AbstractLayout {
		
		/**
		 * Get the next point from the layout and apply it to a DisplayObject
		 * 
		 * @param object The DisplayObject to position
		 */
		public function applyLayout(object:DisplayObject):void {
			var pt:Point = ILayout(this).getNextPoint();
			
			object.x = pt.x;
			object.y = pt.y;
		}
		
	}
}
