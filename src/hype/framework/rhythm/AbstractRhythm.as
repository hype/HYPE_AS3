package hype.framework.rhythm {

	/**
	 * Abstract base class for all Rhythm classes
	 */
	public class AbstractRhythm {
		public static var manager:RhythmManager = RhythmManager.getManager();
		
		/**
		 * Constructor
		 */
		public function AbstractRhythm() {
			manager.addRhythm(this as IRhythm);
		}
		
		/**
		 * Start running the rhythm
		 * 
		 * @param type Time type to use
		 * @param interval Interval to check the trigger
		 * 
		 * @see hype.framework.core.TimeType
		 */
		public function start(type:String="enter_frame", interval:uint=1):Boolean {
			return manager.startRhythm(this, type, interval);
		}
		
		/**
		 * Stop running the rhythm
		 */		
		public function stop():Boolean {
			return manager.stopRhythm(this);
		}
		
		/**
		 * Destroy this rhythm
		 */
		public function destroy():void {
			manager.removeRhythm(this as IRhythm);
		}
		
		/**
		 * Boolean specifing if the trigger is running
		 */		
		public function get isRunning():Boolean {
			return manager.getRhythmInfo(this).isRunning;		
		}
		
	}
}
