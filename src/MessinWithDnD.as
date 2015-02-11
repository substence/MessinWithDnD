package
{
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
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
	
	import org.osmf.elements.BeaconElement;
	
	public class MessinWithDnD extends Sprite
	{
		private var _lastKnownPosition:Point;
		private var _dragger:IDraggableOccupant;
		private var _ghost:DisplayObject;

		private var _slots:Vector.<TestSlot> = new Vector.<TestSlot>();
		 
		private var _debugLine:Shape;
		
		public function MessinWithDnD()
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var outsiderSlot:IDraggableSlot = new TestSlot();
			outsiderSlot.graphic.x = outsiderSlot.graphic.y = 250;
			addChild(outsiderSlot.graphic);
			_slots.push(outsiderSlot);
			
			const rows:int = 4;
			const columns:int = 4;
			for (var i:int = 0; i < rows; i++) 
			{
				for (var j:int = 0; j < columns; j++) 
				{
					var slot:IDraggableSlot = new TestSlot();
					var icon:TestOccupant = new TestOccupant(slot);
					slot.graphic.x = (i * slot.graphic.width) + 2;
					slot.graphic.y = (j * slot.graphic.height) + 2;
					addChild(slot.graphic);
					slot.occupant = icon;
					_slots.push(slot);
				}
			}
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			graphics.clear();
			if (_dragger && _dragger.slot)
			{
				graphics.lineStyle(1, 0xFF0000, .25);
				graphics.lineTo(_lastKnownPosition.x, _lastKnownPosition.y);
				graphics.lineTo(_dragger.slot.graphic.x, _dragger.slot.graphic.y);
			}
		}
		
		private function onDown(event:MouseEvent):void
		{
			trace("on down " +  event.currentTarget + event.target);
			
			if (event.target is IDraggableOccupant)
			{
				_dragger = IDraggableOccupant(event.target);
				_dragger.graphic.startDrag();
				_lastKnownPosition = new Point(_dragger.graphic.x, _dragger.graphic.y);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				
				var sourceClass:Class = Object(_dragger).constructor;
				_ghost = new sourceClass();
				_ghost.alpha = .25;
				_ghost.x = _dragger.graphic.x;
				_ghost.y = _dragger.graphic.y;
				//addChild(_ghost);
			}
		}
		
		private function onUp(event:MouseEvent):void
		{
			trace("on up " +  event.currentTarget);
			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			if (_dragger)
			{
				var potentialSlot:IDraggableSlot = getViableSlotForOccupant(_dragger);
				trace("new slot = " + Object(potentialSlot).name)
				if (potentialSlot)
				{
					const oldSlot:IDraggableSlot = _dragger.slot;

					//swap
					if (potentialSlot.occupant)
					{
						oldSlot.occupant = potentialSlot.occupant
					}
					else
					{
						oldSlot.occupant = null;
					}
					trace("old slot = " + Object(oldSlot).name);

					potentialSlot.occupant = _dragger;
					//TweenLite.to(_dragger, .5, {x:_slot.x, y:_slot.y, ease:Elastic.easeOut});
				}
				else
				{
					cancelDrag();//TweenLite.to(_dragger, .5, {x:_lastKnownPosition.x, y:_lastKnownPosition.y, ease:Elastic.easeOut});
				}
			}
			endDrag();
		}
		
		private function getViableSlotForOccupant(occupant:IDraggableOccupant):IDraggableSlot
		{
			var lostViableSlot:IDraggableSlot;

			for each (var slot:IDraggableSlot in _slots) 
			{
				if (occupant.graphic.hitTestObject(slot.graphic))
				{
					trace("touching " + Object(slot).name);
					if (occupant.slot != slot)
					{
						lostViableSlot = slot;
					}
				}
			}
			return lostViableSlot;
		}
		
		private function cancelDrag():void
		{
			if (_dragger)
			{
				TweenLite.to(_dragger, .5, {x:_lastKnownPosition.x, y:_lastKnownPosition.y, ease:Elastic.easeOut});
			}
			endDrag()
		}
		
		private function endDrag():void
		{
			if (_dragger)
			{
				_dragger.graphic.stopDrag();
				if (_ghost && this.contains(_ghost))
				{
					removeChild(_ghost);
				}
				_ghost = null;				
				_dragger = null;
			}
		}
	}
}