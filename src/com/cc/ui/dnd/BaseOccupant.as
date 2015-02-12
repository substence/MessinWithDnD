package com.cc.ui.dnd
{
	import flash.display.Sprite;
	
	public class BaseOccupant implements IDraggableOccupant
	{
		protected var _slot:IDraggableSlot;
		protected var _graphic:Sprite;
		
		public function BaseOccupant(slot:IDraggableSlot = null)
		{
			_slot = slot;
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
			return _graphic;
		}
		
		public function clone():IDraggableOccupant
		{
			return new BaseOccupant(_slot);
		}
	}
}