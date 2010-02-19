package hype.framework.display {
	import hype.framework.canvas.GridCanvas;
	import hype.framework.canvas.ICanvas;
	import hype.framework.canvas.SimpleCanvas;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * Captures a specifed target DisplayObject to a bitmap and displays it. 
	 */
	public class BitmapCanvas extends Sprite implements ICanvas {

		private var _canvas:SimpleCanvas;
		private var _largeCanvas:GridCanvas;
		private var _bitmap:Bitmap;
		private var _canvasBlendMode:String;
		private var _canvasColorTransform:ColorTransform;

		/**
		 * Constructor
		 * 
		 * @param width Width of the bitmap (pixels)
		 * @param height Height of the bitmap (pixels)
		 * @param transparent Boolean specifying if the bitmap is transparent
		 * @param fillColor Default fill color of the bitmap
		 */
		public function BitmapCanvas(width:Number, height:Number, transparent:Boolean=true, fillColor:uint = 0xFFFFFF) {
			_canvas = new SimpleCanvas(width, height, transparent, fillColor);
			
			_bitmap = new Bitmap(_canvas.bitmapData);
			addChild(_bitmap);
		}
		
		/**
		 * Target being captured to bitmap
		 */
		public function get target():DisplayObject {
			return _canvas.target;
		}
		
		/**
		 * Set target being captured to bitmap
		 */
		public function set target(value:DisplayObject):void {
			_canvas.target = value;
			if (_largeCanvas) {
				_largeCanvas.target = target; 
			}			
			
		}		
		
		/**
		 * The instance of Bitmap displayed by this BitmapCanvas
		 */
		public function get bitmap():Bitmap {
			return _bitmap;
		}
		
		public function get rect():Rectangle {
			return _canvas.rect;
		}
		
		/**
		 * Whether this BitmapCanvas is currently capturing
		 */
		public function get isCapturing():Boolean {
			return _canvas.isCapturing;
		}
		
		/**
		 * Whether the canvas is transparent
		 */
		public function get transparent():Boolean {
			return _canvas.transparent;
		}
		
		/**
		 * Fill color of the canvas
		 */
		public function get fillColor():int {
			return _canvas.fillColor;
		}
		
		/**
		 * The GridCanvas being used to upscale the image (if any)
		 */
		public function get largeCanvas():GridCanvas {
			return _largeCanvas;		
		}
		
		/**
		 * Color transform to apply when canvas captures
		 */
		public function get canvasColorTransform():ColorTransform {
			return _canvasColorTransform;
		}
		
		public function set canvasColorTransform(canvasColorTransform:ColorTransform):void {
			_canvasColorTransform = canvasColorTransform;
			_canvas.canvasColorTransform = canvasColorTransform;
			
			if (_largeCanvas) {
				_largeCanvas.canvasColorTransform = canvasColorTransform;
			}
		}
		
		/**
		 * Blend mode to apply when canvas captures
		 */
		public function get canvasBlendMode():String {
			return _canvasBlendMode;
		}
		
		public function set canvasBlendMode(canvasBlendMode:String):void {
			_canvasBlendMode = canvasBlendMode;
			_canvas.canvasBlendMode = canvasBlendMode;
			
			if (_largeCanvas) {
				_largeCanvas.canvasBlendMode = canvasBlendMode;
			}
		}		
		
		
		public function setupLargeCanvas(scale:Number, gridSize:int=1024, border:int=128):void {
			_largeCanvas = new GridCanvas(Math.ceil(_canvas.rect.width * scale), 
											Math.ceil(_canvas.rect.height * scale),
											scale, 
											_canvas.transparent, 
											_canvas.fillColor, gridSize, border);	
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
		public function startCapture(target:DisplayObject, continuous:Boolean=false, type:String="enter_frame", interval:int=1):Boolean {
			if (_largeCanvas) {
				_largeCanvas.startCapture(target, continuous, type, interval);
			}
			
			return _canvas.startCapture(target, continuous, type, interval);
		}
		
		/**
		 * Stop capturing
		 */
		public function stopCapture():Boolean {
			if (_largeCanvas) {
				_largeCanvas.stopCapture();
			}
			
			return _canvas.stopCapture();
		}
		
		/**
		 * Manually capture the canvas
		 * 
		 * @param continuous Whether to NOT erase the canvas first (defaults to true)
		 */
		public function capture(continuous:Boolean=true):void {
			_canvas.capture(continuous);
			if (_largeCanvas) {
				_largeCanvas.capture(continuous);
			}
		}
		
		/**
		 * Clear the canvas back to it's base color (by default, 0xFFFFFFFF)
		 */
		public function clear():void {
			_canvas.clear();
		}
		
		public function applyFilter(filter:BitmapFilter):void {
			_canvas.applyFilter(filter);
			if (_largeCanvas) {
				_largeCanvas.applyFilter(filter);
			}
		}
		
		public function getPixel32(x:int, y:int):int {
			return _canvas.getPixel32(x, y);
		}
		
	}
}
