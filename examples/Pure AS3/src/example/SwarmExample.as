package example {
	import example.display.SwarmSprite;

	import hype.extended.behavior.Swarm;
	import hype.extended.color.ColorPool;
	import hype.extended.rhythm.FilterCanvasRhythm;
	import hype.framework.behavior.BehaviorStore;
	import hype.framework.core.ObjectPool;
	import hype.framework.core.TimeType;
	import hype.framework.display.BitmapCanvas;
	import hype.framework.rhythm.SimpleRhythm;

	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SwarmExample extends AbstractExample {
		private var _clipCanvas:BitmapCanvas;
		private var _clipContainer:Sprite;
		private var _colorPool:ColorPool;
		private var _swarmPoint:Point;
		private var _pool:ObjectPool;
		private var _blurRhythm:FilterCanvasRhythm;
		private var _resetRhythm:SimpleRhythm;
		
		public function SwarmExample(area:Rectangle) {
			super(area);
			
			_colorPool = new ColorPool(
				0x587b7C, 0x719b9E, 0x9FC1BE, 0xE0D9BB, 0xDACB94, 0xCABA88, 0xDABD55, 0xC49F32, 0xA97409
			);

			_clipCanvas = new BitmapCanvas(_area.width, _area.height);
			_clipContainer = new Sprite();

			_pool = new ObjectPool(SwarmSprite, 100);
			_pool.onRequestObject = onRequestSwarmSprite;

			_blurRhythm = new FilterCanvasRhythm([new BlurFilter(1.05, 1.05, 1)], _clipCanvas);
			_blurRhythm.start(TimeType.TIME, 100);

			_resetRhythm = new SimpleRhythm(resetSwarm);
			_resetRhythm.start(TimeType.TIME, 1000);
			
			addChild(_clipCanvas);
			_clipCanvas.startCapture(_clipContainer, true);
			
			_pool.requestAll();
			
			resetSwarm(null);
			
		}
		
		private function resetSwarm(rhythm:SimpleRhythm):void {
			// with rhythm we could stop the rhythm if we wanted to...
			rhythm;
			
			_swarmPoint = new Point();
			_swarmPoint.x = Math.random() * _area.width + _area.x;
			_swarmPoint.y = Math.random() * _area.height + _area.y;
			
			_pool.activeSet.forEach(changeSwarmGoal);
		}

		private function changeSwarmGoal(swarmSprite:SwarmSprite):void {
			var swarm:Swarm = BehaviorStore.retrieve(swarmSprite, "swarm") as Swarm;
			swarm.point = _swarmPoint;
		}

		private function onRequestSwarmSprite(swarmSprite:SwarmSprite):void {
			var swarm:Swarm;
			
			swarmSprite.x = _area.width / 2 + _area.x;
			swarmSprite.y = _area.height / 2 + _area.y;
	
			swarmSprite.scaleX = swarmSprite.scaleY = (Math.random() * 0.75) + 0.5;
	
			swarm = new Swarm(swarmSprite, new Point(swarmSprite.x, swarmSprite.y), 10, 0.05, 1.5);
			swarm.start();
			swarm.store("swarm");
	
			_colorPool.colorChildren(swarmSprite);

			_clipContainer.addChild(swarmSprite);
		}		
	}
}
