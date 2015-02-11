package com.cc.ui.dnd
{
	import flash.display.DisplayObject;

	public interface IDraggableSlot
	{
		function get graphic():DisplayObject;
		function get occupant():IDraggableOccupant;
		function set occupant(value:IDraggableOccupant):void;
	}
}