package hype.framework.canvas {
	import hype.framework.canvas.filter.BlurFilterScaler;
	import hype.framework.canvas.filter.GlowFilterScaler;
	import hype.framework.canvas.filter.IFilterScaler;
	import hype.framework.rhythm.SimpleRhythm;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * Captures a specifed target DisplayObject to a series of bitmaps.
	 * Supports images larger than Flash can support by splitting the image into a grid.
	 */
	public class GridCanvas implements ICanvas {
		protected var _border:int;
		protected var _gridWidth:int;
		protected var _gridHeight:int;
		protected var _scale:Number;
		protected var _gridSize:int;
		protected var _targetList:Array;
		protected var _rect:Rectangle;
		protected var _gridRect:Rectangle;
		protected var _zeroPoint:Point = new Point(0, 0);
		protected var _fillColor:uint;
		protected var _transparent:Boolean;
		
		protected var _captureFlag:Boolean;
		protected var _captureMethod:Function;
		protected var _rhythm:SimpleRhythm;
		protected var _gridList:Vector.<BitmapData>;
		
		protected var _filterScalerTable:Object;
		protected var _canvasBlendMode:String = null;
		protected var _canvasColorTransform:ColorTransform = null;

		/**
		 * Constructor
		 * 
		 * @param width Width of the bitmap (pixels)
		 * @param height Height of the bitmap (pixels)
		 * @param scale Scale amount for the image
		 * @param transparent Boolean specifying if the bitmap is transparent
		 * @param fillColor Default fill color of the bitmap
		 * @param gridSize Size of each grid square (defaults to 1024px)
		 * @param borderSize Size of the overlap for each grid square (defaults to 128)
		 */		
		public function GridCanvas(width:int, height:int, scale:Number=1, transparent:Boolean=true, fillColor:uint=0x00000000, gridSize:int=1024, border:int=128) {
			var i:int;
			var j:int;
			
			_scale = scale;
			_gridSize = gridSize;
			
			_gridWidth = Math.ceil(width/_gridSize);
			_gridHeight = Math.ceil(height/_gridSize);	
			_gridRect = new Rectangle(0, 0, _gridSize + (border * 2), _gridSize + (border * 2));	
			
			_rect = new Rectangle(0, 0, width, height);
			_fillColor = fillColor;	
			_zeroPoint = new Point(0, 0);
			_captureFlag = false;
			_border = border;
			
			_transparent = transparent;
			
			_gridList = new Vector.<BitmapData>();
			for (i=0; i<_gridHeight; ++i) {
				for (j=0; j<_gridWidth; ++j) {
					_gridList[i*_gridWidth +j] = new BitmapData(_gridSize + (border * 2), _gridSize + (border * 2), transparent, fillColor);
				}
			}
			
			_rhythm = new SimpleRhythm(null);
			
			_filterScalerTable = new Object();
			
			registerFilterScaler("flash.filters::BlurFilter", new BlurFilterScaler());
			registerFilterScaler("flash.filters::GlowFilter", new GlowFilterScaler());
		}	
		
		/**
		 * The rectangle that describes the boundary of the image
		 */
		public function get rect():Rectangle {
			return _rect;
		}	
		
		/**
		 * Whether this GridCanvas is currently capturing
		 */
		public function get isCapturing():Boolean {
			return _captureFlag;
		}
		
		/**
		 * Whether the image is transparent or not
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
			
			if (!_captureFlag) {
				
				_targetList = new Array();
				
				if (target is DisplayObject) {
					_targetList[0] = target;
				} else if (target is Array || target is Vector) {
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
			var m:Matrix;
			var max:int = _gridList.length;
			var i:int;
			var col:int;
			var row:int;
			var j:int;
			var numTargets:int = _targetList.length;

		
			
			if (!continuous) {
				for (i=0; i<max; ++i) {
					_gridList[i].fillRect(_rect, _fillColor);
				}
			}
			
			for (i=0; i<max; ++i) {
				col = i % _gridWidth;
				row = int(i / _gridWidth);
				m = new Matrix(_scale, 0, 0, _scale, _border - (col * _gridSize), _border - (row * _gridSize));
				
				for (j=0; j<numTargets; ++j) {
					_gridList[i].draw(_targetList[j], m, _canvasColorTransform, _canvasBlendMode);
				}
			}
		}			
		
		/**
		 * Clear the canvas back to it's base color (by default, 0xFFFFFFFF)
		 */
		public function clear():void {
			var i:int;
			var max:int = _gridList.length;
			var width:int = _gridSize + (_border * 2);
			var gridRect:Rectangle = new Rectangle(0, 0, width, width);
			
			for (i=0; i<max; ++i) {
				_gridList[i].fillRect(gridRect, _fillColor);
			}			
		}

		/**
		 * Apply a BitmapFilter to the canvas
		 */		
		public function applyFilter(filter:BitmapFilter):void {
			var max:int = _gridList.length;
			var data:BitmapData;
			var i:int;
			var filterScaler:IFilterScaler = _filterScalerTable[getQualifiedClassName(filter)];
			
			if (filterScaler != null) {
				filter = filterScaler.scale(filter, _scale);
			}
			
			for (i=0; i<max; ++i) {
				data = _gridList[i];	
				data.applyFilter(data, _gridRect, _zeroPoint, filter);
			}
		}
		
		public function colorTransform(transform:ColorTransform):void {
			var max:int = _gridList.length;
			var data:BitmapData;
			var i:int;
			
			for (i=0; i<max; ++i) {
				data = _gridList[i];	
				data.colorTransform(_gridRect, transform);
			}
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
			var gx:int = int(x / _gridSize);
			var gy:int = int(y / _gridSize);
			var px:int = x - (gx * _gridSize);
			var py:int = y - (gy * _gridSize);
			
			return _gridList[gy * _gridWidth + gx].getPixel32(px + _border, py + _border);
		}
		
		/**
		 * Register a fully-qualified filter to a filter scaler
		 * 
		 * @param filterClass Fully qualified class name as a string (i.e. "flash.filters::GlowFilter")
		 * @param scaler Instance of a class that implements IFilterScaler
		 */
		public function registerFilterScaler(filterClass:String, scaler:IFilterScaler):void {
			_filterScalerTable[filterClass] = scaler;
		}
	}
}
