package hype.framework.core {

	/**
	 * @author bhall
	 */
	public class Accessor {
		public var getter:Function;
		public var setter:Function;
		
		public function Accessor(getter:Function, setter:Function):void {
			this.getter = getter;
			this.setter = setter;
		}
	}
}
