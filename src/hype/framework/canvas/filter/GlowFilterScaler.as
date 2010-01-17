package hype.framework.canvas.filter {
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;

	/**
	 * Scale GlowFilter
	 */
	public class GlowFilterScaler implements IFilterScaler {
		public function scale(filter:BitmapFilter, scale:Number):BitmapFilter {
			var glowFilter:GlowFilter = filter.clone() as GlowFilter;
			
			glowFilter.blurX *= scale;
			glowFilter.blurY *= scale;
			
			return glowFilter;
		}
	}
}
