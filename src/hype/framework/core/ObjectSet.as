package hype.framework.core {
	import flash.utils.Dictionary;

	/**
	 * A set of objects. Works similarly to a mathematical set.
	 * 
	 * <p>Objects may only be in a set one time.</p>
	 */
	public final class ObjectSet {
		
		private var _head:ObjectNode;
		private var _tail:ObjectNode;
		private var _table:Dictionary;
		private var _length:int;
		
		/**
		 * Constructor
		 */
		public function ObjectSet() {
			_table = new Dictionary(true);
			_length = 0;
		}
		
		/**
		 * Number of objects in the set
		 */
		public function get length():int {
			return _length;
		}
		
		/**
		 * Clone the set
		 * 
		 * @return The new copy of this ObjectSet
		 */
		public function clone():ObjectSet {
			var node:ObjectNode = _head;
			var s:ObjectSet = new ObjectSet();
			
			while (node) {
				s.insert(node.obj);
				node = node.next;
			}
			
			return s;		
		}		
		
		/**
		 * Destroy the set
		 */
		public function destroy():void {
			var node:ObjectNode = _head;
			var nextNode:ObjectNode;
			var obj:Object;
			
			while(node) {
				nextNode = node.next;
				obj = node.obj;
				node.next = null;
				node.prev = null;
				node.obj = null;
				_table[obj] = null;
				delete _table[obj];
				
				node = nextNode;	
			}
			
			_length = 0;
			_head = null;
			_tail = null;
		}
		
		/**
		 * Insert an object into the set
		 * 
		 * @return Whether the object was added to the set
		 */
		public function insert(obj:Object):Boolean {
			var node:ObjectNode = new ObjectNode(obj);
			
			if (_table[obj] == null) {
				
				_table[obj] = node;
				
				if (_tail == null) {
					_head = _tail = node;
				} else {
					_tail.next = node;
					node.prev = _tail;
					_tail = node;
				}
				
				++_length;
				
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Remove a particular object from the set
		 * 
		 * @param object Object to remove from the set
		 * 
		 * @return Whether the object was removed successfully
		 */
		public function remove(obj:Object):Boolean {
			var node:ObjectNode = ObjectNode(_table[obj]);
			
			if (node == null)  {
				return false;
			} else {
				
				if (node == _head) {
					_head = node.next;
				}
				
				if (node == _tail) {
					_tail = node.prev;
				}
				
				if (node.prev) {
					node.prev.next = node.next;
				}
				
				if (node.next) {
					node.next.prev = node.prev;
				}
				
				node.next = null;
				node.prev = null;
				node.obj = null;
				_table[obj] = null;
				delete _table[obj];
				--_length;
				
				return true;
			}
		}
		
		/**
		 * Remove an object from the set and return it
		 * 
		 * @return Object removed from the set, null if the set is empty
		 */
		public function pull():Object {
			var obj:Object;
			var oldNode:ObjectNode;
		
			if (_tail != null) {
				oldNode = _tail;
				obj = _tail.obj;
				_tail = _tail.prev;
				
				if (_tail != null) {
					_tail.next = null;
				} 
				
				oldNode.obj = null;
				oldNode.next = null;
				oldNode.prev = null;
				_table[obj] = null;
				delete _table[obj];
				--_length;
				
				return obj;
			} else {
				return null;
			}
		}
		
		/**
		 * Run a function on every element of the set
		 * 
		 * @param f Function to run on every element of the set
		 */
		public function forEach(f:Function):void {
			var node:ObjectNode = _head;

			while (node) {
				f(node.obj);
				node = node.next;
			}		
		}
		
		/**
		 * Filter elements of the current set to make a new set
		 * 
		 * <p>Runs a function on every element of the set, if it returns true
		 * that object is included in the result set</p>
		 * 
		 * @param f Function to use for filtering
		 * 
		 * @return The new, filtered set
		 */
		public function filter(f:Function):ObjectSet {
			var node:ObjectNode = _head;
			var s:ObjectSet = new ObjectSet();
			
			while (node) {
				if (f(node.obj)) {
					s.insert(node.obj);
				}
				node = node.next;
			}
			
			return s;
		}
		
		/**
		 * Check to see if the set contains a particular object
		 * 
		 * @param object Object to check
		 * 
		 * @return Whether the set contains the object
		 */
		public function contains(object:Object):Boolean {
			return _table[object] != null;
		}		
		
		/**
		 * Determines in the input is a strict subset of this set.
		 * 
		 * @param input Set to test
		 * 
		 * @return Whether the input set is a subset of this set
		 */
		public function isSubset(input:ObjectSet):Boolean {
			var node:ObjectNode = _head;
			var result:Boolean = true;
			
			while (node) {
				if(!input.contains(node.obj)) {
					result = false;
					break;
				}
				node = node.next;
			}
			
			return result;			
		}
		
		/**
		 * Combines this set with another (avoiding duplicates) and returns 
		 * the result.
		 * 
		 * @param input Set to combine with this set
		 * 
		 * @return Combination of this set and input set
		 */
		public function union(input:ObjectSet):ObjectSet {
			var node:ObjectNode = _head;
			var output:ObjectSet = input.clone();
			
			while (node) {
				if(!output.contains(node.obj)) {
					output.insert(node.obj);
				}
				node = node.next;
			}
			
			return output;		
		}
		
		/**
		 * Determines which objects this set and the input set share, and 
		 * returns a new set containing those shared objects
		 * 
		 * @param input Set to intersect against
		 * 
		 * @return Intersection set of this set and the input
		 */
		public function intersection(input:ObjectSet):ObjectSet {
			var node:ObjectNode = _head;
			var output:ObjectSet = new ObjectSet();
			
			while (node) {
				if(input.contains(node.obj)) {
					output.insert(node.obj);
				}
				node = node.next;
			}
			
			return output;			
		}
		
		/**
		 * Determines the complement (objects in this set that AREN'T in the
		 * input set) and returns it as a new set
		 * 
		 * @param input Set to complement against
		 * 
		 * @return Complement set of this set and the input
		 */
		public function complement(input:ObjectSet):ObjectSet {
			var node:ObjectNode = _head;
			var output:ObjectSet = new ObjectSet();
			
			while (node) {
				if(!input.contains(node.obj)) {
					output.insert(node.obj);
				}
				node = node.next;
			}
			
			return output;			
		}
	}
}
