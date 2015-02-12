package com.cc.ui.dnd
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class BaseSlot implements IDraggableSlot
	{
		protected var _previewOccupant:IDraggableOccupant;
		protected var _occupant:IDraggableOccupant;
		protected var _graphic:DisplayObjectContainer;
		protected var _state:String;
		
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
				//_graphic.addChild(_occupant.graphic);
			}
		}
		
		public function get graphic():DisplayObject
		{
			return _graphic;
		}
		
		public function set previewOccupant(value:IDraggableOccupant):void
		{
			if (_previewOccupant == value)
			{
				return;
			}
			if (value)
			{
				_previewOccupant = value;
				_previewOccupant.slot = this;
				_previewOccupant.graphic.alpha = .25;
				_graphic.addChild(_previewOccupant.graphic);
			}
			else
			{
				_graphic.removeChild(_previewOccupant.graphic);
				_previewOccupant.slot = null;
				_previewOccupant = null;
			}
		}
		
		public function set state(value:String):void
		{
			_state = value;
		}
	}
}