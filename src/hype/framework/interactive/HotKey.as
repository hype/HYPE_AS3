package hype.framework.interactive {
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	 * Maps functions to key combinations 
	 */
	public class HotKey {
		private var _owner:InteractiveObject;
		private var _comboTable:Dictionary;
		private var _keyTable:Object;
		
		/**
		 * Constructor
		 * 
		 * @param owner InteractiveObject to listen to for keyboard events 
		 * (usually an instance of Stage)
		 */
		public function HotKey(owner:InteractiveObject) {
			_owner = owner;
			_owner.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_owner.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_comboTable = new Dictionary();
			_keyTable = new Object();
		}
		
		/**
		 * Setup a function to be triggerd by a key combination
		 * 
		 * @param callback Function to call
		 * @param key The keyboard code to listen for
		 * @param ...rest Additional keyboard codes to listen for 
		 */
		public function addHotKey(callback:Function, key:uint, ...rest):void {
			var max:uint = rest["length"];
			var i:uint;
			var keyList:Array;
			
			keyList = new Array();
			keyList[0] = key;
			
			for (i=0; i<max; ++i) {
				keyList.push(rest[i]);
			}
			
			_comboTable[callback] = keyList;
		}
		
		/**
		 * Remove a funciton from keyboard control
		 * 
		 * @param callback Function to remove
		 */
		public function removeHotKey(callback:Function):Boolean {
			if (_comboTable[callback] != null) {
				_comboTable[callback] = null;
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Check to see if a specific keyboard key is currently pressed down
		 * 
		 * @param code Keyboard code of the key to check
		 * 
		 * @return Whether the key in question is currently pressed 
		 */
		public function isKeyDown(code:uint):Boolean {
			return (_keyTable[code] == true);
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
