package hype.framework.core {

	/**
	 * Types of time tracking used within HYPE
	 */
	public class TimeType {
		/**
		 * Track time using the Event.ENTER_FRAME event
		 */
		public static const ENTER_FRAME:String = "enter_frame";
		
		/**
		 * Track time using the Event.EXIT_FRAME event
		 */
		public static const EXIT_FRAME:String = "exit_frame";
		
		/**
		 * Track time using wall (clock) time
		 */
		public static const TIME:String = "time";
	}
}
