package hype.framework.core {

	public class ObjectPool {
		
		private var _objectClass:Class;
		private var _max:uint;
		private var _count:uint;
		private var _activeSet:ObjectSet;
		private var _inactiveSet:ObjectSet;
		
		public var onCreate:Function;
		public var onRequest:Function;
		public var onRelease:Function;
		
		public function ObjectPool(objectClass:Class, max:uint) {
			_objectClass = objectClass;
			_max = max;
			_count = 0;
			
			_activeSet = new ObjectSet();
			_inactiveSet = new ObjectSet();
		}
		
		public function get activeSet():ObjectSet {
			return _activeSet;
		}
		
		public function request():Object {
			var obj:Object;
			
			if (_inactiveSet.length > 0) {
				obj = _inactiveSet.pull();
				_activeSet.insert(obj);
				onRequest(this, obj);
				
				return obj;
			} else if (_count < _max) {
				obj = new _objectClass();
				++_count;
				_activeSet.insert(obj);
				onCreate(this, obj);
				onRequest(this, obj);
				
				return obj;
			} else {
				return null;
			}
		}
		
		public function createAll():void {
			while(_count < _max) {
				request();
			}
		}
		
		public function release(obj:Object):Boolean {
			if (_activeSet.remove(obj)) {
				_inactiveSet.insert(obj);
				onRelease(this, obj);
				
				return true;
			} else {
				return false;
			}
		}
	}
}
