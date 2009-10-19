package hype.framework.display {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.IGraphicsData;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class SketchPad extends Sprite {
		private var _lastX:Number;
		private var _lastY:Number;
		private var _lastLineStyle:Array;
		
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):SketchPad {
			graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);
			return this;
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):SketchPad {
			graphics.beginFill(color, alpha);
			return this;
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):SketchPad {
			graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			return this;	
		}
		
		public function beginShaderFill(shader:Shader, matrix:Matrix = null):SketchPad {
			graphics.beginShaderFill(shader, matrix);
			return this;
		}
		
		public function clear(remember:Boolean = false):SketchPad {
			graphics.clear();
			
			if (remember) {
				graphics.moveTo(_lastX, _lastY);
				graphics.lineStyle.apply(graphics, _lastLineStyle);
			}
			
			return this;
		}
		
		public function copyFrom(sourceGraphics:Graphics):SketchPad {
			graphics.copyFrom(sourceGraphics);
			return this;
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):SketchPad {
			graphics.curveTo(controlX, controlY, anchorX, anchorY);
			_lastX = anchorX;
			_lastY = anchorY;
			return this;
		}
		
		public function drawCircle(x:Number, y:Number, radius:Number):SketchPad {
			graphics.drawCircle(x, y, radius);
			return this;
		}
		
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):SketchPad {
			graphics.drawEllipse(x, y, width, height);
			return this;
		}
		
		public function drawGraphicsData(graphicsData:Vector.<IGraphicsData>):SketchPad {
			graphics.drawGraphicsData(graphicsData);
			return this;
		}
		
		public function drawPath(commands:Vector.<int>, data:Vector.<Number>, winding:String = "evenOdd"):SketchPad {
			graphics.drawPath(commands, data, winding);
			return this;
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):SketchPad {
			graphics.drawRect(x, y, width, height);
			return this;
		}
		
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):SketchPad {
			graphics.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
			return this;
		}
		
		public function drawTriangles(vertices:Vector.<Number>, indices:Vector.<int> = null, uvtData:Vector.<Number> = null, culling:String = "none"):SketchPad {
			graphics.drawTriangles(vertices, indices, uvtData, culling);
			return this;
		}

		public function endFill():SketchPad {
			graphics.endFill();
			return this;
		}														

		public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):SketchPad {
			graphics.lineBitmapStyle(bitmap, matrix, repeat, smooth);
			return this;
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):SketchPad {
			graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			return this;
		}
		
		public function lineShaderStyle(shader:Shader, matrix:Matrix = null):SketchPad {
			graphics.lineShaderStyle(shader, matrix);
			return this;
		}				
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):SketchPad {
			graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
			_lastLineStyle = [thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit];
			return this;
		}	
		
		public function lineTo(x:Number, y:Number):SketchPad {
			graphics.lineTo(x, y);
			_lastX = x;
			_lastY = y;
			return this;
		}	
		
		public function moveTo(x:Number, y:Number):SketchPad {
			graphics.moveTo(x, y);
			_lastX = x;
			_lastY = y;			
			return this;
		}														
	}
}
