package hype.framework.behavior {
	import hype.framework.core.Accessor;
	import hype.framework.rhythm.RhythmManager;

	/**
	 * Abstract class that all Behaviors must inherit from
	 */
	public class AbstractBehavior {
		/**
		 * @protected
		 */
		public static var manager:RhythmManager = RhythmManager.getManager();
		
		protected static var _metaPropertyTable:Object;
		
		protected var _target:Object;
		
		/**
		 * Constructor
		 * 
		 * @param target Target object of this behavior
		 */
		public function AbstractBehavior(target:Object) {
			if (_metaPropertyTable == null) {
				_metaPropertyTable = new Object();
				addMetaProperty("scale", AbstractBehavior.getScale, setScale);
			}
			
			_target = target;
			
			manager.addRhythm(this, runBehavior);
		}
		
		/**
		 * Add a new meta property
		 * 
		 * @param name Name of the new meta-property
		 * @param getter Function to get the value of the meta-property
		 * @param setter Function to set the value of the meta-property
		 */
		public static function addMetaProperty(name:String, getter:Function, setter:Function):void {
			
			_metaPropertyTable[name] = new Accessor(getter, setter);
		}
		
		/**
		 * @protected
		 */
		public static function getScale(target:Object):Number {
			return target["scaleX"];
		}
		
		/**
		 * @protected
		 */
		public static function setScale(target:Object, value:Number):void {
			target["scaleX"] = target["scaleY"] = value;
		}
		
		/**
		 * Remove all behaviors from the specified object
		 * 
		 * @param object Object to remove all behaviors from
		 */
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
		
		/**
		 * @protected
		 */
		public function runBehavior():void {
			(this as IBehavior).run(_target);
		}
		
		/**
		 * Store this behavior by name
		 * 
		 * @param name Name of this behavior
		 */
		public function store(name:String):void {
			BehaviorStore.store(this, name);
		}
		
		/**
		 * Start running this behavior
		 * 
		 * @param type Time type to use
		 * @param interval Interval to run the behavior
		 * 
		 * @see hype.framework.core.TimeType
		 */
		public function start(type:String="enter_frame", interval:uint=1):Boolean {
			return manager.startRhythm(this, type, interval);
		}
		
		public function resume():Boolean {
			return manager.startRhythm(this);
		}
		
		/**
		 * Stop the behavior
		 */
		public function stop():Boolean {
			return manager.stopRhythm(this);
		}
		
		/**
		 * Destroy the behavior
		 */
		public function destroy():void {
			_target = null;
			manager.removeRhythm(this);
		}
		
		/**
		 * Flag show whether the behavior is running
		 */
		public function get isRunning():Boolean {
			return manager.getRhythmInfo(this).isRunning;		
		}
		
		/**
		 * Target of the behavior
		 */
		public function get target():Object {
			return _target;
		}
		
		/**
		 * @protected
		 */
		protected function getProperty(name:String):Number {
			var accessor:Accessor = Accessor(_metaPropertyTable[name]);
			
			if (accessor) {
				return accessor.getter(target);
			} else {
				return _target[name];
			}
		}
		
		/**
		 * @protected
		 */
		protected function setProperty(name:String, value:Number):void {
			var accessor:Accessor = Accessor(_metaPropertyTable[name]);
			
			if (accessor) {
				accessor.setter(target, value);
			} else {
				_target[name] = value;
			}
		}		
		
	}
}
