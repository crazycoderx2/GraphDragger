package applicationFSM {
	import flash.utils.Dictionary;

	/**
	 * Автомат управления состояниями приложения. Должен быть должным образом проинициализирован перед  вызовами <code>changeState()</code> <code>update()</code>.
	 */
	public class FSM {
		private var states:Dictionary = new Dictionary();
		private var currentStateName:String;

		public function FSM()
		{
		}

		public function addState(name:String, state:ApplicationState):void
		{
			states[name] = state;
		}

		public function changeState(name:String):void
		{
			if (currentStateName == name) return;
			var targetState:ApplicationState = states[name];
			if (targetState == null) throw  new Error("There is no state '" + name + "'");
			var currentState:ApplicationState = states[currentStateName];
			if (currentState!= null) currentState.onExit();
			currentStateName = name;
			targetState.onEnter();
		}

		public function update():void
		{
			var currentState:ApplicationState = states[currentStateName];
			currentState.update();
		}
	}
}
