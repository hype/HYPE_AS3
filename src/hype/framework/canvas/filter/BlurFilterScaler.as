package hype.framework.canvas.filter {
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;

	/**
	 * Scale BlurFilter
	 */
	public class BlurFilterScaler implements IFilterScaler {
		public function scale(filter:BitmapFilter, scale:Number):BitmapFilter {
			var blurFilter:BlurFilter = filter.clone() as BlurFilter;
			
			blurFilter.blurX *= scale;
			blurFilter.blurY *= scale;
			
			return blurFilter;
		}
	}
}
