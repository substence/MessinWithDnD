package
{
	import com.cc.ui.dnd.BaseOccupant;
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
	
	import flash.display.Sprite;
	
	public class TestOccupant extends BaseOccupant
	{
		private var _color:uint;
		
		public function TestOccupant(slot:IDraggableSlot = null, color:uint = 0)
		{
			super(slot);
			if (!color)
			{
				color = Math.random() * 0xFFFFFF;
			}
			_color = color;
			_graphic = new Sprite();
			_graphic.graphics.beginFill(_color);
			_graphic.graphics.drawRect(0,0, 50, 50);
			_graphic.graphics.endFill();
		}
		
		override public function clone():IDraggableOccupant
		{
			return new TestOccupant(_slot, _color);
		}
	}
}