package hype.framework.layout {
	import flash.geom.Point;

	/**
	 * Interface all Layouts must implement
	 */
	public interface ILayout {
		
		/**
		 * Get the next point from the layout
		 * 
		 * @return Next point from the layout
		 */
		function getNextPoint():Point;
	}
}
