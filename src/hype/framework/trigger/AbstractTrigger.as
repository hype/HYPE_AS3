package hype.framework.trigger {
	import hype.framework.rhythm.AbstractRhythm;
	import hype.framework.rhythm.RhythmManager;

	public class AbstractTrigger{
		public static var manager:RhythmManager;
		
		private var _method:Function;
		private var _target:Object;
		
		public function AbstractTrigger(method:Function, target:Object) {
			if (AbstractRhythm.manager == null) {
				AbstractRhythm.manager = new RhythmManager();
			}
			
			if (manager == null) {
				manager = AbstractRhythm.manager;
			}
			
			_method = method;
			_target = target;
			manager.addRhythm(this, runTrigger);
		}
		
		public static function removeTriggersFromObject(object:Object):void {
			var list:Array = manager.getRhythmsOfType(AbstractTrigger);
			var max:int = list.length;
			var i:int;
			
			for (i=0; i<max; ++i) {
				if ((list[i] as AbstractTrigger).target == object) {
					manager.removeRhythm(list[i]);
				}
			}
			
		}
		
		public function runTrigger():void {
			if ((this as ITrigger).run(_target)) {
				_method(_target);
			}
		}
		
		public function start(type:String="enter_frame", interval:uint=1):Boolean {
			return manager.startRhythm(this, type, interval);
		}
		
		public function stop():Boolean {
			return manager.stopRhythm(this);
		}
		
		public function destroy():void {
			_target = null;
			_method = null;
			manager.removeRhythm(this);
		}
		
		public function get isRunning():Boolean {
			return manager.getRhythmInfo(this).isRunning;		
		}
		
		public function get target():Object {
			return _target;
		}
		
	}	
}