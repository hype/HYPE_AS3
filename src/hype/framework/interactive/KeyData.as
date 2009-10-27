package hype.framework.interactive {

	/**
	 * @private
	 */
	public class KeyData {
		public var code:int;
		public var isKeyCode:Boolean;
		
		public function KeyData(code:int, isKeyCode:Boolean) {
			this.code = code;
			this.isKeyCode = isKeyCode;
		}
	}
}
