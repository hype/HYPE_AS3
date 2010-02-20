package {
	import example.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/*
	 * HYPE Pure AS3 Examples
	 * --
	 * Uncomment the example you would like to view.
	 * 
	 * Compile with:
	 * mxmlc HYPEExamples.as --output ../bin/HYPEExamples.swf --target-player 10 --use-network true --library-path ../../../hype-framework.swc ../../../hype-extended.swc
	 */

	[SWF(width="640", height="360", backgroundColor="#111111", frameRate="30")] 
	public class HYPEExamples extends Sprite {
		private var _example:AbstractExample;
		
		public function HYPEExamples() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void {
			var area:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
		//	_example = new BitmapCanvasExample(area);
			_example = new SoundAnalyzerExample(area);
		//	_example = new SwarmExample(area);
			
			addChild(_example);
		}
	}
}
