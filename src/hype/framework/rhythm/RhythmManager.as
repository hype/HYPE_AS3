package hype.framework.rhythm {
	import hype.framework.core.TimeType;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * @private
	 */
	public class RhythmManager {
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
		
		public function startRhythm(rhythm:Object, type:String, interval:int):Boolean {
			var rhythmInfo:RhythmInfo;
			
			rhythmInfo = _rhythmTable[rhythm];
			
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
								}
							}
							
							if (rhythmInfo.next != null) {
								rhythmInfo.next.prev = rhythmInfo.prev;
								
								if (_enterFrameHead == rhythmInfo) {
									_enterFrameHead = rhythmInfo.next;
									_enterFrameHead.prev = null;
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
								}								
							}
							
							if (rhythmInfo.next != null) {
								rhythmInfo.next.prev = rhythmInfo.prev;
								
								if (_exitFrameHead == rhythmInfo) {
									_exitFrameHead = rhythmInfo.next;
									_enterFrameHead.prev = null;
								}								
							}												
						}					
						break;
						
					case (TimeType.TIME):
						clearInterval(rhythmInfo.timerId);	
						break;											
				}
				
				rhythmInfo.destroy();
				_rhythmTable[rhythm] = null;
				
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
