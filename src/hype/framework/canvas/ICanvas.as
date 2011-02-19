package hype.framework.canvas {
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;

	/**
	 * Interface for canvases that capture display objects to bitmaps
	 */
	public interface ICanvas extends IEncodable {
		function get isCapturing():Boolean;
		function get transparent():Boolean;
		function get fillColor():int;
		
		function get canvasBlendMode():String;
		function set canvasBlendMode(value:String):void;
		function get canvasColorTransform():ColorTransform;
		function set canvasColorTransform(value:ColorTransform):void;
		
		function startCapture(target:*, continuous:Boolean=false, type:String="enter_frame", interval:int=1):Boolean;
		function stopCapture():Boolean;
		function capture(continuous:Boolean=true):void;
		function clear():void;
		function applyFilter(filter:BitmapFilter):void;
		function colorTransform(transform:ColorTransform):void;
	}
}
