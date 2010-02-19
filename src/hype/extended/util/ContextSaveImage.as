package hype.extended.util {
	import hype.framework.canvas.encoder.AbstractCanvasEncoder;
	import hype.framework.canvas.encoder.PNGCanvasEncoder;
	import hype.framework.display.BitmapCanvas;
	import hype.framework.rhythm.SimpleRhythm;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;

	/**
	 * Convenience class for adding context-menu encoding and saving of images from BitmapCanvas instances.
	 */
	public class ContextSaveImage {
		private static const BAR_WIDTH:Number=100;
		private static const BAR_HEIGHT:Number=5;		
		private static const BAR_STEP:Number=4;
		private static const BAR_SEGMENTS:Number=30;

		private var _stage:Stage;
		private var _progressDisplay:Sprite;
		private var _encoder:AbstractCanvasEncoder;
		private var _canvas:BitmapCanvas;
		private var _encodeMenu:ContextMenu;
		private var _encodeItem:ContextMenuItem;
		private var _saveMenu:ContextMenu;
		private var _saveItem:ContextMenuItem;
		private var _waitMenu:ContextMenu;
		private var _waitItem:ContextMenuItem;	
		private var _data:ByteArray;
		private var _busyOffset:int=0;
		private var _busyRhythm:SimpleRhythm;
		private var _menuOwner:InteractiveObject;	

		private var _fileReference:FileReference;

		/**
		 * Callback for when encoding starts
		 */			
		public var onEncodeStart:Function;

		/**
		 * Callback for encoding progress, passed percent complete
		 */			
		public var onEncodeProgress:Function;

		/**
		 * Callback for when encoding is complete
		 */			
		public var onEncodeComplete:Function;

		/**
		 * Callback for when save is complete
		 */			
		public var onSaveComplete:Function;

		/**
		 * Callback for when a save errors
		 */			
		public var onSaveError:Function;

		/**
		 * Callback for when a save is canceled
		 */			
		public var onSaveCancel:Function;

		/**
		 * Constructor
		 * 
		 * @param canvas Instance of ICanvas to use
		 * @param encoderClass encoder to use
		 * @param owner owner of the menu (only needed if your canvas is not on the stage)
		 */
		public function ContextSaveImage(canvas:BitmapCanvas, encoderClass:Class=null, owner:InteractiveObject=null) {
			
			if (owner == null) {
				_stage = canvas.stage;
			} else {
				_stage = owner.stage;
			}
			
			if (_stage == null) {
				throw new Error("HYPE Error: Either canvas must be attached to stage or stage parameter must be specified");
			}
			
			_progressDisplay = new Sprite();

			_canvas = canvas;
			
			_busyRhythm = new SimpleRhythm(drawBusy);
			
			if (encoderClass == null) {
				encoderClass = PNGCanvasEncoder;
			}
			
			_encoder = (new encoderClass() as AbstractCanvasEncoder);
			_encoder.onEncodeProgress = onContextEncodeProgress;
			_encoder.onEncodeComplete = onContextEncodeComplete;
			
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.COMPLETE, onContextSaveComplete);
			_fileReference.addEventListener(IOErrorEvent.IO_ERROR, onContextSaveError);
			_fileReference.addEventListener(Event.CANCEL, onContextSaveCancel);
			
			_encodeMenu = new ContextMenu();
			_encodeItem = new ContextMenuItem("Encode " + _encoder.fileExtension + "...");
			_encodeMenu.hideBuiltInItems();
			_encodeMenu.customItems.push(_encodeItem);
			_encodeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextEncode);
            
			_waitMenu = new ContextMenu();
			_waitItem = new ContextMenuItem("Please wait, encoding...");
			_waitMenu.hideBuiltInItems();
			_waitMenu.customItems.push(_waitItem);
            
			_saveMenu = new ContextMenu();
			_saveItem = new ContextMenuItem("Save " + _encoder.fileExtension + "...");
			_saveMenu.hideBuiltInItems();
			_saveMenu.customItems.push(_saveItem);
			_saveItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextSave);
             
			if (_canvas.stage) {
				_menuOwner = _canvas;
			} else {
				_menuOwner = owner;
			}
			
			_menuOwner.contextMenu = _encodeMenu;
		}

		private function onContextEncode(event:ContextMenuEvent):void {
			if (onEncodeStart != null) {
				onEncodeStart();
			}
			
			_menuOwner.contextMenu = _waitMenu;
			
			if (_canvas.largeCanvas) {
				_encoder.encode(_canvas.largeCanvas);
			} else {
				_encoder.encode(_canvas);
			}
			_canvas.stopCapture();
			
			_stage.addChild(_progressDisplay);
		}

		private function onContextEncodeProgress(percent:Number):void {
			var x:Number=(_stage.stageWidth - BAR_WIDTH) / 2;
			var y:Number=(_stage.stageHeight - BAR_HEIGHT) / 2;
			var width:Number=percent * BAR_WIDTH;
			
			_progressDisplay.graphics.clear();
			_progressDisplay.graphics.lineStyle(0, 0x000000);
			_progressDisplay.graphics.beginFill(0xFFFFFF, 0.7);
			
			_progressDisplay.graphics.drawRect(x, y, width, BAR_HEIGHT);
			
			_progressDisplay.graphics.beginFill(0x000000, 0.6);
			_progressDisplay.graphics.drawRect(x + width, y, BAR_WIDTH - width, BAR_HEIGHT);
			
			if (onEncodeProgress != null) {
				onEncodeProgress(percent);
			}
		}

		private function drawBusy(rhythm:SimpleRhythm):void {
			var segmentSize:Number=BAR_WIDTH / BAR_SEGMENTS;
			var x:Number=(_stage.stageWidth - BAR_WIDTH) / 2;
			var y:Number=(_stage.stageHeight - BAR_HEIGHT) / 2;
			var i:int;
			
			rhythm;
			
			_busyOffset = (_busyOffset + 1) % BAR_STEP;
			
			_progressDisplay.graphics.clear();
			
			for (i = 0;i < BAR_SEGMENTS;++i) {
				if ((i - _busyOffset) % BAR_STEP == 0) {
					_progressDisplay.graphics.beginFill(0xFFFFFF, 0.7);
				} else {
					_progressDisplay.graphics.beginFill(0x000000, 0.6);
				}
				
				_progressDisplay.graphics.drawRect(x + (i * segmentSize), y, segmentSize, BAR_HEIGHT);
				_progressDisplay.graphics.endFill();
			}
			
			_progressDisplay.graphics.lineStyle(0, 0x000000);
			_progressDisplay.graphics.drawRect(x, y, BAR_WIDTH, BAR_HEIGHT);

			_progressDisplay.graphics.beginFill(0x000000, 0.8);
		}

		private function onContextEncodeComplete(data:ByteArray):void {
			if (onEncodeComplete != null) {
				onEncodeComplete();
			}
			
			_progressDisplay.graphics.clear();
			_stage.removeChild(_progressDisplay);
			
			_data = data;
			_menuOwner.contextMenu = _saveMenu;
		}

		private function onContextSave(event:ContextMenuEvent):void {
			_fileReference.save(_data, "hype." + _encoder.fileExtension.toLowerCase());	
			_busyRhythm.start();
			_stage.addChild(_progressDisplay);
		}

		private function onContextSaveComplete(event:Event):void {
			_menuOwner.contextMenu = _encodeMenu;
			if(onSaveComplete != null) {
				onSaveComplete();
			}
			_busyRhythm.stop();
			_progressDisplay.graphics.clear();
			_stage.removeChild(_progressDisplay);
		}

		private function onContextSaveError(event:IOErrorEvent):void {
			_menuOwner.contextMenu = _saveMenu;
			
			if (onSaveError != null) {
				onSaveError();
			}
			
			_busyRhythm.stop();
			_progressDisplay.graphics.clear();
			_stage.removeChild(_progressDisplay);			
		}

		private function onContextSaveCancel(event:Event):void {
			_menuOwner.contextMenu = _saveMenu;
			
			if (onSaveCancel != null) {
				onSaveCancel();
			}
			
			_busyRhythm.stop();
			_progressDisplay.graphics.clear();
			_stage.removeChild(_progressDisplay);			
		}
	}
}
