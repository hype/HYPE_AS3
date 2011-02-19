package hype.framework.rhythm {
	import hype.framework.core.TimeType;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * Manages all Rhythms used in HYPE. You should only need to utilize this class to kill
	 * off HYPE when it's in a SWF that is being unloaded.
	 */
	public class RhythmManager {
		private static var instanceTable:Object = new Object();
		
		private var _rhythmTable:Dictionary;
		private var _enterFrameHead:RhythmInfo;
		private var _enterFrameTail:RhythmInfo;
		private var _exitFrameHead:RhythmInfo;
		private var _exitFrameTail:RhythmInfo;
		
		private var _processingFlag:Boolean;
		private var _removeList:Array;
		
		private var _helperSprite:Sprite;
		
		public function RhythmManager() {
			_rhythmTable = new Dictionary(false);
			
			_helperSprite = new Sprite();
			
			_processingFlag = false;
			_removeList = new Array();
		}
		
		/**
		 * Get a particular RhythmManager
		 * 
		 * @param name Name of the manager (defaults to "default")
		 */
		public static function getManager(name:String="default"):RhythmManager {
			if (instanceTable[name] == null) {
				instanceTable[name] = new RhythmManager();
			}
			
			return instanceTable[name];
		}
		
		/**
		 * Destroy a particular RhythmManager
		 * 
		 * @param name Name of the manager (defaults to "default")
		 */
		public static function destroyManager(name:String="default"):void {
			(instanceTable[name] as RhythmManager).destroy();			
		}
		
		/**
		 * Destroy the RhythmManager and remove all events and timers
		 * 
		 */		
		public function destroy():void {
			var p:*;
			
			for (p in _rhythmTable) {
	            removeRhythm(p);
    	    }
    	    		
			_helperSprite.removeEventListener(Event.ENTER_FRAME, processEnterFrame);
			_removeList = null;
			_enterFrameHead = null;
			_enterFrameTail = null;
			_exitFrameHead = null;
			_exitFrameTail = null;
		}
		
		public function toString():String {
			var str:String = "ENTER_FRAME\n";
			var t:RhythmInfo = _enterFrameHead;
			while (t != _enterFrameTail) {
				str += t.toString() + "\n";
				t = t.next;
			}
			str += t.toString() + "\n\n";
			
			str += "EXIT_FRAME\n";
			t = _exitFrameHead;
			while (t != _exitFrameTail) {
				str += t.toString() + "\n";
				t = t.next;
			}
			str += t.toString() + "\n\n";
			
			return str;
		}
		
		public function addRhythm(rhythm:Object, method:Function=null):Boolean {
			if (_rhythmTable[rhythm] == null) {
				if (method == null) {
					method = rhythm["run"];
				}
				
				_rhythmTable[rhythm] = new RhythmInfo(this, rhythm, method);
				return true;
			} else {
				return false;
			}
		}
		
		public function removeRhythm(rhythm:Object):Boolean {
			if (_rhythmTable[rhythm] != null) {
				if (_processingFlag) {
					_removeList.push(rhythm);
				} else {
					stopRhythm(rhythm);
					_rhythmTable[rhythm] = null;
					delete _rhythmTable[rhythm];
				}
				return true;
			} else {
				
				return false;
			}
		}
		
		public function getRhythmInfo(rhythm:Object):RhythmInfo {
			return _rhythmTable[rhythm];
		}
		
		public function getRhythmsOfType(classType:Class):Array {
			var result:Array = new Array();
			
			for (var p:* in _rhythmTable) {
				if (p is classType) {
					result.push(p);
				}
			}
			
			return result;
		}
		
		public function startRhythm(rhythm:Object, type:String=null, interval:int=-1):Boolean {
			var rhythmInfo:RhythmInfo;
			
			rhythmInfo = _rhythmTable[rhythm];
			
			if (type == null) {
				type = rhythmInfo.type;
			}
			
			if (interval == -1) {
				interval = rhythmInfo.interval;
			}
			
			if (type == null || interval == -1) {
				throw new Error("HYPE Error: You must either reuse a RhythmInfo object or specify a type and interval for the rhythm");
			}
					
			
			if (rhythmInfo != null && !rhythmInfo.isRunning && interval > 0) {
				
				switch (type) {
					case TimeType.ENTER_FRAME:
						if (_enterFrameHead == null) {
							_enterFrameHead = 
							_enterFrameTail = rhythmInfo;
						} else {
							_enterFrameTail.next = rhythmInfo;
							rhythmInfo.prev = _enterFrameTail;
							_enterFrameTail = rhythmInfo;
						}
						
						if (_enterFrameHead == _enterFrameTail) {
							_helperSprite.addEventListener(Event.ENTER_FRAME, processEnterFrame);
						}
						
						rhythmInfo.isRunning = true;
						rhythmInfo.type = type;
						rhythmInfo.interval = interval;
						
						break;
						
					case TimeType.EXIT_FRAME:
						if (_exitFrameHead == null) {
							_exitFrameHead = 
							_exitFrameTail = rhythmInfo;
						} else {
							_exitFrameTail.next = rhythmInfo;
							rhythmInfo.prev = _exitFrameTail;
							_exitFrameTail = rhythmInfo;
						}
						
						if (_exitFrameHead == _exitFrameTail) {
							_helperSprite.addEventListener(Event.EXIT_FRAME, processExitFrame);
						}
						
						rhythmInfo.isRunning = true;
						rhythmInfo.type = type;
						rhythmInfo.interval = interval;						

						break;
						
					case TimeType.TIME:
						rhythmInfo.isRunning = true;
						rhythmInfo.type = type;
						rhythmInfo.interval = interval;
						rhythmInfo.timerId = setInterval(rhythmInfo.method, interval);
				
						rhythmInfo.type = type;
						rhythmInfo.interval = interval;				
				
						break;
						
					default:
						return false;
						break;							
				}
				
				return true;
			} else {
				return false;
			}
		}
		
		public function stopRhythm(rhythm:Object):Boolean {
			var rhythmInfo:RhythmInfo;
			
			rhythmInfo = _rhythmTable[rhythm];
			
			if (rhythmInfo != null && rhythmInfo.isRunning) {
				
				switch (rhythmInfo.type) {
					case (TimeType.ENTER_FRAME):
						if (_enterFrameHead == _enterFrameTail) {
							_helperSprite.removeEventListener(Event.ENTER_FRAME, processEnterFrame);
							_enterFrameHead =
							_enterFrameTail = null;
						} else {
							
							if (rhythmInfo.prev != null) {
								rhythmInfo.prev.next = rhythmInfo.next;
								
								if (_enterFrameTail == rhythmInfo) {
									_enterFrameTail = rhythmInfo.prev;
									_enterFrameTail.next = null;
								} else {
									rhythmInfo.next.prev = rhythmInfo.prev;
								}
							}
							
							if (rhythmInfo.next != null) {
								rhythmInfo.next.prev = rhythmInfo.prev;
								
								if (_enterFrameHead == rhythmInfo) {
									_enterFrameHead = rhythmInfo.next;
									_enterFrameHead.prev = null;
								} else {
									rhythmInfo.prev.next = rhythmInfo.next;							
								}
							}
							
						}				
						break;
						
					case (TimeType.EXIT_FRAME):
						if (_exitFrameHead == _exitFrameTail) {
							_helperSprite.removeEventListener(Event.EXIT_FRAME, processExitFrame);
							_exitFrameHead =
							_exitFrameTail = null;
						} else {
							if (rhythmInfo.prev != null) {
								rhythmInfo.prev.next = rhythmInfo.next;
								
								if (_exitFrameTail == rhythmInfo) {
									_exitFrameTail = rhythmInfo.prev;
									_exitFrameTail.next = null;
								} else {
									rhythmInfo.next.prev = rhythmInfo.prev;
								}							
							}
							
							if (rhythmInfo.next != null) {
								rhythmInfo.next.prev = rhythmInfo.prev;
								
								if (_exitFrameHead == rhythmInfo) {
									_exitFrameHead = rhythmInfo.next;
									_enterFrameHead.prev = null;
								} else {
									rhythmInfo.prev.next = rhythmInfo.next;							
								}								
							}												
						}					
						break;
						
					case (TimeType.TIME):
						clearInterval(rhythmInfo.timerId);	
						break;											
				}
				
				rhythmInfo.isRunning = false;
				rhythmInfo.next = null;
				rhythmInfo.prev = null;
				
				return true;
				
			} else {
				return false;
			}
		}
		
		protected function processEnterFrame(event:Event):void {
			var rhythmInfo:RhythmInfo = _enterFrameHead;
			var nextRhythmInfo:RhythmInfo;
			
			_processingFlag = true;
			while (rhythmInfo != null) {
				nextRhythmInfo = rhythmInfo.next;
				
				++rhythmInfo.counter;
				if (rhythmInfo.counter == rhythmInfo.interval) {
					rhythmInfo.counter = 0;		
					rhythmInfo.method();
				}
				rhythmInfo = nextRhythmInfo;
			}
			
			_processingFlag = false;
			processRemovalQueue();
		}
		
		protected function processExitFrame(event:Event):void {
			var rhythmInfo:RhythmInfo = _exitFrameHead;
			var nextRhythmInfo:RhythmInfo;
			
			_processingFlag = true;
			while (rhythmInfo != null) {
				nextRhythmInfo = rhythmInfo.next;
				
				++rhythmInfo.counter;
				if (rhythmInfo.counter == rhythmInfo.interval) {
					rhythmInfo.counter = 0;
					rhythmInfo.method();
				}
				rhythmInfo = nextRhythmInfo;
			}
			
			_processingFlag = false;
			processRemovalQueue();					
		}
		
		protected function processRemovalQueue():void {
			var max:int = _removeList.length;
			var rhythm:Object;
			var i:int;
			
			for (i=0; i<max; ++i) {
				rhythm = _removeList.pop();
				stopRhythm(rhythm);
				_rhythmTable[rhythm] = null;
				delete _rhythmTable[rhythm];
			}
		}
	}
}
