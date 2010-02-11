package hype.framework.rhythm {

	/**
	 * @private
	 */
	public class RhythmInfo {
		public var rhythm:Object;
		public var method:Function;
		public var type:String;
		public var interval:uint;
		public var timerId:int;
		public var isRunning:Boolean;
		public var counter:uint;
		
		public var prev:RhythmInfo;
		public var next:RhythmInfo;
		
		private var _manager:RhythmManager;
		
		public function RhythmInfo(manager:RhythmManager, rhythm:Object, method:Function) {
			_manager = manager;
			this.rhythm = rhythm;
			this.method = method;
			
			timerId = 0;
			isRunning = false;
			counter = 0;
		}
		
		public function destroy():void {
			_manager = null;
			rhythm = null;
			type = null;
			timerId = -1;
			interval = 0;
			method = null;
			prev = null;
			next = null;
			isRunning = false;
			counter = 0;
		}

		public function toString():String {
			var str:String;
			str = (prev == null) ? "   " : "<- ";
			str += type;
			str += (next == null) ? "   " : " ->";
			
			return str;
		}
	}
}
