package hype.framework.behavior {
	import hype.framework.core.Accessor;
	import hype.framework.rhythm.AbstractRhythm;
	import hype.framework.rhythm.RhythmManager;

	public class AbstractBehavior {
		public static var manager:RhythmManager;
		
		private static var _metaPropertyTable:Object;
		
		private var _target:Object;
		private var _metaPropertyTable:Object;
		
		public function AbstractBehavior(target:Object) {
			if (AbstractRhythm.manager == null) {
				AbstractRhythm.manager = new RhythmManager();
			}
			
			if (manager == null) {
				manager = AbstractRhythm.manager;
			}
			
			if (_metaPropertyTable == null) {
				_metaPropertyTable = new Object();
				addMetaProperty("scale", getScale, setScale);
			}
			
			_target = target;
			
			manager.addRhythm(this, runBehavior);
		}
		
		public static function addMetaProperty(name:String, getter:Function, setter:Function):void {
			_metaPropertyTable[name] = new Accessor(getter, setter);
		}
		
		public static function getScale(target:Object):Number {
			return target["scaleX"];
		}
		
		public static function setScale(target:Object, value:Number):void {
			target["scaleX"] = target["scaleY"] = value;
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
		
		public function store(name:String):void {
			BehaviorStore.store(name, this);
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
			var accessor:Accessor = Accessor(_metaPropertyTable[name]);
			
			if (accessor) {
				return accessor.getter(name);
			} else {
				return _target[name];
			}
		}
		
		protected function setProperty(name:String, value:Number):void {
			var accessor:Accessor = Accessor(_metaPropertyTable[name]);
			
			if (accessor) {
				accessor.setter(name, value);
			} else {
				_target[name] = value;
			}
		}		
		
	}
}
