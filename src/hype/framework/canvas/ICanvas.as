package hype.framework.canvas {
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * Interface for canvases that capture display objects to bitmaps
	 */
	public interface ICanvas {
		function get target():DisplayObject;
		function set target(value:DisplayObject):void;
		function get isCapturing():Boolean;
		function get rect():Rectangle;
		function get transparent():Boolean;
		function get fillColor():int;
		
		function get canvasBlendMode():String;
		function set canvasBlendMode(value:String):void;
		function get canvasColorTransform():ColorTransform;
		function set canvasColorTransform(value:ColorTransform):void;
		
		function startCapture(target:DisplayObject, continuous:Boolean=false, type:String="enter_frame", interval:int=1):Boolean;
		function stopCapture():Boolean;
		function capture(continuous:Boolean=true):void;
		function clear():void;
		function applyFilter(filter:BitmapFilter):void;
		function getPixel32(x:int, y:int):int;
	}
}
