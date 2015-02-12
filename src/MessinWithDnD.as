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
	
	public class MessinWithDnD extends Sprite
	{
		private var _manager:DragNDropOverlord;
		
		public function MessinWithDnD()
		{
			var slots:Vector.<IDraggableSlot> = new Vector.<IDraggableSlot>();
			var outsiderSlot:IDraggableSlot = new TestSlot();
			outsiderSlot.graphic.x = outsiderSlot.graphic.y = 225;
			addChild(outsiderSlot.graphic);
			slots.push(outsiderSlot);
			
			outsiderSlot = new TestSlot();
			outsiderSlot.graphic.x = outsiderSlot.graphic.y = 300;
			addChild(outsiderSlot.graphic);
			slots.push(outsiderSlot);
			
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
					slots.push(slot);
				}
			}
			
			_manager = new DragNDropOverlord(this, slots);
		}
	}
}