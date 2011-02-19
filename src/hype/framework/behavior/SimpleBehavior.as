package hype.framework.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	/**
	 * Behavior class that runs a function at a set interval
	 */
	public class SimpleBehavior extends AbstractBehavior implements IBehavior {
		
		protected var _callback:Function;
		
		/**
		 * Constructor
		 * 
		 * @param target Target object
		 * @param callback Function to use as the behaviors run method
		 */
		public function SimpleBehavior(target:Object, callback:Function) {
			super(target);
			
			_callback = callback;
		}
		
		/**
		 * The function you to use for this behavior
		 */
		public function set callback(method:Function):void {
			_callback = method;
		}
		
		public function get callback():Function {
			return _callback;
		}		
		
		/**
		 * @protected
		 */
		public function run(target:Object):void {
			_callback(target);
		}
	}
}
