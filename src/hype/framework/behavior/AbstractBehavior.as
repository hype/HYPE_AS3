package hype.framework.behavior {
	import hype.framework.rhythm.AbstractRhythm;
	import hype.framework.rhythm.RhythmManager;

	public class AbstractBehavior {
		public static var manager:RhythmManager;
		
		private var _target:Object;
		
		public function AbstractBehavior(target:Object) {
			if (AbstractRhythm.manager == null) {
				AbstractRhythm.manager = new RhythmManager();
			}
			
			if (manager == null) {
				manager = AbstractRhythm.manager;
			}
			
			_target = target;
			manager.addRhythm(this, runBehavior);
		}
		
		public static function removeBehaviorsFromObject(object:Object):void {
			var list:Array = manager.getRhythmsOfType(AbstractBehavior);
			var max:int = list.length;
			var i:int;
			
			for (i=0; i<max; ++i) {
				if ((list[i] as AbstractBehavior).target == object) {
					manager.removeRhythm(list[i]);
				}
			}
			
		}
		
		public function runBehavior():void {
			(this as IBehavior).run(_target);
		}
		
		public function start(type:String="enter_frame", interval:uint=1):Boolean {
			return manager.startRhythm(this, type, interval);
		}
		
		public function stop():Boolean {
			return manager.stopRhythm(this);
		}
		
		public function destroy():void {
			_target = null;
			manager.removeRhythm(this);
		}
		
		public function get isRunning():Boolean {
			return manager.getRhythmInfo(this).isRunning;		
		}
		
		public function get target():Object {
			return _target;
		}
		
		protected function getProperty(name:String):Number {
			if (name == "scale") {
				return _target["scaleX"];
			} else {
				return _target[name];
			}
		}
		
		protected function setProperty(name:String, value:Number):void {
			if (name == "scale") {
				_target["scaleX"] =
				_target["scaleY"] = value;
			} else {
				_target[name] = value;
			}
		}		
		
	}
}
