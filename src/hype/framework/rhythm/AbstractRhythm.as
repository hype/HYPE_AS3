package hype.framework.rhythm {

	public class AbstractRhythm {
		public static var manager:RhythmManager;
		
		public function AbstractRhythm() {
			if (manager == null) {
				manager = new RhythmManager();
			}
			
			manager.addRhythm(this as IRhythm);
		}
		
		public function start(type:String="enter_frame", interval:uint=1):Boolean {
			return manager.startRhythm(this, type, interval);
		}
		
		public function stop():Boolean {
			return manager.stopRhythm(this);
		}
		
		public function get isRunning():Boolean {
			return manager.getRhythmInfo(this).isRunning;		
		}
		
	}
}
