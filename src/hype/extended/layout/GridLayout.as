package hype.extended.layout {
	import hype.framework.layout.ILayout;

	import flash.geom.Point;

	public class GridLayout implements ILayout {
		var _index:uint;
		var _x:Number;
		var _y:Number;
		var _xSpace:Number;
		var _ySpace:Number;
		var _columns:uint;

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
