/**
 *
 *   Joshua Davis
 *   http://www.joshuadavis.com
 *   studio@joshuadavis.com
 *
 *   Oct 14, 2009
 *
 */
 
package hype.extended.layout {
	import hype.framework.behavior.AbstractBehavior;
	import hype.framework.behavior.IBehavior;

	import flash.utils.getDefinitionByName;

	public class ShapeLayoutComp extends AbstractBehavior implements IBehavior {
		private var _numItems:uint;
		
		private var _whichArtwork:String;
		private var _tempArtwork:Array;
		private var _myArtwork:Array;
		
		// color
		private var _letsColor:Boolean;
		private var _whichColors:String;
		private var _tempColors:Array;
		private var _myColors:Array;
		private var _colorValue:*;
		
		// base vars
		private var _baseRotation:Number;
		private var _randomRotation:Number;
		private var _minScale:Number;
		private var _maxScale:Number;
		private var _minAlpha:Number;
		private var _maxAlpha:Number;
		
		public function ShapeLayoutComp(target:Object) {
			super(target);
		}
		
		[Inspectable(name="01 number of sprites")]
		public function set numItems(value:uint):void {
			_numItems = value;
		}
		
		[Inspectable(name="02 which artwork")]
		public function set whichArtwork(value:String):void {
			_whichArtwork = value;
			_tempArtwork = _whichArtwork.split(",");
			
			_myArtwork = new Array();
			var max:Number = _tempArtwork.length;
			
			for (var i:Number=0; i<max; ++i) {
				_myArtwork[i] = getDefinitionByName(_tempArtwork[i]);
			}
		}
		
		[Inspectable(name="03 base rotation")]
		public function set baseRotation(value:uint):void {
			_baseRotation = value;
		}
		
		[Inspectable(name="04 random rotation")]
		public function set randomRotation(value:uint):void {
			_randomRotation = value;
		}
		
		[Inspectable(name="05 min scale")]
		public function set minScale(value:Number):void {
			_minScale = value;
		}

		[Inspectable(name="06 max scale")]
		public function set maxScale(value:Number):void {
			_maxScale = value;
		}
		
		[Inspectable(name="07 min alpha")]
		public function set minAlpha(value:Number):void {
			_minAlpha = value;
		}
		
		[Inspectable(name="08 max alpha")]
		public function set maxAlpha(value:Number):void {
			_maxAlpha = value;
		}
		
		[Inspectable(name="09 lets color ?")]
		public function set letsColor(value:Boolean):void {
			_letsColor = value;
		}
		
		[Inspectable(name="10 which colors")]
		public function set whichColors(value:String):void {
			_whichColors = value;
			_tempColors = _whichColors.split(",");
			
			_myColors = new Array();
			var max:Number = _tempColors.length;
			
			for (var i:Number=0; i<max; ++i) {
				_colorValue = parseInt(_tempColors[i].substr(2), 16);
				if (!isNaN(_colorValue)) {
					_myColors.push(_colorValue);
				}
			}
		}

		
		public function run(target:Object):void {
			
		}
	}
}
