package hype.framework.core {

	public class HypeMath {
		public static const D2R:Number = Math.PI / 180;
		public static const R2D:Number = 180 / Math.PI;	
		private static var _distanceTable:Object = {rotation:getDegreeDistance};
		
		public static function registerDistanceProperty(property:String, method:Function):void {
			_distanceTable[property] = method;
		}
		
		public static function getDistance(property:String, alpha:Number, beta:Number):Number {
			if (_distanceTable[property] != null) {
				return _distanceTable[property](alpha, beta) as Number;
			} else {
				return getLinearDistance(alpha, beta);
			}
		}
		
		public static function getLinearDistance(alpha:Number, beta:Number):Number {
			return beta - alpha;
		}
		
		public static function getDegreeDistance(alpha:Number, beta:Number):Number {
			var delta:Number = D2R * (beta - alpha);
			
			return Math.atan2(Math.sin(delta), Math.cos(delta)) * R2D;			
		}
		
		public static function getRadianDistance(alpha:Number, beta:Number):Number {
			var delta:Number = (beta - alpha);
			
			return Math.atan2(Math.sin(delta), Math.cos(delta));			
		}		
	}
}
