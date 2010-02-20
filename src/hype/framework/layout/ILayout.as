package hype.framework.layout {
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Interface all Layouts must implement
	 */
	public interface ILayout {

		/**
		 * Get the next point from the layout and apply it to a DisplayObject
		 * 
		 * @param object The DisplayObject to position
		 */		
		function applyLayout(object:DisplayObject):void 
		
		/**
		 * Get the next point from the layout
		 * 
		 * @return Next point from the layout
		 */
		function getNextPoint():Point;
	}
}
