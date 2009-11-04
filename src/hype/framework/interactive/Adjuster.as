package hype.framework.interactive {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * An global adjuster that allows users to move and delete Sprites.
	 * 
	 * <p>A Sprite that's been added to an Adjuster can be selected (it will
	 * get a highlight) and can then be dragged around or deleted by pressing
	 * the backspace key.</p>
	 */
	public class Adjuster extends Sprite {
		private var _activeClip:Sprite;
		private var _hotKey:HotKey;
		
		/**
		 * Constructor
		 */
		public function Adjuster() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		private function onAddedToStage(event:Event):void {
			_hotKey = new HotKey(stage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDeselect, false, 0, true);
		}
		
		/**
		 * Add a sprite to be controlled by this Adjuster
		 * 
		 * @param clip The Sprite to add
		 */
		public function add(sprite:Sprite):void {
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onSelectClip, false, 0, true);
			sprite.mouseEnabled = true;
			sprite.mouseChildren = false;
		}
		
		/**
		 * Remove a sprite from control by this Adjuster
		 * 
		 * @param sprite The Sprite to remove
		 */
		public function remove(sprite:Sprite):void {
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
			
			if (sprite == _activeClip) {
				graphics.clear();
				
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTrackClip);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onDropClip);
				
			}
		}
		
		private function onSelectClip(event:MouseEvent):void {
			var clip:Sprite = event.target as Sprite;
			
			if (_activeClip) {
				_activeClip.addEventListener(MouseEvent.MOUSE_DOWN, onSelectClip, false, 0, true);
				_activeClip.removeEventListener(MouseEvent.MOUSE_DOWN, onInteractClip);
			}
			
			_activeClip = clip;
			drawBoundingBox();
			
			_activeClip.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectClip);
			_activeClip.addEventListener(MouseEvent.MOUSE_DOWN, onInteractClip, false, 0, true);
			
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
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onTrackClip, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropClip, false, 0, true);
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
				_activeClip.addEventListener(MouseEvent.MOUSE_DOWN, onSelectClip, false, 0, true);
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
