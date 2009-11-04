package hype.framework.sound {
	import hype.framework.rhythm.AbstractRhythm;
	import hype.framework.rhythm.IRhythm;

	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	/**
	 * Analyzes sound frequency data and aggregates the resulting data
	 */
	public class SoundAnalyzer extends AbstractRhythm implements IRhythm {
		private const A:Number =  1.669;
		private const B:Number = -0.453;
		
		private var _frequencyList:Vector.<Number>;
		private var _offsetList:Vector.<Number>;
		private var _octaveList:Array;
		private var _invalid:Boolean;
		
		public function SoundAnalyzer():void {
			var i:uint;
			
			_frequencyList = new Vector.<Number>();
			_offsetList = new Vector.<Number>();
			
			for (i=0; i<256; ++i) {
				_frequencyList[i] = 0;
				_offsetList[i] = A + B * (Math.log(i) / Math.LN10);
			}	
			
			_octaveList = new Array();
			_octaveList[0] = [1, 2];
			_octaveList[1] = [2, 4];
			_octaveList[2] = [4, 10];
			_octaveList[3] = [10, 20];
			_octaveList[4] = [20, 41];
			_octaveList[5] = [41, 82];
			_octaveList[6] = [82, 163];
			_octaveList[7] = [163, 256];
		}
		
		/**
		 * @private
		 */
		public function run():void {
			_invalid = true;
		}
		
		/**
		 * Get the activity of a frequency at a specified index
		 * 
		 * @param index Index of the data to utilize (0-255)
		 * @param min Minimum value to return
		 * @param max Maximum value to return
		 * 
		 * @return Value for the specified index mapped to the min/max
		 */
		public function getFrequencyIndex(index:uint, min:Number=0, max:Number=1):Number {
			if (_invalid) {
				computeSpectrum();
				_invalid = false;
			}
			
			index = Math.max(0, index);
			index = Math.min(255, index);			
			return _frequencyList[index] * (max - min) + min;
		}
		
		/**
		 * Get the activity of a frequency range (average)
		 * 
		 * @param start Initial index of the data to utilize (0-255)
		 * @param end Last index of the data to utilize (0-255)		 * 
		 * @param min Minimum value to return
		 * @param max Maximum value to return
		 * 
		 * @return Value for the specified range mapped to the min/max
		 */		
		public function getFrequencyRange(start:uint, end:uint, min:Number=0, max:Number=1):Number {
			var i:uint;
			var value:Number = 0;
			start = Math.max(0, start);
			end = Math.min(256, end);
			
			if (_invalid) {
				computeSpectrum();
				_invalid = false;
			}			
			
			for (i=start; i<end; ++i) {
				value += _frequencyList[i];
			}
			
			value /= (end - start);
			
			value = value * (max - min) + min;
			
			return value;
		}
		
		/**
		 * Get the activity of a specific octave (0-7)
		 * 
		 * @param octave Octave to interrogate (0-7)
		 * @param min Minimum value to return
		 * @param max Maximum value to return
		 * 
		 * @return Value for the specified index mapped to the min/max
		 */		
		public function getOctave(octave:uint, min:Number=0, max:Number=1):Number {
			var value:Number = 0;
			var i:uint;
			var octaveData:Array;
			
			if (_invalid) {
				computeSpectrum();
				_invalid = false;
			}			
			
			octave = Math.min(7, Math.max(0, octave));
			octaveData = _octaveList[octave];
			
			for (i=octaveData[0]; i<octaveData[1]; ++i) {
				value = Math.max(value, _frequencyList[i]);
			}
			
			value = value * (max - min) + min;
			
			return value;
			
		}
		
		private function computeSpectrum():void {
			var data:ByteArray = new ByteArray();
			var i:uint;

			try {
				SoundMixer.computeSpectrum(data, true);
			
				for (i=0; i<256; ++i) {
					_frequencyList[i] = data.readFloat() / _offsetList[i];
				}
			
				_frequencyList[0] = _frequencyList[1];
			} catch (e:SecurityError) {
				for (i=0; i<256; ++i) {
					_frequencyList[i] = 0;
				}
			}
		}
	}
}
