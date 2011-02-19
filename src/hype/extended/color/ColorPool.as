package hype.extended.color {
	import hype.framework.color.IColorist;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * Colorist that applies colors from a specified pool
	 */
	public class ColorPool implements IColorist {
		
		protected var _colorList:Array;
		protected var _colorTable:Object;
		
		/**
		 * Constructor
		 * 
		 * @param ...rest Colors to be added to the pool (uint)
		 */
		public function ColorPool(...rest) {
			var max:uint = rest["length"];
			var i:uint;
			reset();
			
			for (i=0; i<max; ++i) {
				if (!isNaN(rest[i])) {
					addColor(rest[i]);
				}
			}
		}
		
		/**
		 * Add a color to the pool (prevents duplicates)
		 * 
		 * @param color Color to add to the pool (uint)
		 * @param count Number of times to add this color
		 */
		public function addColor(color:uint, count:uint=1):void {
			var i:uint;
			
			_colorTable[color] = true;
			
			for (i=0; i<count; ++i) {
				_colorList.push(color);
			}
		}
		
		/**
		 * Determine if the pool contains the specified color
		 * 
		 * @param color Color to test
		 * 
		 * @return Whether this pool contains the color
		 */
		public function hasColor(color:uint):Boolean {
			return (_colorTable[color] == true);
		}
		
		/**
		 * Resets the color pool (removes all colors)
		 */
		public function reset():void {
			_colorList = new Array();
			_colorTable = new Object();
		}
		
		/**
		 * Randomly color all children of a sprite which are instances of InteractiveObject (Sprite or MovieClip)
		 * 
		 * @param sprite Sprite that should havee it's children colored
		 */
		public function colorChildren(sprite:Sprite):void {
			var max:uint = sprite.numChildren;
			var i:uint;
			var child:DisplayObject;
			var rgb:uint;
			var numColors:uint = _colorList.length;
			
			for (i=0; i<max; ++i) {
				child = sprite.getChildAt(i);
				if (child is InteractiveObject) {
					rgb = _colorList[Math.floor(Math.random() * numColors)];
					child.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rgb >> 16, rgb >> 8 & 255, rgb & 255, 0);
				}
			}
		}
		
		/**
		 * Get a random color from the color pool
		 * 
		 * @return integer color value
		 */
		public function getColor():uint {
			return _colorList[Math.floor(Math.random() * _colorList.length)];
		}
	}
}
