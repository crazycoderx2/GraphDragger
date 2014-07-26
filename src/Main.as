package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import model.GraphModel;

	import applicationFSM.ApplicationState;
	import applicationFSM.DefaultState;
	import applicationFSM.FSM;
	import applicationFSM.MakeLinkState;
	import applicationFSM.MoveRectState;

	import views.Renderer;

	[SWF(frameRate="60", backgroundColor="0x505050", width="700", height="500")]
	public class Main extends Sprite {

		public var graphModel:GraphModel = new GraphModel();
		public var fsm:FSM = new FSM();
		public var renderer:Renderer = new Renderer();

		public function Main()
		{

			stage.scaleMode = StageScaleMode.NO_SCALE;
			addChild(renderer);
			addChild(new Help());

			addState(ApplicationState.DEFAULT_STATE, new DefaultState());
			addState(ApplicationState.DRAG_RECT_STATE, new MoveRectState());
			addState(ApplicationState.ADD_LINK_STATE, new MakeLinkState());
			fsm.changeState(ApplicationState.DEFAULT_STATE);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler)
		}

		private function enterFrameHandler(event:Event):void
		{
			fsm.update();
		}


		/**
		 * Добавляет состояние к автамату и устанавливает ему ссылки на основные компоненты приложения. В нормальных условиях этим занимается инжектор, в данной ситуации (3 инстанса х 3 поля) вполне можно обойтись унифицированным методом.
		 * @param name
		 * @param state
		 */
		private function addState(name:String, state:ApplicationState):void
		{
			state.fsm = fsm;
			state.graphModel = graphModel;
			state.renderer = renderer;
			fsm.addState(name, state);
		}
	}
}

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class Help extends TextField {
	public function Help():void
	{
		super();
		autoSize = TextFieldAutoSize.LEFT;
		wordWrap = true;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("Tahoma", 11, 0xFFFFFF);
		x = 5;
		y = 5;
		appendText("Graph representation demo\n");
		appendText("CONTROLS:\n");
		appendText("To create a node  — click twice on stage. If the place under the cursor  isn't taken the node will be created.\n");
		appendText("To create a link between two nodes click twice on the first node then click on the second one or any other place to leave link creation mode.\n");
		appendText("To break a link just click on it.\n");
		width = 300;
	}
}
