package hype.framework.rhythm {
	import hype.framework.rhythm.AbstractRhythm;

	public class SimpleRhythm extends AbstractRhythm implements IRhythm {
		private var _callback:Function;
		
		public function SimpleRhythm(method:Function) {
			_callback = method;
			
			super();
		}
		
		public function set callback(method:Function):void {
			_callback = method;
		}
		
		public function run():void {
			_callback(this);
		}
	}
}
