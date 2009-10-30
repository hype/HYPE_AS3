package hype.framework.trigger {
	import hype.framework.trigger.AbstractTrigger;
	import hype.framework.trigger.ITrigger;

	/**
	 * Trigger class that runs a function at a set interval
	 */
	public class SimpleTrigger extends AbstractTrigger implements ITrigger {
		
		private var _callback:Function;
		
		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param callback Function to use as the triggers run method
		 */
		public function SimpleTrigger(method:Function, target:Object, callback:Function) {
			super(method, target);
			
			_callback = callback;
		}
		
		/**
		 * The function you to use for this trigger
		 */
		public function set callback(method:Function):void {
			_callback = method;
		}
		
		public function get callback():Function {
			return _callback;
		}		
		
		/**
		 * @private
		 */
		public function run(target:Object):Boolean {
			return _callback(target);
		}
	}
}
