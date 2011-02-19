package hype.extended.trigger {
	import hype.framework.trigger.AbstractTrigger;
	import hype.framework.trigger.ITrigger;

	/**
	 * Trigger that fires randomly given a set proability.
	 */
	public class RandomTrigger extends AbstractTrigger implements ITrigger {
		protected var _chance:uint;

		/**
		 * Constructor
		 * 
		 * @param callback Function to call when this trigger fires
		 * @param target Target object to track
		 * @param chance The probabiliy
		 */		
		public function RandomTrigger(callback:Function, target:Object, chance:uint) {
			super(callback, target);
			
			_chance = chance;
		}
		
		public function run(target : Object) : Boolean {
			return (Math.floor(Math.random() * _chance) == 0);
		}
	}
}
