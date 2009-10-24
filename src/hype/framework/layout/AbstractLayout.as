package hype.framework.layout {
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class AbstractLayout {
		
		public function applyLayout(d:DisplayObject):void {
			var pt:Point = ILayout(this).getNextPoint();
			
			d.x = pt.x;
			d.y = pt.y;
		}
		
	}
}
