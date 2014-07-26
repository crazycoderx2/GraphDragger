package applicationFSM {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	import model.VO.Rect;

	public class MakeLinkState extends ApplicationState {

		private var tempCanvas:Sprite = new Sprite();
		private var hoveredTarget:Rect;
		private var glowFilter:GlowFilter = new GlowFilter(Style.SELECTED_RECT_FRAME, 1, 5, 5, 2000);

		override public function onEnter():void
		{
			var view:DisplayObject = renderer.getView(graphModel.selectedRect);
			view.filters = [glowFilter];
			renderer.edgeCanvas.addChild(tempCanvas);
			renderer.rectsCanvas.addEventListener(MouseEvent.MOUSE_OVER, rectMouseOverHandler);
			renderer.rectsCanvas.addEventListener(MouseEvent.MOUSE_OUT, rectMouseOutHandler);
			renderer.stage.addEventListener(MouseEvent.CLICK, rectMouseClickHandler);
		}

		private function rectMouseClickHandler(event:MouseEvent):void
		{
			if (hoveredTarget != null && hoveredTarget != graphModel.selectedRect && !graphModel.hasLink(hoveredTarget, graphModel.selectedRect)) {
				var edge:model.VO.Edge = graphModel.addLink(hoveredTarget, graphModel.selectedRect);
				renderer.addEdgeView(edge);
			}
			fsm.changeState(ApplicationState.DEFAULT_STATE);
		}

		private function rectMouseOutHandler(event:MouseEvent):void
		{
			hoveredTarget = null
		}

		private function rectMouseOverHandler(event:MouseEvent):void
		{
			hoveredTarget = renderer.getRectByView(DisplayObject(event.target));
		}

		override public function update():void
		{
			drawLine();
		}

		private function drawLine():void
		{
			var color:uint;
			var targetX:Number;
			var targetY:Number;

			if (hoveredTarget != null && !graphModel.hasLink(hoveredTarget, graphModel.selectedRect)) {
				color = Style.LINK_PREVIEW_ACTIVE;
				targetX = hoveredTarget.x;
				targetY = hoveredTarget.y;
			} else {
				color = Style.LINK_PREVIEW;
				targetX = renderer.mouseX;
				targetY = renderer.mouseY;
			}
			tempCanvas.graphics.clear();
			tempCanvas.graphics.lineStyle(Style.LINE_WIDTH, color);
			tempCanvas.graphics.moveTo(graphModel.selectedRect.x, graphModel.selectedRect.y);
			tempCanvas.graphics.lineTo(targetX, targetY);
		}

		override public function onExit():void
		{
			hoveredTarget = null;
			var view:DisplayObject = renderer.getView(graphModel.selectedRect);
			graphModel.selectedRect = null;
			view.filters = [];
			renderer.edgeCanvas.removeChild(tempCanvas);
			renderer.rectsCanvas.removeEventListener(MouseEvent.MOUSE_OVER, rectMouseOverHandler);
			renderer.rectsCanvas.removeEventListener(MouseEvent.MOUSE_OUT, rectMouseOutHandler);
			renderer.stage.removeEventListener(MouseEvent.CLICK, rectMouseClickHandler);

		}
	}
}
