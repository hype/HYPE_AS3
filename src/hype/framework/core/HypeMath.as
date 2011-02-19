package hype.framework.core {

	/**
	 * Utility class full of helpful math-related static properties/methods
	 */
	public final class HypeMath {
		/**
		 * Constant to convert from degrees to radians
		 */
		public static const D2R:Number = Math.PI / 180;
		
		/**
		 * Constant to convert from radians to degrees
		 */
		public static const R2D:Number = 180 / Math.PI;	
		private static var _distanceTable:Object = {rotation:getDegreeDistance};
		
		/**
		 * Register a specific property's distance calculation method
		 * 
		 * @param property Name of the property to register
		 * @param method Function to register to calculate distance
		 */
		public static function registerDistanceProperty(property:String, method:Function):void {
			_distanceTable[property] = method;
		}
		
		/**
		 * Get the distance between two values
		 * 
		 * @param property Name of the property that's being calculated
		 * @param alpha The first value
		 * @param beta The second value
		 * 
		 * @return The distance between alpha and beta
		 */
		public static function getDistance(property:String, alpha:Number, beta:Number):Number {
			if (_distanceTable[property] != null) {
				return _distanceTable[property](alpha, beta) as Number;
			} else {
				return getLinearDistance(alpha, beta);
			}
		}
		
		/**
		 * Get the linear distance between two values
		 * 
		 * @param alpha The first value
		 * @param beta The second value
		 * 
		 * @return The distance between alpha and beta
		 */
		public static function getLinearDistance(alpha:Number, beta:Number):Number {
			return beta - alpha;
		}

		/**
		 * Get the shortest distance between two angles (degrees)
		 * 
		 * @param alpha The first value
		 * @param beta The second value
		 * 
		 * @return The distance between alpha and beta
		 */		
		public static function getDegreeDistance(alpha:Number, beta:Number):Number {
			var delta:Number = D2R * (beta - alpha);
			
			return Math.atan2(Math.sin(delta), Math.cos(delta)) * R2D;			
		}

		/**
		 * Get the shortest distance between two angles (radians)
		 * 
		 * @param alpha The first value
		 * @param beta The second value
		 * 
		 * @return The distance between alpha and beta
		 */			
		public static function getRadianDistance(alpha:Number, beta:Number):Number {
			var delta:Number = (beta - alpha);
			
			return Math.atan2(Math.sin(delta), Math.cos(delta));			
		}		
	}
}
