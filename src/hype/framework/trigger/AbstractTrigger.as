package hype.framework.trigger {
	import hype.framework.rhythm.RhythmManager;

	/**
	 * Abstract base class for all Triggers
	 */
	public class AbstractTrigger{
		public static var manager:RhythmManager = RhythmManager.getManager();
		
		private var _method:Function;
		private var _target:Object;
		
		/**
		 * Constructor
		 * 
		 * @param method Function to run when this trigger runs
		 * @param target Target of the trigger
		 */
		public function AbstractTrigger(method:Function, target:Object) {
			_method = method;
			_target = target;
			manager.addRhythm(this, runTrigger);
		}
		
		/**
		 * Removes all triggers from the specified object
		 * 
		 * @param object Object from which to remove all triggers
		 */
		public static function removeTriggersFromObject(object:Object):void {
			var list:Array = manager.getRhythmsOfType(AbstractTrigger);
			var max:int = list.length;
			var i:int;
			
			for (i=0; i<max; ++i) {
				if ((list[i] as AbstractTrigger).target == object) {
					manager.removeRhythm(list[i]);
				}
			}
			
		}
		
		/**
		 * Runs the trigger if it's run function returns true
		 */
		public function runTrigger():void {
			if ((this as ITrigger).run(_target)) {
				_method(_target);
			}
		}
		
		/**
		 * Start running the trigger
		 * 
		 * @param type Time type to use
		 * @param interval Interval to check the trigger
		 * 
		 * @see hype.framework.core.TimeType
		 */
		public function start(type:String="enter_frame", interval:uint=1):Boolean {
			return manager.startRhythm(this, type, interval);
		}
		
		/**
		 * Stop running the trigger
		 */
		public function stop():Boolean {
			return manager.stopRhythm(this);
		}
		
		/**
		 * Destroy the trigger
		 */
		public function destroy():void {
			_target = null;
			_method = null;
			manager.removeRhythm(this);
		}
		
		/**
		 * Boolean specifing if the trigger is running
		 */
		public function get isRunning():Boolean {
			return manager.getRhythmInfo(this).isRunning;		
		}
		
		/**
		 * Get the target of the trigger
		 */
		public function get target():Object {
			return _target;
		}
		
	}	
}