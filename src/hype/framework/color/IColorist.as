package hype.framework.color {
	import flash.display.Sprite;

	/**
	 * Interface that Colorists must implement
	 */
	public interface IColorist {
		
		/**
		 * Color the children of the specified sprite
		 * 
		 * @param sprite Sprite to color
		 */
		function colorChildren(sprite:Sprite):void;
	}
}
