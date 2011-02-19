package hype.framework.interactive {
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	 * Maps functions to key combinations 
	 */
	public class HotKey {
		protected var _owner:InteractiveObject;
		protected var _comboTable:Dictionary;
		protected var _keyCodeTable:Object;
		protected var _charCodeTable:Object;
		
		/**
		 * Constructor
		 * 
		 * @param owner InteractiveObject to listen to for keyboard events 
		 * (usually an instance of Stage)
		 */
		public function HotKey(owner:InteractiveObject) {
			_owner = owner;
			_owner.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			_owner.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			
			_comboTable = new Dictionary();
			_keyCodeTable = new Object();
			_charCodeTable = new Object();
		}
		
		/**
		 * Destroy all listeners used by this instance and clear out all data
		 * Note: Any further calls will result in runtime errors!
		 */
		 public function destroy():void {
		 	_owner.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		 	_owner.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		 	
		 	_comboTable = null;
			_keyCodeTable = null;
			_charCodeTable = null;
		 }
		
		/**
		 * Setup a function to be triggerd by a key combination
		 * 
		 * @param callback Function to call
		 * @param key The keyboard code to listen for
		 * @param ...rest Additional keyboard codes to listen for 
		 */
		public function addHotKey(callback:Function, key:*, ...rest):void {
			var max:uint = rest["length"];
			var i:uint;
			var keyList:Array;
			
			keyList = new Array();
			keyList[0] = parseKey(key);
			
			for (i=0; i<max; ++i) {
				keyList.push(parseKey(rest[i]));
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
			return (_keyCodeTable[code] == true);
		}

		/**
		 * Check to see if a specific character key is currently pressed down
		 * 
		 * @param char Character to check
		 * 
		 * @return Whether the key in question is currently pressed 
		 */
		public function isCharDown(char:String):Boolean {
			return (_charCodeTable[char.toLowerCase().charCodeAt(0)] == true);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void {
			var comboList:Array;
			var i:uint;
			var numKeys:uint;
			var found:Boolean;
			var data:KeyData;
			
			if (_keyCodeTable[event.keyCode] != true) {
				_keyCodeTable[event.keyCode] = true;
				_charCodeTable[event.charCode] = true;
				
				for (var f:* in _comboTable) {
					comboList = _comboTable[f];
					numKeys = comboList.length;

					found = true;
					for(i=0; i<numKeys; ++i) {
						data = comboList[i];
						
						if (data.isKeyCode) {						
							if (_keyCodeTable[data.code] != true) {
								found = false;
								break;
							}
						} else {
							if (_charCodeTable[data.code] != true) {
								found = false;
								break;
							}
						}
					}
					
					if (found) {
						f();
					}
				}
			}		
		}
		
		protected function onKeyUp(event:KeyboardEvent):void {
			delete _keyCodeTable[event.keyCode];
			delete _charCodeTable[event.charCode];
		}
		
		protected function parseKey(key:*):KeyData {
			if (key is int) {				
				return new KeyData(int(key), true);
				
			} else if (key is String) {			
				return new KeyData(String(key).toLowerCase().charCodeAt(0), false);
					
			} else {
				
				throw new Error("Bad keycode/character");
				return null;
			}
		}
	}
}
