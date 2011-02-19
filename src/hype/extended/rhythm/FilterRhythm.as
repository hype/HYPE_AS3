package hype.extended.rhythm {
	import hype.framework.rhythm.AbstractRhythm;
	import hype.framework.rhythm.IRhythm;

	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * Rhythm to continuously apply a set of filters to a BitmapData instance
	 */
	public class FilterRhythm extends AbstractRhythm implements IRhythm {
		protected static var _zeroPoint:Point = new Point(0, 0);
		
		protected var _filterList:Array;
		protected var _bitmapData:BitmapData;
		
		/**
		 * Constructor
		 * 
		 * @param filterList Array of filters to apply
		 * @param bitmapData BitmapData instance to apply the filters to
		 */
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
