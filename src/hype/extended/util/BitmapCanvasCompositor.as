package hype.extended.util {
	import hype.framework.canvas.IEncodable;
	import hype.framework.display.BitmapCanvas;

	import flash.geom.Rectangle;

	/**
	 * Captures a specifed vector of DisplayObjects to a bitmap
	 */
	public class BitmapCanvasCompositor implements IEncodable {
		protected var _rect:Rectangle;
		protected var _canvasList:Array;
		
		/**
		 * Constructor
		 * 
		 * @param list Vector of BitmapCanvas instances
		 */		
		public function BitmapCanvasCompositor(list:Vector.<BitmapCanvas>):void {
			var max:int = list.length;
			var i:int;
			var w:Number;
			var h:Number;
			
			_canvasList = new Array();
			
			_rect = new Rectangle(0, 0, 0, 0);
			
			for (i=0; i<max; ++i) {
				if (list[i].largeCanvas) {
					_canvasList.push(list[i].largeCanvas);
					w = list[i].largeCanvas.rect.width;
					h = list[i].largeCanvas.rect.height;
				} else {
					_canvasList.push(list[i]);
					w = list[i].rect.width;
					h = list[i].rect.height;
				}
				
				_rect.width = Math.max(_rect.width, w);
				_rect.height = Math.max(_rect.height, h);
				
			}
			
			_canvasList = _canvasList.reverse();
		}

		/**
		 * Get the 32-bit color value for a particular pixel
		 * 
		 * @param x horizonal position of pixel
		 * @param y verital position of pixel
		 * 
		 * @return integer color in the form 0xRRGGBBAA
		 */
		public function getPixel32(x:int, y:int):int {
			var a0:Number;
			var r0:int;
			var g0:int;
			var b0:int;
			var a1:Number;
			var r1:int;
			var g1:int;
			var b1:int;
			var c:int;
			var max:int = _canvasList.length;
			var i:int;
			
			c = (_canvasList[0] as IEncodable).getPixel32(x, y);
			a0 = (c >> 24 & 0xFF) / 0xFF;
			r0 = c >> 16 & 0xFF;
			g0 = c >> 8 & 0xFF;
			b0 = c & 0xFF;		
			
		
			// composite all of the pixels from all of the bitmaps together
			for (i=1; i<max; ++i) {
				c = (_canvasList[i] as IEncodable).getPixel32(x, y);
				a1 = (c >> 24 & 0xFF) / 0xFF;
				r1 = c >> 16 & 0xFF;
				g1 = c >> 8 & 0xFF;
				b1 = c & 0xFF;
				
				r0 = r0 * a0 + r1 * a1 - a0 * a1 * r1;
				g0 = g0 * a0 + g1 * a1 - a0 * a1 * g1;
				b0 = b0 * a0 + b1 * a1 - a0 * a1 * b1;
				
				a0 = a1 + a0 - a1 * a0;
				r0 = int(r0 / a0);
				g0 = int(g0 / a0);
				b0 = int(b0 / a0);
			}
			
			return (int(a0 * 0xFF) << 24) | r0 << 16 | g0 << 8 | b0;
		}
		
		public function get rect():Rectangle {
			return _rect;
		}
	}
}
