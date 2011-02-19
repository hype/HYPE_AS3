package hype.framework.canvas.encoder {
	import hype.framework.canvas.IEncodable;
	import hype.framework.rhythm.SimpleRhythm;

	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * Class that encodes an ICanvas into a PNG
	 */	
	public class PNGCanvasEncoder extends AbstractCanvasEncoder implements ICanvasEncoder {
		public static var FRAME_TIME:int = 35;
		
		protected static const ROW_MODE:int = 0;
		protected static const COMPRESS_MODE:int = 2;
		protected static const WRITE_MODE:int = 3;

		protected var _png:ByteArray;	
		protected var _width:int;
		protected var _height:int;
		protected var _IDAT:ByteArray;
	    protected var _crcTable:Array;	
		protected var _encodeRhythm:SimpleRhythm;
		protected var _row:int;
		protected var _img:IEncodable;
		protected var _mode:int = 0;
		
		public function PNGCanvasEncoder() {
			var c:uint;
			
			_encodeRhythm = new SimpleRhythm(encodeOverTime);		
			_crcTable = [];

            for (var n:uint = 0; n < 256; n++) {
                c = n;
                for (var k:uint = 0; k < 8; k++) {
                    if (c & 1) {
                        c = uint(uint(0xedb88320) ^ 
                            uint(c >>> 1));
                    } else {
                        c = uint(c >>> 1);
                    }
                }
                _crcTable[n] = c;
            }		
		}
		
		override public function get fileExtension():String {
			return "PNG";
		}
		
		/**
		 * Created a PNG image from the specified ICanvas
		 *
		 * @param image The ICanvas that will be converted into the PNG format.
		 */			
	    override public function encode(img:IEncodable):void {
	    	_png = new ByteArray();
	    	_mode = ROW_MODE;
	    	
	    	_img = img;
	        // Write PNG signature
	        _png.writeUnsignedInt(0x89504e47);
	        _png.writeUnsignedInt(0x0D0A1A0A);
	        // Build IHDR chunk
	        var IHDR:ByteArray = new ByteArray();
	        IHDR.writeInt(int(img.rect.width));
	        IHDR.writeInt(int(img.rect.height));
	        IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
	        IHDR.writeByte(0);
	        writeChunk(_png,0x49484452,IHDR);
	        // Build IDAT chunk
	        _IDAT= new ByteArray();
	        
	        _width = Math.ceil(img.rect.width);
	        _height = Math.ceil(img.rect.height);
	        _row = 0;
	        
			_encodeRhythm.start();
	    }
	    
	    protected function encodeOverTime(r:SimpleRhythm):void {
	    	var startTime:int = getTimer();

			switch (_mode) {
				case ROW_MODE:
					while (getTimer() - startTime < FRAME_TIME) {
						if (_row < _height) {
							_IDAT.writeByte(0);
							var p:uint;
							var j:int;
							for(j=0; j<_width; j++) {
								p = _img.getPixel32(j,_row);
								_IDAT.writeUnsignedInt(uint(((p&0xFFFFFF) << 8) | (p>>>24)));
							}
			                
							++_row;
			                
				    	} else {
				    		_mode = COMPRESS_MODE;
				       		break;
				    	}
			    	}
			    	
			       	if (onEncodeProgress != null) {
						onEncodeProgress((_row+1)/(_height+1) * 0.7);
					}
			    	
			    	break;
			    
			    case COMPRESS_MODE:
			    	_IDAT.compress();
			    	
			    	_mode = WRITE_MODE;
			    	
			       	if (onEncodeProgress != null) {
						onEncodeProgress(0.9);
			       	}
			       	break;
			       	
			    case WRITE_MODE:
					writeChunk(_png,0x49444154,_IDAT);
		      		writeChunk(_png,0x49454E44,null);
		      		
		      		r.stop();
		      		
			       	if (onEncodeProgress != null) {
						onEncodeProgress(1);
			       	}		      		
		      		
					if (onEncodeComplete != null) {
						onEncodeComplete(_png);    	
					}

		      		break;
			}
	    }
	
	    protected function writeChunk(png:ByteArray, type:uint, data:ByteArray):void {
			var c:uint;
	        var len:uint = 0;
	        
	        if (data != null) {
	            len = data.length;
	        }
	        png.writeUnsignedInt(len);
	        var p:uint = png.position;
	        png.writeUnsignedInt(type);
	        if ( data != null ) {
	            png.writeBytes(data);
	        }
	        var e:uint = png.position;
	        png.position = p;
	        c = 0xffffffff;
	        for (var i:int = 0; i < (e-p); i++) {
	            c = uint(_crcTable[
	                (c ^ png.readUnsignedByte()) & 
	                uint(0xff)] ^ uint(c >>> 8));
	        }
	        c = uint(c^uint(0xffffffff));
	        png.position = e;
	        png.writeUnsignedInt(c);
	    }
	}		
}
