package hype.extended.layout {
	import hype.framework.layout.AbstractLayout;
	import hype.framework.layout.ILayout;

	import flash.geom.Point;

	/**
	 * Layout that produces a simple grid
	 */
	public class GridLayout extends AbstractLayout implements ILayout {
		protected var _index:uint;
		protected var _x:Number;
		protected var _y:Number;
		protected var _xSpace:Number;
		protected var _ySpace:Number;
		protected var _columns:uint;

		/**
		 * Constructor
		 * 
		 * @param x Initial x position of the grid
		 * @param y Initial y position of the grid
		 * @param xSpace Horizontal space between points in the grid
		 * @param ySpace Vertical space between points in the grid
		 * @param columns The number of columns in the grid
		 */
		public function GridLayout(x:Number, y:Number, xSpace:Number, ySpace:Number, columns:uint) {
			_index = 0;
			_x = x;
			_y = y;
			_xSpace = xSpace;
			_ySpace = ySpace;
			_columns = columns;
		}

		public function getNextPoint():Point {
			var pt:Point = new Point();
			var row:uint = Math.floor(_index / _columns);
			var col:uint = _index % _columns;
			
			pt.x = _x + (col * _xSpace);
			pt.y = _y + (row * _ySpace);
			
			++_index;
			
			return pt;
		}
	}
}
