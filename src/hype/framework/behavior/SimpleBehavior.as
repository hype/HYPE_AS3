package hype.framework.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	public class SimpleBehavior extends AbstractBehavior implements IBehavior {
		
		private var _callback:Function;
		
		public function SimpleBehavior(target:Object, method:Function) {
			super(target);
			
			_callback = method;
		}
		
		public function run(target:Object):void {
			_callback(this, target);
		}
	}
}
