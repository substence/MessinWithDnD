package com.cc.ui.dnd
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DragNDropOverlord
	{
		public static const EMPTY_POINT:Point = new Point();
		private var _activeOccupant:IDraggableOccupant;
		private var _activeOccupantPreview:IDraggableOccupant;
		private var _slots:Vector.<IDraggableSlot> = new Vector.<IDraggableSlot>();
		private var _targetSlot:IDraggableSlot;
		private var _container:Sprite;
		private var _occupants:Vector.<IDraggableOccupant>;
		
		public function DragNDropOverlord(container:Sprite, slots:Vector.<IDraggableSlot>)
		{
			_slots = slots;
			_occupants = new Vector.<IDraggableOccupant>();
			
			for each (var slot:IDraggableSlot in _slots) 
			{
				if (slot.occupant)
				{
					_occupants.push(slot.occupant);
				}
			}
			
			_container = container;			
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame);			
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		public function get targetSlot():IDraggableSlot
		{
			return _targetSlot;
		}

		public function get activeOccupant():IDraggableOccupant
		{
			return _activeOccupant;
		}

		protected function onEnterFrame(event:Event):void
		{
			_container.graphics.clear();
			if (_activeOccupant)
			{
				updatePreview();
				_container.graphics.lineStyle(1, 0, .05);
				const slotPosition:Point = _activeOccupant.slot.graphic.localToGlobal(EMPTY_POINT);
				_container.graphics.lineTo(slotPosition.x + 25, 
										   slotPosition.y + 25);
				const occupantPosition:Point = _activeOccupant.graphic.localToGlobal(EMPTY_POINT);
				_container.graphics.lineTo(occupantPosition.x + 25, 
										   occupantPosition.y + 25);
			}
		}
		
		private function updatePreview():void
		{
			var targetSlot:IDraggableSlot = getViableSlotForOccupant(_activeOccupant);
			if (targetSlot)
			{
				if (targetSlot != _targetSlot)
				{
					clearOldPreview();
					_targetSlot = targetSlot;
					//if the target slot already has an occupant, show the swap preview
					if (targetSlot.occupant && targetSlot.occupant != _activeOccupant)
					{
						if (_activeOccupant.slot)
						{
							targetSlot.occupant.graphic.visible = false;
							
							_activeOccupant.slot.previewOccupant = targetSlot.occupant.clone();
							
							targetSlot.previewOccupant = _activeOccupantPreview;
						}
					}
					else
					{
						targetSlot.previewOccupant = _activeOccupantPreview;
					}
				}
			}
			else
			{
				clearOldPreview();
			}
		}
		
		private function clearOldPreview():void
		{
			if (_targetSlot)
			{
				if (_targetSlot.occupant)
				{
					_targetSlot.occupant.graphic.visible = true;
				}
				_targetSlot.previewOccupant = null;
			}
			_activeOccupant.slot.previewOccupant = null;
		}
		
		private function onDown(event:MouseEvent):void
		{
			const occupant:IDraggableOccupant = getOccupantFromGraphic(event.target as DisplayObject);
			
			if (occupant)
			{
				_activeOccupant = occupant
				_activeOccupant.graphic.startDrag();
				
				_activeOccupant.slot.graphic.parent.setChildIndex(_activeOccupant.slot.graphic, _activeOccupant.slot.graphic.parent.numChildren - 1);
				_container.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				
				_activeOccupantPreview = _activeOccupant.clone();
				_activeOccupant.slot.previewOccupant = _activeOccupantPreview;
			}
		}
		
		private function getOccupantFromGraphic(graphic:DisplayObject):IDraggableOccupant
		{
			for each (var occupant:IDraggableOccupant in _occupants) 
			{
				if (occupant.graphic == graphic)
				{
					return occupant;
				}
			}
			return null;
		}
		
		private function onUp(event:MouseEvent):void
		{
			trace("on up " +  event.currentTarget);
			
			clearOldPreview();
			
			_container.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			if (_activeOccupant)
			{
				if (_targetSlot)
				{
					const oldSlot:IDraggableSlot = _activeOccupant.slot;
					
					//swap
					if (_targetSlot.occupant)
					{
						oldSlot.occupant = _targetSlot.occupant
					}
					else
					{
						oldSlot.occupant = null;
					}
					
					_targetSlot.occupant = _activeOccupant;
					_targetSlot = null;
				}
			}
			endDrag();
		}
		
		private function getViableSlotForOccupant(occupant:IDraggableOccupant):IDraggableSlot
		{
			var bestViableSlot:IDraggableSlot;
			var bestDistance:Number = Number.MAX_VALUE;
			const occupantCenterPosition:Point = occupant.graphic.localToGlobal(EMPTY_POINT);
			//trace("occupoant position" + occupantCenterPosition);
			
			for each (var slot:IDraggableSlot in _slots) 
			{
				if (slot.graphic.hitTestObject(occupant.graphic))
				{
					const slotCenterPosition:Point = slot.graphic.localToGlobal(EMPTY_POINT);
					const distance:Number = Point.distance(occupantCenterPosition, slotCenterPosition);
					//trace("touching " + Object(slot).name + " which is " + distance + " away");
					if (distance < bestDistance)
					{
						bestDistance = distance;
						bestViableSlot = slot;
					}
				}
			}
			//trace("picked " + Object(bestViableSlot).name);
			
			return bestViableSlot;
		}
		
		private function endDrag():void
		{
			if (_activeOccupant)
			{
				_activeOccupant.graphic.stopDrag();
				_activeOccupant = null;
			}
			if (_activeOccupantPreview)
			{
				//_previewOccupant.slot.previewOccupant = null;
				_activeOccupantPreview = null;	
			}
		}
	}
}