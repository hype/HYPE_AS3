package hype.framework.core {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.color.IColorist;
	import hype.framework.layout.ILayout;
	import hype.framework.trigger.AbstractTrigger;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class ObjectPool {
		
		private var _max:uint;
		private var _count:uint;
		private var _readyList:Array;
		private var _objectTable:Dictionary;
		
		public var setup:Function;
		public var create:Function;
		public var destroy:Function;
		public var layout:ILayout;
		public var colorist:IColorist;
		
		public function ObjectPool(max:uint) {
			_max = max;
			_count = 0;
			
			_readyList = new Array();
			_objectTable = new Dictionary(false);
		}
		
		public function map(f:Function):void {
			for (var p:* in _objectTable) {
				if (_readyList.indexOf(p) == -1) {
					f(p);
				}
			}
		}
		
		public function applyLayout():void {
			var pt:Point;
			
			if (layout != null) {
				for (var p:* in _objectTable) {
					if (_readyList.indexOf(p) == -1) {
						pt = layout.getNextPoint();
						(p as DisplayObject).x = pt.x;
						(p as DisplayObject).y = pt.y;
					}
				}		
			}			
		}
		
		public function applyColorist():void {
			if (colorist != null) {
				for (var p:* in _objectTable) {
					if (_readyList.indexOf(p) == -1) {
						colorist.colorChildren(p as Sprite);
					}
				}		
			}			
		}
		
		public function requestAll():void {
			var obj:Object;
			
			do {
				obj = requestObject();
			} while (obj != null);
		}
		
		public function returnAll():void {
			for (var p:* in _objectTable) {
				returnObject(p);
			}
		}
		
		public function requestObject():Object {
			var object:Object;
			var pt:Point;		

			if (_readyList.length > 0) {
				object = _readyList.shift();
			} else {
				
				if (_count < _max) {
					object = create();
					_objectTable[object] = true;
					++_count;
				}
			}	
			
			if (object != null && layout != null) {
				pt = layout.getNextPoint();
				(object as DisplayObject).x = pt.x;
				(object as DisplayObject).y = pt.y;
			}
			
			if (object != null && colorist != null) {
				colorist.colorChildren(object as Sprite);
			}
			
			if (object != null && setup != null) {	
				setup(object);
			}
				
			return object;
		}		
		
		public function returnObject(object:Object):Boolean {
			
			if (_objectTable[object] == true && _readyList.indexOf(object) == -1) {
				AbstractBehavior.removeBehaviorsFromObject(object);
				AbstractTrigger.removeTriggersFromObject(object);
				_readyList.push(object);
			
				if (destroy != null) {
					destroy(object);
				}
				
				return true;
			} else {
				return false;
			}
		}
	}
}
