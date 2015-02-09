package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MessinWithDnD extends Sprite
	{
		public function MessinWithDnD()
		{
			var icon:IconGraphic = new IconGraphic();
			icon.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			icon.addEventListener(MouseEvent.MOUSE_UP, onUp);
			addChild(icon);
			
			var slot:IconGraphicSlot = new IconGraphicSlot();
			slot.x = slot.y = 100;
			addChild(slot);
		}
		
		private function onDown(event:MouseEvent):void
		{
			var sprite:Sprite = Sprite(event.target);
			sprite.startDrag();
		}
		
		private function onUp(event:MouseEvent):void
		{
			var sprite:Sprite = Sprite(event.target);
			sprite.stopDrag();
		}
	}
}
import flash.display.Sprite;

class IconGraphic extends Sprite
{
	public function IconGraphic()
	{
		graphics.beginFill(0xFF0000);
		graphics.drawRect(0,0, 50, 50);
		graphics.endFill();
	}
}
import flash.display.Sprite;

class IconGraphicSlot extends Sprite
{
	public function IconGraphicSlot()
	{
		graphics.beginFill(0xcccccc);
		graphics.drawRect(0,0, 54, 54);
		graphics.endFill();
	}
}