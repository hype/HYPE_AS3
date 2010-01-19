package hype.extended.util {
	import hype.framework.canvas.encoder.PNGCanvasEncoder;
	import hype.framework.display.BitmapCanvas;

	/**
	 * Just a wrapper around the ContextSaveImage class to stay
	 * backwards compatible with v1.1.1
	 */
	public class ContextSavePNG extends ContextSaveImage {
		public function ContextSavePNG(canvas:BitmapCanvas) {
			super(canvas, PNGCanvasEncoder);
		}
	}
}
