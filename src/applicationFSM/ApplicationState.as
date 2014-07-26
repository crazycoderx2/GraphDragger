package applicationFSM {
	import model.GraphModel;
	import views.Renderer;

	public class ApplicationState {

		public static const DEFAULT_STATE:String = 'defaultState';
		public static const ADD_LINK_STATE:String = 'addLinkState';
		public static const   DRAG_RECT_STATE:String = 'dragRectState';


		public var renderer:Renderer;
		public var graphModel:GraphModel;
		public var fsm:FSM;

		public function ApplicationState()
		{
		}

		public function onExit():void
		{

		}

		public function onEnter():void
		{

		}

		public function update():void
		{

		}
	}
}
