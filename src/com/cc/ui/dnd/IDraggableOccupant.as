package com.cc.ui.dnd
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public interface IDraggableOccupant
	{
		function get graphic():Sprite;
		function get slot():IDraggableSlot;
		function set slot(value:IDraggableSlot):void;
		function clone():IDraggableOccupant;
	}
}