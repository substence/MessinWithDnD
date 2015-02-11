package
{
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
	
	import flash.display.Sprite;
	
	public class TestOccupant extends Sprite implements IDraggableOccupant
	{
		private var _slot:IDraggableSlot;
		
		public function TestOccupant(slot:IDraggableSlot = null)
		{
			_slot = slot;
			graphics.beginFill(Math.random() * 0xFFFFFF);
			graphics.drawRect(0,0, 50, 50);
			graphics.endFill();
		}
		
		public function set slot(value:IDraggableSlot):void
		{
			_slot = value;
		}
		
		public function get slot():IDraggableSlot
		{
			return _slot;
		}
		
		public function get graphic():Sprite
		{
			return this;
		}
	}
}