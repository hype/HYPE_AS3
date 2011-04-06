package hype.framework.canvas.encoder {
	import hype.framework.canvas.IEncodable;

    import flash.geom.Rectangle;

	/**
	 * Abstract base class for classes that encode classes that implement ICanvas instances into a bitmap format
	 */
	public class AbstractCanvasEncoder implements ICanvasEncoder {
		/**
		 * Callback for encoding progress, passed the percent complete
		 */		
		public var onEncodeProgress:Function;
		
		/**
		 * Callback for encoding complete, passed the encoded ByteArray
		 */		
		public var onEncodeComplete:Function;
		
		/**
		 * Created an image from the specified ICanvas
		 *
		 * @param image The ICanvas that will be converted into the PNG format.
		 * @param crop The Rectangle with which to crop the image
		 */
		public function encode(canvas:IEncodable, crop:Rectangle=null):void {
					
		}
		
		public function get fileExtension():String {
			return "null";
		}
	}
}
