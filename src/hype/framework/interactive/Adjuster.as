package hype.framework.interactive {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author 
	 */
	public class Adjuster extends Sprite {
		private var _activeClip:Sprite;
		private var _hotKey:HotKey;
		
		public function Adjuster() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			_hotKey = new HotKey(stage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDeselect);
		}
		
		public function add(clip:Sprite):void {
			clip.addEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
			clip.mouseEnabled = true;
			clip.mouseChildren = false;
		}
		
		public function remove(clip:Sprite):void {
			clip.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
			clip.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
			
			if (clip == _activeClip) {
				graphics.clear();
				
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTrackClip);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onDropClip);
				
			}
		}
		
		private function onSelectClip(event:MouseEvent):void {
			var clip:Sprite = event.target as Sprite;
			
			if (_activeClip) {
				_activeClip.addEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
				_activeClip.removeEventListener(MouseEvent.MOUSE_DOWN, onInteractClip);
			}
			
			_activeClip = clip;
			drawBoundingBox();
			
			_activeClip.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
			_activeClip.addEventListener(MouseEvent.MOUSE_DOWN, onInteractClip);
			
			_hotKey.addHotKey(removeClip, Keyboard.BACKSPACE);
			
			event.stopPropagation();
		}
		
		private function removeClip():void {
			_activeClip.parent.removeChild(_activeClip);
			graphics.clear();
			_activeClip = null;
		}
		
		private function onInteractClip(event:MouseEvent):void {
			_activeClip.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onTrackClip);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropClip);
			event.stopPropagation();
		}
		
		private function onTrackClip(event:MouseEvent):void {
			drawBoundingBox();
			event.updateAfterEvent();
		}
		
		private function onDropClip(event:MouseEvent):void {
			_activeClip.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTrackClip);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDropClip);			
		}
		
		private function onDeselect(event:MouseEvent):void {
			if (_activeClip) {
				_activeClip.addEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
				_activeClip.removeEventListener(MouseEvent.MOUSE_DOWN, onInteractClip);
			}			
			
			graphics.clear();
			_activeClip = null;
		}
		
		private function drawBoundingBox():void {
			var rect:Rectangle = _activeClip.getBounds(stage);
			graphics.clear();
			
			graphics.lineStyle(0, 0xFF0033);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);			
		}
	}
}
