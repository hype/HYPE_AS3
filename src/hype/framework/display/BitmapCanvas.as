package hype.framework.display {
	import hype.framework.canvas.GridCanvas;
	import hype.framework.canvas.ICanvas;
	import hype.framework.canvas.SimpleCanvas;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * Captures a specifed target DisplayObject to a bitmap and displays it. 
	 */
	public class BitmapCanvas extends Sprite implements ICanvas {

		protected var _canvas:SimpleCanvas;
		protected var _largeCanvas:GridCanvas;
		protected var _bitmap:Bitmap;
		protected var _canvasBlendMode:String;
		protected var _canvasColorTransform:ColorTransform;
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;

		/**
		 * Constructor
		 * 
		 * @param width Width of the bitmap (pixels)
		 * @param height Height of the bitmap (pixels)
		 * @param transparent Boolean specifying if the bitmap is transparent
		 * @param fillColor Default fill color of the bitmap
		 */
		public function BitmapCanvas(w:Number, h:Number, scale:Number=1, transparent:Boolean=true, fillColor:uint=0x00000000) {
			_canvas = new SimpleCanvas(w, h, scale, transparent, fillColor);
			
			
			_width = w;
			_height = h;
			_scale = scale;
			
			_bitmap = new Bitmap(_canvas.bitmapData);
			addChild(_bitmap);
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
			_largeCanvas = new GridCanvas(Math.ceil(_width/_scale * scale), 
											Math.ceil(_height/_scale * scale),
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
		public function startCapture(target:*, continuous:Boolean=false, type:String="enter_frame", interval:int=1):Boolean {
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
			if (_largeCanvas) {
				_largeCanvas.clear();
			}
		}
		
		public function applyFilter(filter:BitmapFilter):void {
			_canvas.applyFilter(filter);
			if (_largeCanvas) {
				_largeCanvas.applyFilter(filter);
			}
		}
		
		public function colorTransform(transform:ColorTransform):void {
			_canvas.colorTransform(transform);
			if (_largeCanvas) {
				_largeCanvas.colorTransform(transform);
			}
		}
		
		public function getPixel32(x:int, y:int):int {
			return _canvas.getPixel32(x, y);
		}
		
	}
}
