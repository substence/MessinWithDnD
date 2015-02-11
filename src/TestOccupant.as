package
{
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
	
	import flash.display.Sprite;
	
	public class TestOccupant extends Sprite implements IDraggableOccupant
	{
		private var _slot:IDraggableSlot;
		private var _color:uint;
		
		public function TestOccupant(slot:IDraggableSlot = null, color:uint = 0)
		{
			_slot = slot;
			if (!color)
			{
				color = Math.random() * 0xFFFFFF;
			}
			_color = color;
			graphics.beginFill(_color);
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
		
		public function clone():IDraggableOccupant
		{
			return new TestOccupant(_slot, _color);
		}
	}
}