package hype.extended.color {
	import hype.framework.color.IColorist;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	public class ColorPool implements IColorist {
		
		private var _colorList:Array;
		private var _colorTable:Object;
		
		public function ColorPool(...rest) {
			var max:uint = rest["length"];
			var i:uint;
			reset();
			
			for (i=0; i<max; ++i) {
				if (!isNaN(rest[i])) {
					addColor(rest[i]);
				}
			}
		}
		
		public function addColor(value:uint):Boolean {
			if (!hasColor(value)) {
				_colorList.push(value);
				_colorTable[value] = true;
				
				return true;
			} else {
				return false;
			}
		}
		
		public function hasColor(value:uint):Boolean {
			return (_colorTable[value] == true);
		}
		
		public function reset():void {
			_colorList = new Array();
			_colorTable = new Object();
		}
		
		public function colorChildren(sprite:Sprite):void {
			var max:uint = sprite.numChildren;
			var i:uint;
			var child:DisplayObject;
			var rgb:uint;
			var numColors:uint = _colorList.length;
			
			for (i=0; i<max; ++i) {
				child = sprite.getChildAt(i);
				if (child is InteractiveObject) {
					rgb = _colorList[Math.floor(Math.random() * numColors)];
					child.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rgb >> 16, rgb >> 8 & 255, rgb & 255, 0);
				}
			}
		}
	}
}
