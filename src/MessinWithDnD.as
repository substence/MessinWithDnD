package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MessinWithDnD extends Sprite
	{
		private var _lastKnownPosition:Point;
		private var _dragger:Sprite;
		private var _ghost:DisplayObject;

		private var _slot:IconGraphicSlot;
		
		private var _debugLine:Shape;
		
		public function MessinWithDnD()
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_slot = new IconGraphicSlot();
			_slot.x = _slot.y = 250;
			addChild(_slot);
			
			const rows:int = 4;
			const columns:int = 4;
			for (var i:int = 0; i < rows; i++) 
			{
				for (var j:int = 0; j < columns; j++) 
				{
					var icon:IconGraphic = new IconGraphic();
					icon.x = (i * icon.width) + 2;
					icon.y = (j * icon.height) + 2;
					addChild(icon);
				}
			}
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			graphics.clear();
			if (_dragger)
			{
				graphics.lineStyle(1, 0xFF0000, .25);
				graphics.lineTo(_lastKnownPosition.x, _lastKnownPosition.y);
				graphics.lineTo(_dragger.x, _dragger.y);
			}
		}
		
		private function onDown(event:MouseEvent):void
		{
			trace("on down " +  event.currentTarget);
			
			if (event.target is IconGraphic)
			{
				_dragger = Sprite(event.target);
				_dragger.startDrag();
				_lastKnownPosition = new Point(_dragger.x, _dragger.y);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				
				var sourceClass:Class = Object(_dragger).constructor;
				_ghost = new sourceClass();
				_ghost.alpha = .25;
				_ghost.x = _dragger.x;
				_ghost.y = _dragger.y;
				addChild(_ghost);
			}
		}
		
		private function onUp(event:MouseEvent):void
		{
			trace("on up " +  event.currentTarget);
			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			if (_dragger && _dragger == event.target)
			{
				_dragger.stopDrag();

				if (_dragger.hitTestObject(_slot) && !_slot.occupant)
				{
					_slot.occupant = _dragger;
					//TweenLite.to(_dragger, .5, {x:_slot.x, y:_slot.y, ease:Elastic.easeOut});
				}
				else
				{
					cancelDrag();//TweenLite.to(_dragger, .5, {x:_lastKnownPosition.x, y:_lastKnownPosition.y, ease:Elastic.easeOut});
				}
			}
		}

		
		private function cancelDrag():void
		{
			trace("outside ");
			if (_dragger)
			{
				_dragger.stopDrag();
				TweenLite.to(_dragger, .5, {x:_lastKnownPosition.x, y:_lastKnownPosition.y, ease:Elastic.easeOut});
				if (_ghost)
				{
					removeChild(_ghost);
				}
				
				_dragger = null;
			}
		}
	}
}
import flash.display.Sprite;

class IconGraphic extends Sprite
{
	public function IconGraphic()
	{
		graphics.beginFill(0xFF0000);
		graphics.drawRect(0,0, 50, 50);
		graphics.endFill();
	}
}
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.Shape;
import com.greensock.TweenLite;
import com.greensock.easing.Elastic;

class IconGraphicSlot extends Sprite implements IDraggableSlot
{
	private var _occupant:DisplayObject;
	private var _background:Shape;
	
	public function IconGraphicSlot()
	{
		_background = new Shape();
		_background.graphics.beginFill(0xcccccc, 1);
		_background.graphics.drawRect(0,0, 54, 54);
		_background.graphics.endFill();
		addChild(_background);
	}
	
	public function get graphic():DisplayObject
	{
		return this;
	}
	
	public function get occupant():DisplayObject
	{
		return _occupant;
	}
	
	public function set occupant(value:DisplayObject):void
	{
		_occupant = value;
		addChild(_occupant);
		TweenLite.to(_occupant, .5, {x:2, y:2, ease:Elastic.easeOut});
	}
}