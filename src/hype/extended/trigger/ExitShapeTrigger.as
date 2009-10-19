package hype.extended.trigger {
	import hype.framework.trigger.AbstractTrigger;
	import hype.framework.trigger.ITrigger;

	import flash.display.DisplayObject;

	/**
	 * @author 
	 */
	public class ExitShapeTrigger extends AbstractTrigger implements ITrigger {
		private var _shape:DisplayObject;
		private var _shapeFlag:Boolean;
		private var _enterFlag:Boolean;
		
		
		public function ExitShapeTrigger(method:Function, target:Object, shape:DisplayObject, shapeFlag:Boolean=false) {
			super(method, target);
			_shape = shape;
			_shapeFlag = shapeFlag;
			
			_enterFlag = false;
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
