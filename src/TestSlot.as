package
{
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class TestSlot extends Sprite implements IDraggableSlot
	{
		private var _occupant:IDraggableOccupant;
		private var _background:Shape;
		
		public function TestSlot()
		{
			_background = new Shape();
			_background.graphics.beginFill(0xcccccc, 1);
			_background.graphics.drawRect(0,0, 54, 54);
			_background.graphics.endFill();
			addChild(_background);
		}
		
		public function get occupant():IDraggableOccupant
		{
			return _occupant;
		}
		
		public function set occupant(value:IDraggableOccupant):void
		{
			_occupant = value;
			if (_occupant)
			{
				_occupant.slot = this;
				addChild(_occupant.graphic);
				TweenLite.to(_occupant, .5, {x:2, y:2, ease:Elastic.easeOut});
			}
		}
		
		public function get graphic():DisplayObject
		{
			return this;
		}
	}
}