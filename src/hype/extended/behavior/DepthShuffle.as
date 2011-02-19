package hype.extended.behavior {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	import flash.display.DisplayObjectContainer;

	/**
	 * Change the depth of a target DisplayObjectContainer's children
	 */
	public class DepthShuffle extends AbstractBehavior implements IBehavior {
		protected var _method:Function;
		
		public function DepthShuffle(target:Object, method:Function) {
			super(target);
			
			_method = method;
		}
		
		public function run(target:Object):void {
			_method(target as DisplayObjectContainer);
		}
		
		/**
		 * Method to use
		 */
		public function set method(value:Function):void {
			_method = value;
		}
		
		/**
		 * Built-in shuffle method - reverse depths
		 */
		public static function REVERSE(container:DisplayObjectContainer):void {
			var max:int = container.numChildren;
			var half:int = container.numChildren / 2;
			var i:int;
			
			for (i=0; i<half; ++i) {
				container.swapChildrenAt(i, max - i - 1);
			}			
		}
		
		/**
		 * Built-in shuffle method - randomize depths
		 */
		public static function RANDOM(container:DisplayObjectContainer):void {
			var max:int = container.numChildren;
			var i:int;
			
			for (i=0; i<max; ++i) {
				container.swapChildrenAt(i, int(Math.random() * max));
			}
		}
		
		/**
		 * Built-in shuffle method - pop off top display object, move to bottom
		 */
		public static function UP(container:DisplayObjectContainer):void {
			var max:int = container.numChildren;
			
			container.setChildIndex(container.getChildAt(max - 1), 0);
		}
		
		/**
		 * Built-in shuffle method - pop off bottom display object, move to top
		 */
		public static function DOWN(container:DisplayObjectContainer):void {
			var max:int = container.numChildren;
			
			container.setChildIndex(container.getChildAt(0), max - 1);			
		}						
	}
}
