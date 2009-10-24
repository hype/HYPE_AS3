package hype.framework.display {
	import hype.framework.rhythm.SimpleRhythm;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapCanvas extends Sprite {
		private var _target:DisplayObject;
		private var _rect:Rectangle;
		private var _zeroPoint:Point;
		private var _transparent:Boolean;
		private var _fillColor:uint;
		private var _fillColorAlpha:uint;
		private var _bitmap:Bitmap;
		private var _matrix:Matrix;
		
		private var _captureFlag:Boolean;
		private var _captureMethod:Function;
		private var _rhythm:SimpleRhythm;
		
		public function BitmapCanvas(width:Number, height:Number, transparent:Boolean=true, fillColor:uint = 0xFFFFFF) {
			var bitmapData:BitmapData;
			
			_rect = new Rectangle(0, 0, width, height);
			_transparent = transparent;
			_fillColor = fillColor;
			_fillColorAlpha = _fillColor << 8 & (transparent ? 0xFF : 0x00);
			
			_zeroPoint = new Point(0, 0);
			
			_captureFlag = false;
			
			bitmapData = new BitmapData(width, height, transparent, fillColor);
			
			_rhythm = new SimpleRhythm(null);
			
			_bitmap = new Bitmap(bitmapData);
			addChild(_bitmap);
		}
		
		public function get target():DisplayObject {
			return _target;
		}
		
		public function get bitmap():Bitmap {
			return _bitmap;
		}
		
		public function get isCapturing():Boolean {
			return _captureFlag;
		}
		
		public function get matrix():Matrix {
			return _matrix;
		}
		
		public function set matrix(value:Matrix):void {
			_matrix = value;
		}
		
		public function startCapture(target:DisplayObject, continuous:Boolean = false, type:String="enter_frame", interval:int=1):Boolean {
			if (!_captureFlag) {
				_target = target;
				
				if (continuous) {
					_captureMethod = captureContinuous;
				} else {
					_captureMethod = capture;
				}
				
				_rhythm.callback = _captureMethod;
				_rhythm.start(type, interval);
				_captureFlag = true;
				
				return true;
			} else {
				return false;
			}
		}
		
		public function stopCapture():Boolean {
			if (_captureFlag) {
				removeEventListener(Event.ENTER_FRAME, _captureMethod);
				_captureFlag = false;
				
				return true;
			} else {
				return false;
			}
		}
		
		private function capture(...rest):void {
			_bitmap.bitmapData.fillRect(_rect, _fillColorAlpha);
			_bitmap.bitmapData.draw(_target, _matrix);
		}		
		
		private function captureContinuous(...rest):void {
			_bitmap.bitmapData.draw(_target, _matrix);
		}
		
	}
}
