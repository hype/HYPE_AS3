package example.display {
	import flash.display.Sprite;
	
	public class SwarmSprite extends Sprite {
		private var _fill:Sprite;
		
		public function SwarmSprite() {		
			_fill = new Sprite();
			_fill.graphics.beginFill(0xFFFFFF);
			_fill.graphics.drawRoundRect(-17, -3, 20, 6, 6);
			_fill.graphics.endFill();
			
			addChild(_fill);
			
			graphics.lineStyle(2, 0x000000);
			graphics.drawRoundRect(-17, -3, 20, 6, 6);
			
		}
	}
}
