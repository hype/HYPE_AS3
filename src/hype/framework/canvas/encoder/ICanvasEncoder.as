package hype.framework.canvas.encoder {

	import hype.framework.canvas.ICanvas;
	/**
	 * @author bhall
	 */
	public interface ICanvasEncoder {
		function encode(canvas:ICanvas):void;
		function get fileExtension():String;
	}
}
