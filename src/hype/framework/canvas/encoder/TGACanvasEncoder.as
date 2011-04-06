package hype.framework.canvas.encoder {
	import hype.framework.canvas.IEncodable;
	import hype.framework.rhythm.SimpleRhythm;

    import flash.geom.Rectangle;
    
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	/**
	 * Class that encodes an ICanvas into a TGA (Targa image)
	 */
	public class TGACanvasEncoder extends AbstractCanvasEncoder implements ICanvasEncoder {
		protected var _encodeRhythm:SimpleRhythm;
		protected var _tga:ByteArray;
		protected var _row:uint;
		protected var _col:uint;
		protected var _width:uint;
		protected var _height:uint;
		protected var _canvas:IEncodable;
		protected var _nonRunBuffer:Vector.<int>;
		protected var _pixel:int;
		protected var _nextPixel:int;
		protected var _runCount:int;
		protected var _encodeCount:int = 0;
		protected var _encodeList:Array;
		protected var _crop:Rectangle;

		public function TGACanvasEncoder() {
			_encodeRhythm = new SimpleRhythm(encodeOverTime);
		}
		
		override public function get fileExtension():String {
			return "TGA";
		}
		
		/**
		 * Created a TGA image from the specified ICanvas
		 *
		 * @param image The ICanvas that will be converted into the PNG format.
		 * @param crop The Rectangle with which to crop the image
		 */		
		override public function encode(canvas:IEncodable, crop:Rectangle=null):void {
			_canvas = canvas;
			
			if (crop == null) {
			    _crop = canvas.rect;
			} else {
			    _crop = crop;
			}
			
			_tga = new ByteArray();
			_tga.endian = Endian.LITTLE_ENDIAN;
			
			_width = _crop.width;
			_height = _crop.height;
			
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
			
			_nonRunBuffer = new Vector.<int>();
			
			startRow();
			
			_encodeRhythm.start();
		}
		
		protected function encodeOverTime(r:SimpleRhythm):void {
			var s:uint = getTimer();
			// get that pixel
			r;	
			
			while (getTimer() - s < 50) {
				++_col;
				
				if (_col == _width) {					
					
					if (_runCount > 1) {		
						writeRun();		
					} else if (_nonRunBuffer.length == 128) {
						writeNonRun();
					} else {
						_nonRunBuffer.push(_pixel);
						writeNonRun();
					}

					_col = 0;
					++_row;
								
					if (startRow()) {
						continue;
					} else {
						break;
					}
					
				} else {
					_nextPixel = _canvas.getPixel32(_col + _crop.x, _row + _crop.y);
				}
				
				if (_pixel == _nextPixel) {
					if (_nonRunBuffer.length > 0) {
						writeNonRun();				
					}
					
					// end the run if 128 or end of row
					if (_runCount == 128) {
						writeRun();
						_pixel = _nextPixel;
					} else {
						++_runCount;
					}				
										
				} else {
					if (_runCount > 1) {
						writeRun();
					} else if (_nonRunBuffer.length == 128) {
						writeNonRun();
						_nonRunBuffer.push(_pixel);	
					} else {
						_nonRunBuffer.push(_pixel);			
					}	
					_pixel = _nextPixel;
					
				}
			}

			onEncodeProgress(_row/_height);
		}	
			
		protected function startRow():Boolean {
			_encodeList = new Array();

			if (_row == _height) {
				
				if (onEncodeComplete != null) {
					onEncodeComplete(_tga);
				}
				_encodeRhythm.stop();
				
				return false;
			} else {
				_pixel = _canvas.getPixel32(_col + _crop.x, _row + _crop.y);
				_nonRunBuffer = new Vector.<int>();
				_runCount = 1;
				_encodeCount = 0;
					
				return true;
			}
		}
				
		protected function writeNonRun():void {
			var max:int = _nonRunBuffer.length;
			var i:int;
			
			_tga.writeByte(max - 1);
			
			for (i=0; i<max; ++i) {
				_tga.writeUnsignedInt(_nonRunBuffer[i]);	
			}
			
			_encodeCount += max;
			_encodeList.push(-max);
			
			_nonRunBuffer = new Vector.<int>();
		}
		
		protected function writeRun():void {
			_tga.writeByte(128 + (_runCount - 1));
			_tga.writeUnsignedInt(_pixel);
			
			_encodeList.push(_runCount);
			_encodeCount += _runCount;
			_runCount = 1;		
		}
	}
}
