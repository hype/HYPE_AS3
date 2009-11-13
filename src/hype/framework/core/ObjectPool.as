package hype.framework.core {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.trigger.AbstractTrigger;

	/**
	 * Creates and manages pools of objects
	 */
	public class ObjectPool {
		
		private var _objectClass:Class;
		private var _classList:Array;
		private var _max:uint;
		private var _count:uint;
		private var _activeSet:ObjectSet;
		private var _inactiveSet:ObjectSet;
		private var _makeObject:Function;
		
		/**
		 * Callback for when new objects are created
		 */
		public var onCreateObject:Function;
		
		/**
		 * Callback for when new objects are successfully requested
		 */
		public var onRequestObject:Function;
		
		/**
		 * Callback for when objects are released (returned to the pool)
		 */
		public var onReleaseObject:Function;
		
		/**
		 * Constructor
		 * 
		 * @param content Either a single class or array of classes (classes are chosen randomly if a list is passed)
		 * @param max The maximum number of objects to create
		 */
		public function ObjectPool(content:*, max:uint) {
			
			if (content is Class) {
				_objectClass = content as Class;
				_makeObject = makeSingleObject;
			} else if (content is Array) {
				_classList = content as Array;
				_makeObject = makeRandomObject;
			} else {
				throw new Error("Bad argument passed to ObjectPool. First argument must be class or array of classes");
			}
			_max = max;
			_count = 0;
			
			_activeSet = new ObjectSet();
			_inactiveSet = new ObjectSet();
			
			onCreateObject = onRequestObject = onReleaseObject = function(obj:Object):void{};
		}
		
		/**
		 * The active set of objects
		 */
		public function get activeSet():ObjectSet {
			return _activeSet;
		}
		
		/**
		 * Is the pool full (all objects in activeSet)
		 */
		public function get isFull():Boolean {
			return _max == _count;
		}
				
		
		/**
		 * Request a new object. If no objects are available, null is returned.
		 * 
		 * @return The new or recycled object
		 */
		public function request():Object {
			var obj:Object;
			
			if (_inactiveSet.length > 0) {
				obj = _inactiveSet.pull();
				_activeSet.insert(obj);
				onRequestObject(obj);
				
				return obj;
			} else if (_count < _max) {
				obj = _makeObject();
				++_count;
				_activeSet.insert(obj);
				onCreateObject(obj);
				onRequestObject(obj);
				
				return obj;
			} else {
				return null;
			}
		}
		
		/**
		 * Request all of the objects the pool can contain at once.
		 */
		public function requestAll():void {
			while(_count < _max) {
				request();
			}
		}
		
		/**
		 * Release an object back into the pool.
		 * 
		 * @param object The object to return to the pool
		 * 
		 * @return Whether the object was returned successfully
		 */
		public function release(object:Object):Boolean {
			if (_activeSet.remove(object)) {
				_inactiveSet.insert(object);
				AbstractBehavior.removeBehaviorsFromObject(object);
				AbstractTrigger.removeTriggersFromObject(object);
				onReleaseObject(object);
				
				return true;
			} else {
				return false;
			}
		}
		
		private function makeSingleObject():Object {
			return new _objectClass();
		}
		
		private function makeRandomObject():Object {
			var i:int = int(Math.random() * _classList.length);
			return new _classList[i];
		}
	}
}
