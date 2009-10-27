package hype.framework.interactive {
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;

	/**
	 * @author bhall
	 */
	public class EasyButton extends SimpleButton {
		
		public var onPress:Function;
		public var onRelease:Function;
		public var onReleaseOutside:Function;
		public var onClick:Function;
		
		public function EasyButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null) {
			super(upState, overState, downState, hitTestState);
			
			onPress = 
			onRelease =
			onReleaseOutside =
			onClick = doNothing;
			
			
			addEventListener(MouseEvent.MOUSE_DOWN, handlePress, false, 0, true);
			addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}
		
		public function destroy():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			removeEventListener(MouseEvent.MOUSE_UP, handleRelease);
			removeEventListener(MouseEvent.CLICK, handleClick);
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleReleaseOutside);			
			}
		}
		
		private function handlePress (event:MouseEvent):void {
			if (stage) {
				stage.addEventListener(MouseEvent.MOUSE_UP, handleReleaseOutside, false, 0, true);			
			}
			addEventListener(MouseEvent.MOUSE_UP, handleRelease, false, 0, true);
			
			onPress();			
		}
		
		private function handleRelease (event:MouseEvent):void {
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleReleaseOutside);			
			}
			removeEventListener(MouseEvent.MOUSE_UP, handleRelease);
			
			onRelease();			
		}
		
		private function handleReleaseOutside (event:MouseEvent):void {
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleReleaseOutside);			
			}
			removeEventListener(MouseEvent.MOUSE_UP, handleRelease);
			
			onReleaseOutside();
		}
		
		private function handleClick(event:MouseEvent):void {
			onClick();
		}						
		
		private function doNothing():void {
			// do nothing;
		}
		
		
	}
}
