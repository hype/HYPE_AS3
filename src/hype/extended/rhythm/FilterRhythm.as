package hype.extended.rhythm {
	import hype.framework.rhythm.AbstractRhythm;
	import hype.framework.rhythm.IRhythm;

	import flash.display.BitmapData;
	import flash.geom.Point;

	public class FilterRhythm extends AbstractRhythm implements IRhythm {
		private static var _zeroPoint:Point = new Point(0, 0);
		
		private var _filterList:Array;
		private var _bitmapData:BitmapData;
		
		public function FilterRhythm(filterList:Array, bitmapData:BitmapData) {
			super();
			
			_filterList = filterList;
			_bitmapData = bitmapData;
		}
		
		public function run():void {
			var max:uint = _filterList.length;
			var i:uint;
			
			for (i=0; i<max; ++i) {
				_bitmapData.applyFilter(_bitmapData, _bitmapData.rect, _zeroPoint, _filterList[i]);
			}			
		}
	}
}
