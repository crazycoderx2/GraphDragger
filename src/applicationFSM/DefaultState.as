package applicationFSM {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import model.VO.Edge;
	import model.VO.Rect;

	public class DefaultState extends ApplicationState {

		override public function onEnter():void
		{
			renderer.stage.doubleClickEnabled = true;
			renderer.stage.addEventListener(MouseEvent.DOUBLE_CLICK, stageClickHandler);
			renderer.edgeCanvas.addEventListener(MouseEvent.CLICK, egdeClickHandler);
			renderer.rectsCanvas.addEventListener(MouseEvent.DOUBLE_CLICK, rectClickHandler);
			renderer.rectsCanvas.addEventListener(MouseEvent.MOUSE_DOWN, rectMouseDownHandler);
		}


		private function rectMouseDownHandler(event:MouseEvent):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			var rect:Rect = renderer.getRectByView(target);
			graphModel.selectedRect = rect;
			fsm.changeState(ApplicationState.DRAG_RECT_STATE);

		}

		private function rectClickHandler(event:MouseEvent):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			var rect:Rect = renderer.getRectByView(target);
			graphModel.selectedRect = rect;
			fsm.changeState(ApplicationState.ADD_LINK_STATE);
		}

		private function egdeClickHandler(event:MouseEvent):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			var edge:model.VO.Edge = renderer.getEdgeByView(target);
			graphModel.removeLink(edge);
			renderer.removeEdgeView(edge);
		}

		private function stageClickHandler(event:MouseEvent):void
		{
			var x:Number = renderer.stage.mouseX;
			var y:Number = renderer.stage.mouseY;
			if (graphModel.placeAvailable(x, y)) {
				var rect:Rect = graphModel.createRect(x, y);
				renderer.addRectView(rect);
			}
		}

		override public function onExit():void
		{
			renderer.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, stageClickHandler);
			renderer.edgeCanvas.removeEventListener(MouseEvent.CLICK, egdeClickHandler);
			renderer.rectsCanvas.removeEventListener(MouseEvent.DOUBLE_CLICK, rectClickHandler);
			renderer.rectsCanvas.removeEventListener(MouseEvent.MOUSE_DOWN, rectMouseDownHandler);
		}
	}
}
