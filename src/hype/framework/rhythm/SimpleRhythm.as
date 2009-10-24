package hype.framework.rhythm {
	import hype.framework.rhythm.AbstractRhythm;

	/**
	 * Rhythm class that lets you run any function at a set interval
	 */
	public class SimpleRhythm extends AbstractRhythm implements IRhythm {
		private var _callback:Function;
		
		/**
		 * Constructor
		 * 
		 * @param callback Function you want run at a set interval
		 */
		public function SimpleRhythm(callback:Function) {
			_callback = callback;
			
			super();
		}
		
		/**
		 * The function you want this rhythm to run
		 */
		public function set callback(method:Function):void {
			_callback = method;
		}
		
		public function get callback():Function {
			return _callback;
		}
		
		public function run():void {
			_callback(this);
		}
	}
}
