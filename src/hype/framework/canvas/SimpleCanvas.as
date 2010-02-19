package hype.framework.canvas {
	import hype.framework.rhythm.SimpleRhythm;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Captures a specifed target DisplayObject to a bitmap
	 */
	public class SimpleCanvas implements ICanvas {
		private var _target:DisplayObject;
		private var _rect:Rectangle;
		private var _zeroPoint:Point;
		private var _fillColorAlpha:uint;
		private var _bitmapData:BitmapData;
		private var _transparent:Boolean;
		private var _fillColor:int;
		
		private var _canvasBlendMode:String = null;
		private var _canvasColorTransform:ColorTransform = null;
		
		private var _captureFlag:Boolean;
		private var _captureMethod:Function;
		private var _rhythm:SimpleRhythm;
		
		/**
		 * Constructor
		 * 
		 * @param width Width of the bitmap (pixels)
		 * @param height Height of the bitmap (pixels)
		 * @param transparent Boolean specifying if the bitmap is transparent
		 * @param fillColor Default fill color of the bitmap
		 */
		public function SimpleCanvas(width:Number, height:Number, transparent:Boolean=true, fillColor:uint = 0xFFFFFF) {
			_rect = new Rectangle(0, 0, width, height);
			_fillColorAlpha = fillColor << 8 & (transparent ? 0xFF : 0x00);	
			_zeroPoint = new Point(0, 0);
			_captureFlag = false;
			
			_transparent = transparent;
			_fillColor = fillColor;
			
			_bitmapData = new BitmapData(width, height, transparent, fillColor);
			
			_rhythm = new SimpleRhythm(null);
		}
		
		/**
		 * Target being captured to bitmap
		 */
		public function get target():DisplayObject {
			return _target;
		}
		
		/**
		 * Set target being captured to bitmap
		 */
		public function set target(value:DisplayObject):void {
			_target = value;
		}		
		
		/**
		 * The instance of BitmapData used by this SimpleCanvas
		 */
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		/**
		 * The rectange that descibes the image bounds
		 */
		public function get rect():Rectangle {
			return _rect;
		}
		
		/**
		 * Whether the image is transparent
		 */
		public function get transparent():Boolean {
			return _transparent;
		}
	
		/**
		 * The fill color of the image
		 */	
		public function get fillColor():int {
			return _fillColor;
		}
		
		/**
		 * Whether this SimpleCanvas is currently capturing
		 */
		public function get isCapturing():Boolean {
			return _captureFlag;
		}
		
		/**
		 * Blend mode to apply when capturing
		 */
		public function get canvasBlendMode():String {
			return _canvasBlendMode;
		}
		
		public function set canvasBlendMode(value:String):void {
			_canvasBlendMode = value;
		}
		
		/**
		 * Color transform to apply when capturing
		 */
		public function get canvasColorTransform():ColorTransform {
			return _canvasColorTransform;
		}
		
		public function set canvasColorTransform(value:ColorTransform):void {
			_canvasColorTransform = value;
		}		
		
		/**
		 * Start capturing the target into the bitmap
		 * 
		 * @param target DisplayObject to capture
		 * @param continuous Flag specifying if the bitmap should be cleared
		 * after each capture (true to NOT erase after each capture)
		 * @param type Time type to use
		 * @param interval Interval between captures
		 * 
		 * @return Whether the capture started or not (false if capture is
		 * already occurring)
		 * 
		 * @see hype.framework.core.TimeType
		 */
		public function startCapture(target:DisplayObject, continuous:Boolean = false, type:String="enter_frame", interval:int=1):Boolean {
			if (!_captureFlag) {
				_target = target;
				
				_rhythm.callback = function():void {
					capture(continuous);
				};
				_rhythm.start(type, interval);
				_captureFlag = true;
				
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Stop capturing
		 */
		public function stopCapture():Boolean {
			if (_captureFlag) {
				_rhythm.stop();
				_captureFlag = false;
				return true;
			} else {
				return false;
			}
		}

		/*
		 * Capture the target once
		 * 
		 * @param continuous Whether to erase (false) or not erase (true) before capturing
		 */		
		public function capture(continuous:Boolean=true):void {
			if (!continuous) {
				_bitmapData.fillRect(_rect, _fillColorAlpha);
			}
			_bitmapData.draw(_target, null, _canvasColorTransform, _canvasBlendMode);
		}			
		
		/**
		 * Clear the canvas back to it's base color (by default, 0xFFFFFFFF)
		 */
		public function clear():void {
			_bitmapData.fillRect(_rect, _fillColorAlpha);
		}

		/**
		 * Apply a BitmapFilter to the canvas
		 */		
		public function applyFilter(filter:BitmapFilter):void {
			_bitmapData.applyFilter(_bitmapData, _rect, new Point(0, 0), filter);
		}

		/**
		 * Get the 32-bit colot value for a particular pixel
		 * 
		 * @param x horizonal position of pixel
		 * @param y verital position of pixel
		 * 
		 * @return integer color in the form 0xRRGGBBAA
		 */			
		public function getPixel32(x:int, y:int):int {
			return _bitmapData.getPixel32(x, y);	
		}		
	}
}
