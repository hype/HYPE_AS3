package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	/**
	 * @author bhall
	 */
	public class FunctionTracker extends AbstractBehavior implements IBehavior {
		private var _prop:String;
		private var _f:Function;
		private var _argumentList:Array;
		
		public function FunctionTracker(target:Object, prop:String, f:Function, argumentList:Array) {
			super(target);
			
			_prop = prop;
			_f = f;
			_argumentList = argumentList;
		}
		
		public function get argumentList():Array {
			return _argumentList;
		}
		
		public function set argumentList(list:Array):void {
			_argumentList = list;
		}
		
		public function run(target:Object) : void {
			var value:Number = _f.apply(null, _argumentList);
			
			setProperty(_prop, value);
		}
	}
}
