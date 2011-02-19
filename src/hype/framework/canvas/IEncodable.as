package hype.framework.canvas {
	import flash.geom.Rectangle;

	/**
	 * @author bhall
	 */
	public interface IEncodable {
		function get rect():Rectangle;
		function getPixel32(x:int, y:int):int;
	}
}
