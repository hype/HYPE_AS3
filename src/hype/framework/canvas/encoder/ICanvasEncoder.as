package hype.framework.canvas.encoder {
	import hype.framework.canvas.IEncodable;
	
	import flash.geom.Rectangle;

	/**
	 * @author bhall
	 */
	public interface ICanvasEncoder {
		function encode(canvas:IEncodable, crop:Rectangle=null):void;
		function get fileExtension():String;
	}
}
