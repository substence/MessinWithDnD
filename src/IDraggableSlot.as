package
{
	import flash.display.DisplayObject;

	public interface IDraggableSlot
	{
		function get occupant():DisplayObject;
		function set occupant(value:DisplayObject):void;
	}
}