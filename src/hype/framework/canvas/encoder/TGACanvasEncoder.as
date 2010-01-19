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
			// image type
			_tga.writeByte(2);
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
			_tga.writeByte(32);
			
			_row = 0;
			_col = 0;
			
			_encodeRhythm.start();
		}
		
		private function encodeOverTime(r:SimpleRhythm):void {
			var i:int;
			var s:uint = getTimer();
			while (getTimer() - s < 35) {
				if (_row == _height) {
					onEncodeComplete(_tga);
					r.stop();
					return;
				} else {
					for (i=0; i<_width; ++i) {
						_tga.writeUnsignedInt(_canvas.getPixel32(i, _row));
					}
					
					++_row;
				}
				
			}
			
			onEncodeProgress(_row/_height);
		}
	}
}
