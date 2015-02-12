package
{
	import com.cc.ui.dnd.DragNDropOverlord;
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import com.cc.ui.dnd.GenericSlotStates;
	
	public class MessinWithDnD extends Sprite
	{
		private var _manager:DragNDropOverlord;
		private var _slots:Vector.<IDraggableSlot>
		
		public function MessinWithDnD()
		{
			_slots = new Vector.<IDraggableSlot>();
			var outsiderSlot:IDraggableSlot = new TestSlot();
			outsiderSlot.graphic.x = outsiderSlot.graphic.y = 225;
			addChild(outsiderSlot.graphic);
			_slots.push(outsiderSlot);
			
			outsiderSlot = new TestSlot();
			outsiderSlot.graphic.x = outsiderSlot.graphic.y = 300;
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
			
			_manager = new DragNDropOverlord(this, _slots);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if (_manager.activeOccupant)
			{
				for each (var slot:IDraggableSlot in _slots) 
				{
					if (!slot.occupant)
					{
						slot.state = GenericSlotStates.POTENTIAL;
					}
					else
					{
						slot.state = GenericSlotStates.DEFAULT;
					}
				}
				if (_manager.targetSlot)
				{
					_manager.targetSlot.state = GenericSlotStates.TARGETED;
				}
			}
			else
			{
				for each (slot in _slots) 
				{
					slot.state = GenericSlotStates.DEFAULT;
				}
			}
		}
	}
}