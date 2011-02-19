package hype.extended.trigger {
	import hype.framework.trigger.AbstractTrigger;
	import hype.framework.trigger.ITrigger;

	import flash.display.DisplayObject;

	/**
	 * Trigger that fires when an object has exited from a shape.
	 */
	public class ExitShapeTrigger extends AbstractTrigger implements ITrigger {
		protected var _shape:DisplayObject;
		protected var _shapeFlag:Boolean;
		protected var _enterFlag:Boolean;
		
		
		/**
		 * Constructor
		 * 
		 * @param callback Function to call when this trigger fires
		 * @param target Target object to track
		 * @param shape DisplayObject that defines the shape
		 * @param enterOnceFlag True if the target must enter the shape at least once to fire trigger 
		 * @param shapeFlag True if the actual shape of the shape is to be used (defaults to false)
		 * @param enterOnceFlag True if the object must enter the shape at least once (defaults to false)
		 */
		public function ExitShapeTrigger(callback:Function, target:Object, shape:DisplayObject, shapeFlag:Boolean=false, enterOnceFlag:Boolean=false) {
			super(callback, target);
			_shape = shape;
			_shapeFlag = shapeFlag;
			
			_enterFlag = !enterOnceFlag;
		}
		
		public function run(target:Object):Boolean {
			var result:Boolean = false;
			var displayTarget:DisplayObject = target as DisplayObject;
			
			if (_shape.hitTestPoint(displayTarget.x, displayTarget.y, _shapeFlag)) {
				_enterFlag = true;
			} else if (_enterFlag) {
				result = true;
			}
			
			return result;
		}
	}
}
