package hype.extended.rhythm {
	import hype.framework.canvas.ICanvas;
	import hype.framework.rhythm.AbstractRhythm;
	import hype.framework.rhythm.IRhythm;

	/**
	 * Rhythm to continuously apply a set of filters to an ICanvas instance
	 */
	public class FilterCanvasRhythm extends AbstractRhythm implements IRhythm {
		protected var _filterList:Array;
		protected var _canvas:ICanvas;
		
		/**
		 * Constructor
		 * 
		 * @param filterList Array of filters to apply
		 * @param canvas ICanvas instance to apply the filters to
		 */
		public function FilterCanvasRhythm(filterList:Array, canvas:ICanvas) {
			super();
			
			_filterList = filterList;
			_canvas = canvas;
		}
		
		public function run():void {
			var max:uint = _filterList.length;
			var i:uint;
			
			for (i=0; i<max; ++i) {
				_canvas.applyFilter(_filterList[i]);
			}			
		}
	}
}
