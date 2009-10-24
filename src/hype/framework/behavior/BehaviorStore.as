package hype.framework.behavior {
	import flash.utils.Dictionary;

	/**
	 * @author bhall
	 */
	public class BehaviorStore {
		
		private static var _table:Dictionary = new Dictionary(true);
		
		public static function store(name:String, behavior:AbstractBehavior):void {
			if (_table[behavior.target] == null) {
				_table[behavior.target] = new Object();
			}
		
			_table[behavior.target][name] = behavior;	
		}
		
		public static function retreive(target:Object, name:String):AbstractBehavior {
			var targetTable:Object = _table[target];
			
			if (targetTable) {
				return targetTable[name];
			} else {
				return null;
			}
		}
		
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
