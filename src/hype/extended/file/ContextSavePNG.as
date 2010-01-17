package hype.extended.file {
	import hype.framework.canvas.CanvasPNGEncoder;
	import hype.framework.display.BitmapCanvas;

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
	 * Convenience class for adding context-menu encoding and saving of PNGs from BitmapCanvas instances.
	 */
	public class ContextSavePNG {
		private static const BAR_WIDTH:Number = 100;
		private static const BAR_HEIGHT:Number = 5;		
		
		private var _stage:Stage;
		private var _progressDisplay:Sprite;
		private var _encoder:CanvasPNGEncoder;
		private var _canvas:BitmapCanvas;
		private var _encodeMenu:ContextMenu;
		private var _encodeItem:ContextMenuItem;
		private var _saveMenu:ContextMenu;
		private var _saveItem:ContextMenuItem;
		private var _waitMenu:ContextMenu;
		private var _waitItem:ContextMenuItem;	
		private var _data:ByteArray;	
		
		private var _fileReference:FileReference;
		
		public var onSaveStart:Function;
		public var onEncodeProgress:Function;
		public var onEncodeComplete:Function;
		public var onSaveComplete:Function;
		public var onError:Function;
		public var onCancel:Function;

		/**
		 * Constructor
		 * 
		 * @param canvas Instance of ICanvas to use
		 */
		public function ContextSavePNG(canvas:BitmapCanvas) {
			_stage = canvas.stage;
			_progressDisplay = new Sprite();

			_canvas = canvas;
			_encoder = new CanvasPNGEncoder();
			_encoder.onEncodeProgress = onPNGEncodeProgress;
			_encoder.onEncodeComplete = onPNGEncodeComplete;
			
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.COMPLETE, onPNGSaveComplete);
			_fileReference.addEventListener(IOErrorEvent.IO_ERROR, onPNGError);
			_fileReference.addEventListener(Event.CANCEL, onPNGCancel);
			
			_encodeMenu = new ContextMenu();
			_encodeItem = new ContextMenuItem("Encode PNG");
			_encodeMenu.hideBuiltInItems();
            _encodeMenu.customItems.push(_encodeItem);
            _encodeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onPNGEncode);
            
            _waitMenu = new ContextMenu();
            _waitItem = new ContextMenuItem("Please wait, encoding...");
            _waitMenu.hideBuiltInItems();
            _waitMenu.customItems.push(_waitItem);
            
			_saveMenu = new ContextMenu();
			_saveItem = new ContextMenuItem("Save PNG...");
			_saveMenu.hideBuiltInItems();
            _saveMenu.customItems.push(_saveItem);
            _saveItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onPNGSave);
             
            _canvas.contextMenu = _encodeMenu;
		}
		
		private function onPNGEncode(event:ContextMenuEvent):void {
			if (onSaveStart != null) {
				onSaveStart();
			}
			
			_canvas.contextMenu = _waitMenu;
			
			_encoder.encode(_canvas.largeCanvas);
			_canvas.stopCapture();
			
			_stage.addChild(_progressDisplay);
		}
		
		private function onPNGEncodeProgress(percent:Number):void {
			var x:Number = (_stage.stageWidth - BAR_WIDTH) / 2;
			var y:Number = (_stage.stageHeight - BAR_HEIGHT) / 2;
			var width:Number = percent * BAR_WIDTH;
			
			_progressDisplay.graphics.clear();
			_progressDisplay.graphics.lineStyle(0, 0x000000);
			_progressDisplay.graphics.beginFill(0xFFFFFF);
			
			_progressDisplay.graphics.drawRect(x, y, width, BAR_HEIGHT);
			
			_progressDisplay.graphics.beginFill(0x000000, 0.8);
			_progressDisplay.graphics.drawRect(x + width, y, BAR_WIDTH - width, BAR_HEIGHT);
			
			if (onEncodeProgress != null) {
				onEncodeProgress(percent);
			}
		}
		
		private function onPNGEncodeComplete(data:ByteArray):void {
			if (onEncodeComplete != null) {
				onEncodeComplete();
			}
			
			_stage.removeChild(_progressDisplay);
			
			_data = data;
			_canvas.contextMenu = _saveMenu;
		}
		
		private function onPNGSave(event:ContextMenuEvent):void {
			_fileReference.save(_data, "hype.png");	
		}
		
		private function onPNGSaveComplete(event:Event):void {
			_canvas.contextMenu = _saveMenu;
			if(onSaveComplete != null) {
				onSaveComplete();
			}
		}
		
		private function onPNGError(event:IOErrorEvent):void {
			_canvas.contextMenu = _saveMenu;
			
			if (onError != null) {
				onError();
			}
		}
		
		private function onPNGCancel(event:Event):void {
			_canvas.contextMenu = _saveMenu;
			
			if (onCancel != null) {
				onCancel();
			}
		}
	}
}
