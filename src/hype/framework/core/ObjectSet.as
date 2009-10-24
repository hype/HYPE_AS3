package hype.framework.core {
	import flash.utils.Dictionary;

	public final class ObjectSet {
		
		private var _head:ObjectNode;
		private var _tail:ObjectNode;
		private var _table:Dictionary;
		private var _length:int;
		
		public function ObjectSet() {
			_table = new Dictionary(true);
			_length = 0;
		}
		
		public function get length():int {
			return _length;
		}
		
		public function clone():ObjectSet {
			var node:ObjectNode = _head;
			var s:ObjectSet = new ObjectSet();
			
			while (node) {
				s.insert(node.obj);
				node = node.next;
			}
			
			return s;		
		}		
		
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
		
		public function insert(obj:Object):void {
			var node:ObjectNode = new ObjectNode();
			node.obj = obj;
			
			_table[obj] = node;
			
			if (null == _tail) {
				_head = _tail = node;
			} else {
				_tail.next = node;
				node.prev = _tail;
				_tail = node;
			}
			
			++_length;
		}
		
		public function remove(obj:Object):Boolean {
			var node:ObjectNode = ObjectNode(_table[obj]);
			
			if (null == node)  {
				return false;
			} else {
				node.prev.next = node.next;
				node.next.prev = node.prev;
				node.next = null;
				node.prev = null;
				node.obj = null;
				_table[obj] = null;
				delete _table[obj];
				--_length;
				
				return true;
			}
		}
		
		public function pull():Object {
			var obj:Object;
			var node:ObjectNode = _tail;
		
			if (_tail != null) {
				_tail = node.prev;
				obj = node.obj;
				node.prev.next = null;
				node.prev = null;
				node.obj = null;
				_table[obj] = null;
				delete _table[obj];
				--_length;
				
				return obj;
			} else {
				return null;
			}
		}
		
		public function forEach(f:Function):void {
			var node:ObjectNode = _head;

			while (node) {
				f(this, node.obj);
				node = node.next;
			}		
		}
		
		public function filter(f:Function):ObjectSet {
			var node:ObjectNode = _head;
			var s:ObjectSet = new ObjectSet();
			
			while (node) {
				if (f(this, node.obj)) {
					s.insert(node.obj);
				}
				node = node.next;
			}
			
			return s;
		}
		
		public function contains(obj:Object):Boolean {
			return _table[obj] != null;
		}		
		
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
