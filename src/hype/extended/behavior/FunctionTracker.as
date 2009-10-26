package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	/**
	 * Behavior that runs a specific function and maps it to a property of the target object
	 */
	public class FunctionTracker extends AbstractBehavior implements IBehavior {
		private var _prop:String;
		private var _f:Function;
		private var _argumentList:Array;
		
		/**
		 * Constructor
		 * 
		 * @prop target Target object
		 * @prop prop Property of the target object to change
		 * @prop f Function to run
		 * @prop argumentList Array of arguments to send to the function
		 */
		public function FunctionTracker(target:Object, prop:String, f:Function, argumentList:Array) {
			super(target);
			
			_prop = prop;
			_f = f;
			_argumentList = argumentList;
		}
		
		/**
		 * Arguments to send to the function
		 */
		public function get argumentList():Array {
			return _argumentList;
		}
		
		public function set argumentList(list:Array):void {
			_argumentList = list;
		}
		
		/**
		 * @private
		 */
		public function run(target:Object) : void {
			var value:Number = _f.apply(null, _argumentList);
			
			setProperty(_prop, value);
		}
	}
}
