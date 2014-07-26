package applicationFSM {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import model.VO.Rect;

	public class MoveRectState extends ApplicationState {

		private var localX:Number;
		private var localY:Number;

		override public function onEnter():void
		{
			localX = renderer.mouseX - graphModel.selectedRect.x;
			localY = renderer.mouseY - graphModel.selectedRect.y;

			renderer.stage.addEventListener(MouseEvent.MOUSE_UP, commonStopHandler);
			renderer.stage.addEventListener(Event.MOUSE_LEAVE, commonStopHandler);
		}


		override public function onExit():void
		{
			renderer.stage.removeEventListener(MouseEvent.MOUSE_UP, commonStopHandler);
			renderer.stage.removeEventListener(Event.MOUSE_LEAVE, commonStopHandler);
		}

		override public function update():void
		{
			var selectedRect:Rect = graphModel.selectedRect;
			var targetX:Number = renderer.mouseX - localX;
			var targetY:Number = renderer.mouseY - localY;

			if (!graphModel.placeAvailable(targetX, targetY)) {
				var targetPoint:Point = graphModel.getPlace(targetX, targetY);
				targetX = targetPoint.x;
				targetY = targetPoint.y;
			}
			selectedRect.x = targetX;
			selectedRect.y = targetY;
			renderer.updatePosition(graphModel.selectedRect);

		}

		private function commonStopHandler(event:Event):void
		{
			fsm.changeState(ApplicationState.DEFAULT_STATE);
		}


	}
}
