package hype.framework.behavior {

	/**
	 * Interface all Behaviors must implement
	 */
	public interface IBehavior {
		
		/**
		 * Runs the behavior
		 * 
		 * @param target Target of the behavior
		 */
		function run(target:Object):void;
	}
}
