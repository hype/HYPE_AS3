package hype.framework.canvas.encoder {
	import hype.framework.canvas.ICanvas;

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
		 * 
		 */
		public function encode(canvas:ICanvas):void {
					
		}
		
		public function get fileExtension():String {
			return "null";
		}
	}
}
