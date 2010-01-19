package hype.extended.util {
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.Proxy;

	/**
	 * @author bhall
	 */
	public class DataProxy extends Proxy implements IDataInput {
		public function DataProxy() {
		}
		
		public function readUnsignedInt():uint {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function readShort():int {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function readDouble():Number {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function readMultiByte(length:uint, charSet:String):String {
			// TODO: Auto-generated method stub
			return null;
		}
		
		public function readFloat():Number {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function readUnsignedShort():uint {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function readBoolean():Boolean {
			// TODO: Auto-generated method stub
			return null;
		}
		
		public function readUnsignedByte():uint {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function readBytes(bytes:ByteArray, offset:uint=0, length:uint=0):void {
		}
		
		public function readUTF():String {
			// TODO: Auto-generated method stub
			return null;
		}
		
		public function readInt():int {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function readUTFBytes(length:uint):String {
			// TODO: Auto-generated method stub
			return null;
		}
		
		public function readObject():* {
		}
		
		public function readByte():int {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function get objectEncoding():uint {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function get bytesAvailable():uint {
			// TODO: Auto-generated method stub
			return 0;
		}
		
		public function get endian():String {
			// TODO: Auto-generated method stub
			return null;
		}
		
		public function set endian(type:String):void {
		}
		
		public function set objectEncoding(version:uint):void {
		}
	}
}
