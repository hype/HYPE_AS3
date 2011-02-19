package hype.framework.core {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.trigger.AbstractTrigger;

	/**
	 * Creates and manages pools of objects
	 */
	public class ObjectPool {	
		protected var _classList:Array;
		protected var _max:uint;
		protected var _count:uint;
		protected var _activeSet:ObjectSet;
		protected var _inactiveSet:ObjectSet;
		
		/**
		 * Whether to automatically attempt to remove any triggers and behaviors on an object when it is released back into the pool (defaults to true)
		 */		
		public var autoClean:Boolean = true;		
		
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
				_classList = [content as Class];
			} else if (content is Array) {
				_classList = content as Array;
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
		 * Destroy the ObjectPool and remove all callbacks
		 */		
		public function destroy():void {
			_classList = null;
			_activeSet.destroy();
			_activeSet = null;
			_inactiveSet.destroy();
			_inactiveSet = null;
			onCreateObject = onRequestObject = onReleaseObject = null;
		}		
				
		/**
		 * Add an additional class
		 * 
		 * @param objectClass class you would like to add
		 * @param numTimes Number of times to add the class (defaults to 1)
		 */		
		 public function addClass(objectClass:Class, numTimes:uint=1):void {
		 	var i:int;
		 	
		 	for (i=0; i<numTimes; ++i) {
		 		_classList.push(objectClass);
		 	}
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
				obj = makeRandomObject();
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

				if (autoClean) {
					AbstractBehavior.removeBehaviorsFromObject(object);
					AbstractTrigger.removeTriggersFromObject(object);
				}
				onReleaseObject(object);
				
				return true;
			} else {
				return false;
			}
		}
		
		protected function makeRandomObject():Object {
			var i:int = int(Math.random() * _classList.length);
			return new _classList[i];
		}
	}
}
