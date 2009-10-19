package hype.framework.interactive {
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	 * @author 
	 */
	public class HotKey {
		private var _owner:InteractiveObject;
		private var _comboTable:Dictionary;
		private var _keyTable:Object;
		
		public function HotKey(owner:InteractiveObject) {
			_owner = owner;
			_owner.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_owner.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_comboTable = new Dictionary();
			_keyTable = new Object();
		}
		
		public function addHotKey(f:Function, key:uint, ...rest):void {
			var max:uint = rest["length"];
			var i:uint;
			var keyList:Array;
			
			keyList = new Array();
			keyList[0] = key;
			
			for (i=0; i<max; ++i) {
				keyList.push(rest[i]);
			}
			
			_comboTable[f] = keyList;
		}
		
		public function removeHotKey(f:Function):Boolean {
			if (_comboTable[f] != null) {
				_comboTable[f] = null;
				return true;
			} else {
				return false;
			}
		}
		
		public function isKeyDown(id:uint):Boolean {
			return (_keyTable[id] == true);
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			var comboList:Array;
			var i:uint;
			var numKeys:uint;
			var found:Boolean;		
			
			if (_keyTable[event.keyCode] != true) {
				_keyTable[event.keyCode] = true;
				
				for (var f:* in _comboTable) {
					comboList = _comboTable[f];
					numKeys = comboList.length;

					found = true;
					for(i=0; i<numKeys; ++i) {
						if (_keyTable[comboList[i]] != true) {
							found = false;
							break;
						}
					}
					
					if (found) {
						f();
					}
				}
			}		
		}
		
		private function onKeyUp(event:KeyboardEvent):void {
			delete _keyTable[event.keyCode];
		}
	}
}
