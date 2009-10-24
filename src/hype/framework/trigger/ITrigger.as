package hype.framework.trigger {

	/**
	 * Interfaces all triggers must implement
	 */
	public interface ITrigger {
		
		/**
		 * Method to run when determining if the trigger should run
		 * 
		 * @param target Target object for the trigger
		 * 
		 * @returns Boolean Whether the trigger should run
		 */
		function run(target:Object):Boolean;
	}
}
