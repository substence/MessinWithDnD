package
{
	import com.cc.ui.dnd.BaseSlot;
	import com.cc.ui.dnd.DragNDropOverlord;
	import com.cc.ui.dnd.IDraggableOccupant;
	import com.cc.ui.dnd.IDraggableSlot;
	import com.greensock.TweenLite;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import com.cc.ui.dnd.GenericSlotStates;
	
	public class TestSlot extends BaseSlot
	{
		private var _background:Shape;
		
		public function TestSlot()
		{
			_background = new Shape();
			_background.graphics.beginFill(0xcccccc, 1);
			_background.graphics.drawRect(0,0, 54, 54);
			_background.graphics.endFill();
			_graphic = new Sprite();
			_graphic.addChild(_background);
		}
		
		override public function set occupant(value:IDraggableOccupant):void
		{
			super.occupant = value;
			if (_occupant)
			{
				if (_occupant.graphic.parent)
				{
					var oldGlobalPosition:Point = occupant.graphic.localToGlobal(DragNDropOverlord.EMPTY_POINT);
					var newLocalPosition:Point = _graphic.globalToLocal(oldGlobalPosition);
					_graphic.addChild(_occupant.graphic);
					_occupant.graphic.x = newLocalPosition.x;
					_occupant.graphic.y = newLocalPosition.y;
					
					TweenLite.to(_occupant.graphic, .5, {x:2, y:2, ease:Elastic.easeOut});
				}
				else
				{
					_occupant.graphic.x = _occupant.graphic.y = 2;
					_graphic.addChild(_occupant.graphic);
				}
			}
		}
		
		override public function set previewOccupant(value:IDraggableOccupant):void
		{
			super.previewOccupant = value;
			if (_previewOccupant)
			{
				_previewOccupant.graphic.x = _previewOccupant.graphic.y = 2;
			}
		}
		
		override public function set state(value:String):void
		{
			super.state = value;
			switch(_state)
			{
				case GenericSlotStates.POTENTIAL:
				{
					this._graphic.filters = [new GlowFilter(0x00FF00, .5, 8, 8, 6)];
					break;
				}
					
				case GenericSlotStates.TARGETED:
				{
					this._graphic.filters = [new GlowFilter(0xFF0000, .5, 8, 8, 6)];
					break;
				}
					
				case GenericSlotStates.DEFAULT:
				default:
				{
					this._graphic.filters = [];
					break;
				}
			}
		}
	}
}