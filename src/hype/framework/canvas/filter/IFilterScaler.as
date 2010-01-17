package hype.framework.canvas.filter {
	import flash.filters.BitmapFilter;

	/**
	 * Interface for filter scalers
	 */
	public interface IFilterScaler {
		/*
		 * Scale a filter
		 * 
		 * @param filter BitmapFilter
		 * @param scale Amount to scale
		 */	
		function scale(filter:BitmapFilter, scale:Number):BitmapFilter;
	}
}
