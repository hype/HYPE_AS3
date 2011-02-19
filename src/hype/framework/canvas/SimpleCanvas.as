package hype.framework.canvas {
	import hype.framework.rhythm.SimpleRhythm;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Captures a specifed target DisplayObject to a bitmap
	 */
	public class SimpleCanvas implements ICanvas {
		protected var _targetList:Array;
		protected var _rect:Rectangle;
		protected var _zeroPoint:Point;
		protected var _fillColor:uint;
		protected var _bitmapData:BitmapData;
		protected var _transparent:Boolean;
		
		protected var _canvasBlendMode:String = null;
		protected var _canvasColorTransform:ColorTransform = null;
		
		protected var _captureFlag:Boolean;
		protected var _captureMethod:Function;
		protected var _rhythm:SimpleRhythm;
		protected var _matrix:Matrix;
		
		/**
		 * Constructor
		 * 
		 * @param width Width of the bitmap (pixels)
		 * @param height Height of the bitmap (pixels)
		 * @param transparent Boolean specifying if the bitmap is transparent
		 * @param fillColor Default fill color of the bitmap
		 */
		public function SimpleCanvas(width:Number, height:Number, scale:Number=1, transparent:Boolean=true, fillColor:uint = 0x00000000) {
			_matrix = new Matrix();
			_matrix.scale(scale, scale);
			
			_rect = new Rectangle(0, 0, width, height);
			_fillColor = fillColor;
			_zeroPoint = new Point(0, 0);
			_captureFlag = false;
			
			_transparent = transparent;
			_fillColor = fillColor;
			
			_bitmapData = new BitmapData(width, height, transparent, fillColor);
			
			_rhythm = new SimpleRhythm(null);
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
		public function startCapture(target:*, continuous:Boolean = false, type:String="enter_frame", interval:int=1):Boolean {
			var max:int;
			var i:int;
			
			_targetList = new Array();
			
			if (!_captureFlag) {
				if (target is DisplayObject) {
					_targetList[0] = target;
				} else if (target is Vector || target is Array) {
					max = target["length"];
					for (i=0; i<max; ++i) {
						_targetList[i] = target[i];
					}
				} else {
					return false;
				}
				
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
			var max:int = _targetList.length;
			var i:int;
			
			if (!continuous) {
				_bitmapData.fillRect(_rect, _fillColor);
			}
			
			for (i=0; i<max; ++i) {
				_bitmapData.draw(_targetList[i], _matrix, _canvasColorTransform, _canvasBlendMode);
			}
		}			
		
		/**
		 * Clear the canvas back to it's base color (by default, 0xFFFFFFFF)
		 */
		public function clear():void {
			_bitmapData.fillRect(_rect, _fillColor);
		}

		/**
		 * Apply a BitmapFilter to the canvas
		 */		
		public function applyFilter(filter:BitmapFilter):void {
			_bitmapData.applyFilter(_bitmapData, _rect, new Point(0, 0), filter);
		}

		public function colorTransform(transform:ColorTransform):void {
			_bitmapData.colorTransform(_rect, transform);
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
			return _bitmapData.getPixel32(x, y);	
		}		
	}
}
