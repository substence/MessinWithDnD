package com.cc.ui.dnd
{
	import flash.display.DisplayObject;

	public interface IDraggableSlot
	{
		function get graphic():DisplayObject;
		function get occupant():IDraggableOccupant;
		function set occupant(value:IDraggableOccupant):void;
		function set previewOccupant(value:IDraggableOccupant):void;
		function set state(value:String):void;
	}
}