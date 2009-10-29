package hype.framework.behavior {
	import flash.utils.Dictionary;

	/**
	 * Global store that can hold behaviors by target and name
	 * 
	 * @see hype.framework.behavior.AbstractBehavior#store AbstractBehavior.store()
	 */
	public class BehaviorStore {
		
		private static var _table:Dictionary = new Dictionary(true);
		
		/**
		 * Store a behavior
		 * 
		 * @param name Name to store the behavior under
		 * @param behavior The behavior to store
		 */
		public static function store(behavior:AbstractBehavior, name:String):void {
			if (_table[behavior.target] == null) {
				_table[behavior.target] = new Object();
			}
		
			_table[behavior.target][name] = behavior;	
		}
		
		/**
		 * Get a behavior from the store
		 * 
		 * @param target Object which the behavior targets
		 * @param name Name of the behavior
		 * 
		 * @return The behavior, null if not found
		 */
		public static function retrieve(target:Object, name:String):AbstractBehavior {
			var targetTable:Object = _table[target];
			
			if (targetTable) {
				return targetTable[name];
			} else {
				return null;
			}
		}
		
		/**
		 * Remove a behavior from the store
		 * 
		 * @param target Object which the behavior targets
		 * @param name Name of the behavior
		 * 
		 * @return Whether the behavior was found and removed successfully
		 */
		public static function remove(target:Object, name:String):Boolean {
			var targetTable:Object = _table[target];
			
			if (targetTable && targetTable[name]) {
				targetTable[name] = null;
				delete targetTable[name];
					
				return true;
			} else {
				return false;
			}			
		}
	}
}
