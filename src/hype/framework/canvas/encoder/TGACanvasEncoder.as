package hype.framework.canvas.encoder {
	import hype.framework.canvas.ICanvas;
	import hype.framework.rhythm.SimpleRhythm;

	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	/**
	 * @author bhall
	 */
	public class TGACanvasEncoder extends AbstractCanvasEncoder implements ICanvasEncoder {
		private var _encodeRhythm:SimpleRhythm;
		private var _tga:ByteArray;
		private var _row:uint;
		private var _col:uint;
		private var _width:uint;
		private var _height:uint;
		private var _canvas:ICanvas;
		
		public function TGACanvasEncoder() {
			_encodeRhythm = new SimpleRhythm(encodeOverTime);
		}
		
		override public function get fileExtension():String {
			return "TGA";
		}
		
		override public function encode(canvas:ICanvas):void {
			_canvas = canvas;
			
			_tga = new ByteArray();
			_tga.endian = Endian.LITTLE_ENDIAN;
			
			_width = canvas.rect.width;
			_height = canvas.rect.height;
			
			// id length
			_tga.writeByte(0);
			// color map type
			_tga.writeByte(0);
			// image type - RLE encoded true color
			_tga.writeByte(10);
			// color map
			_tga.writeByte(0);
			_tga.writeByte(0);
			_tga.writeByte(0);
			_tga.writeByte(0);
			_tga.writeByte(0);
			//image orientation
			_tga.writeByte(0);
			_tga.writeByte(0);
			_tga.writeByte(0);
			_tga.writeByte(0);
			//image dimensions
			_tga.writeShort(_width);
			_tga.writeShort(_height);
			// pixel depth
			_tga.writeByte(32);
			// image descriptor
			_tga.writeByte(40);
			
			_row = 0;
			_col = 0;
			
			_encodeRhythm.start();
		}
		
		private function encodeOverTime(r:SimpleRhythm):void {
			var i:int;
			var max:int;
			var j:int;
			var s:uint = getTimer();
			var pixel:uint;
			var nextPixel:uint;
			var count:uint;
			var buffer:Array = new Array();
			while (getTimer() - s < 35) {
				if (_row == _height) {
					onEncodeComplete(_tga);
					r.stop();
					return;
				} else {
					i = 0;
					while (i < _width) {
						count = 0;
						
						pixel = _canvas.getPixel32(i, _row);
						
						if (i == _width - 1) {
							_tga.writeByte(0);
							_tga.writeUnsignedInt(pixel);
							++i
						} else {
							nextPixel = _canvas.getPixel32(i+1, _row);
							
							// handle runs of the same color
							if (pixel == nextPixel) {
								do {
									++i;
									++count;								
								} while (i < _width - 1 && count < 127 && _canvas.getPixel32(i+1, _row) == pixel);
							
								_tga.writeByte(128 + count);
								_tga.writeUnsignedInt(pixel);
								
								++i;
								
							// handle runs of different colors
							} else {
								while (i < _width - 2 && buffer.length < 128 && pixel != nextPixel) {
									++i;
									buffer.push(pixel);
									pixel = nextPixel;
									nextPixel = _canvas.getPixel32(i+1, _row);
								}
								
								if (i == _width - 2) {
									buffer.push(pixel);
									buffer.push(nextPixel);
									i += 2;
								}
								
								if (buffer.length == 128) {
									buffer.push(pixel);
									++i;
								}
								
								_tga.writeByte(buffer.length - 1);
								max = buffer.length;
								for (j=0; j<max; ++j) {
									_tga.writeUnsignedInt(buffer[j]);
								}
								
								buffer = new Array();
							}
						}
					}
					
					++_row;
				}
				
			}
			
			onEncodeProgress(_row/_height);
		}
	}
}
