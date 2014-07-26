package views {
	import avmplus.getQualifiedClassName;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import model.VO.Edge;
	import model.VO.Rect;

	/**
	 *  Класс, отвечающий за визуализацию представления графа.
	 */

	public class Renderer extends Sprite {
		/**
		 * Канвас для хранения вьюшек связей
		 */
		public var edgeCanvas:Sprite = new Sprite();
		/**
		 * Канвас для хранения вьюшек прямоугольников
		 */
		public var rectsCanvas:Sprite = new Sprite();

		private var edgeViews:Dictionary = new Dictionary();
		private var rectViews:Dictionary = new Dictionary();

		public function Renderer()
		{
			addChild(edgeCanvas);
			addChild(rectsCanvas);
		}

		/**
		 * Возвращает ребро графа по его вьюшке. Предполагается, что подписка на события мыши происходит в месте, где описывается логика работы (контроллер) - там требуется установить соответствие вьюшки и связанной с ней сущности. С точки зрения строгого ООП, было бы аккуратнее обрабатывать события мыши внутри рендера, а наружу рассылать кастомные события, внутри которых уже были бы завернуты сущности модели (ссылка на экземпляр Edge или Rect). В данном случае я не увидел архитектурных преимуществ такого решения и решил воспользоваться бритвой Оккама. Если рассуждать в общем, то более строгое следование принципам ООП дало бы большую свободу в изменении внутреннего устройства рендерера с сохранением его API.
		 * @param edgeView
		 * @return
		 */
		public function getEdgeByView(edgeView:DisplayObject):Edge
		{
			for (var key:Object in edgeViews) {
				var edge:Edge = key as Edge;
				if (edgeViews[edge] == edgeView)
					return edge;
			}
			throw "There is no edge for given view";
		}

		/**
		 *  Возвращает вершину графа по ее вьюшке.
		 */
		public function getRectByView(rectView:DisplayObject):Rect
		{
			for (var key:Object in rectViews) {
				var rect:Rect = key as Rect;
				if (rectViews[rect] == rectView)
					return rect;
			}
			throw new Error("There is no edge for given view");
		}

		/**
		 * Обновляет положение вьюшки прямоугольника и его связей в соответствии с его координатами.
		 * @param rect
		 */
		public function updatePosition(rect:Rect):void
		{
			rectViews[rect].x = rect.x;
			rectViews[rect].y = rect.y;
			for (var key:Object in edgeViews) {
				var edge:Edge = key as Edge;
				if (rect == edge.rectA || rect == edge.rectB) {
					updateEdgeView(edge);
				}
			}
		}

		/**
		 *  Возвращает вью, для переданного объекта. В качестве объекта может быть передан экземпляр <code>Edge</code> или <code>Rect</code>.
		 * @param key
		 * @return
		 */
		public function getView(key:Object):DisplayObject
		{
			var view:DisplayObject;
			if (key is Rect) {
				view = rectViews[key];
				if (view == null) throw "There is no view for rect " + key;
			} else if (key is Edge) {
				view = edgeViews[key];
				if (view == null) throw "There is no view for edge " + key;
			} else {
				throw "Unsupported type of the key " + getQualifiedClassName(key);
			}
			return view;
		}

		/**
		 *  Удаляет вьюшку переданной связи.
		 * @param edge
		 */
		public function removeEdgeView(edge:Edge):void
		{
			var view:Sprite = edgeViews[edge];
			delete edgeViews[view];
			edgeCanvas.removeChild(view);
		}

		/**
		 * Добавляет вьюшку для переданной связи.
		 * @param edge
		 */
		public function addEdgeView(edge:Edge):void
		{
			var view:Sprite = new Sprite();
			view.doubleClickEnabled = true;
			edgeViews[edge] = view;
			updateEdgeView(edge);
			edgeCanvas.addChild(view);
		}

		/**
		 * Перерисовывает связь в соответствии с координатами связываемых вершин.
		 * @param edge
		 */
		public function updateEdgeView(edge:Edge):void
		{
			var view:Sprite = edgeViews[edge];
			view.graphics.clear();
			view.graphics.lineStyle(Style.LINE_WIDTH, Style.LINK);
			view.graphics.moveTo(edge.rectA.x, edge.rectA.y);
			view.graphics.lineTo(edge.rectB.x, edge.rectB.y);
		}

		/**
		 * Добавляет вьюшку прямоугольника.
		 * @param rect
		 */
		public function addRectView(rect:Rect):void
		{
			var view:Sprite = new Sprite();
			var width:Number = Rect.SIZE;
			var height:Number = Rect.SIZE/Rect.ASPECT_RATIO;
			view.graphics.beginFill(0xffffff*Math.random());
			view.graphics.drawRect(-width/2, -height/2, width, height);
			view.graphics.endFill();
			rectsCanvas.addChild(view);
			view.doubleClickEnabled = true;
			rectViews[rect] = view;
			updatePosition(rect);
		}
	}
}
