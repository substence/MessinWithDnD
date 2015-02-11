package
{
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MessinWithDnD extends Sprite
	{
		private static const _EMPTY_POINT:Point = new Point();
		private var _dragger:IDraggableOccupant;
		private var _ghost:IDraggableOccupant;
		private var _slots:Vector.<TestSlot> = new Vector.<TestSlot>();
		private var _lastKnownPosition:Point;
		
		private var _foreground:Sprite;
		
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
			
			_foreground = new Sprite();
			addChild(_foreground);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			graphics.clear();
			if (_dragger)
			{
				var slot:IDraggableSlot = getViableSlotForOccupant(_dragger);
				if (slot)
				{
					slot.previewOccupant = _ghost;
				}
			}
		}
		
		private function onDown(event:MouseEvent):void
		{
			trace("on down " +  event.currentTarget + event.target);
			
			if (event.target is IDraggableOccupant)
			{
				_dragger = IDraggableOccupant(event.target);
				_dragger.graphic.startDrag();
				
				_dragger.slot.graphic.parent.setChildIndex(_dragger.slot.graphic, _dragger.slot.graphic.parent.numChildren - 1);
				_lastKnownPosition = new Point(_dragger.graphic.x, _dragger.graphic.y);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				
				_ghost = _dragger.clone();
				_ghost.graphic.alpha = .25;
				_dragger.slot.previewOccupant = _ghost;
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
			var bestViableSlot:IDraggableSlot;
			var bestDistance:Number = Number.MAX_VALUE;
			const occupantCenterPosition:Point = occupant.graphic.localToGlobal(_EMPTY_POINT);
			//trace("occupoant position" + occupantCenterPosition);

			for each (var slot:IDraggableSlot in _slots) 
			{
				const slotCenterPosition:Point = slot.graphic.localToGlobal(_EMPTY_POINT);
				const distance:Number = Point.distance(occupantCenterPosition, slotCenterPosition);
				//trace("touching " + Object(slot).name + " which is " + distance + " away");
				if (distance < bestDistance)
				{
					bestDistance = distance;
					bestViableSlot = slot;
				}
			}
			//trace("picked " + Object(bestViableSlot).name);

			return bestViableSlot;
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
				_ghost.slot.previewOccupant = null;
				_ghost = null;				
				_dragger = null;
			}
		}
	}
}