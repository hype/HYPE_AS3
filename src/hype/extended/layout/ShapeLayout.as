package hype.extended.layout {
	import hype.framework.layout.AbstractLayout;
	import hype.framework.layout.ILayout;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ShapeLayout extends AbstractLayout implements ILayout {

		private var _target : Sprite;
		private var _rect : Rectangle;

		public function ShapeLayout(target : Sprite) {
			_target = target;	
			
			_rect = _target.getBounds(_target.parent);
		}

		public function getNextPoint() : Point {
			var pt : Point;
			
			do {
				pt = new Point();
				pt.x = (Math.random() * _rect.width) + _rect.x;
				pt.y = (Math.random() * _rect.height) + _rect.y;
				
				if (!_target.hitTestPoint(pt.x, pt.y, true)) {
					pt = null;
				}
			} while (pt == null);
			
			
			return pt;
		}
	}
}
