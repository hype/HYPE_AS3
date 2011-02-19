package hype.framework.canvas.encoder {
	import hype.framework.canvas.IEncodable;

	/**
	 * @author bhall
	 */
	public interface ICanvasEncoder {
		function encode(canvas:IEncodable):void;
		function get fileExtension():String;
	}
}
