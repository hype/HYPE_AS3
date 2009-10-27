package hype.framework.core {

	/**
	 * @private
	 */
	public final class ObjectNode {
		public var obj:Object;
		public var next:ObjectNode;
		public var prev:ObjectNode;
		
		public function ObjectNode(obj:Object) {
			this.obj = obj;
			next = null;
			prev = null;
		}
	}
}
