package example {
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author bhall
	 */
	public class AbstractExample extends Sprite {
		protected var _area:Rectangle;
		
		public function AbstractExample(area:Rectangle) {
			_area = area;
		}
	}
}
