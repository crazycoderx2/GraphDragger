package model {
	import flash.geom.Point;

	import model.VO.Edge;
	import model.VO.Rect;

	/**
	 *  Модель представления 2D-графа.  С каждой вершиной ассоциирована прямоугольная область.
	 *  Модель предоставляет методы для изменения координат вершин таким образом, чтобы они не пересекались.
	 */

	public class GraphModel {
		private static const EPS:Number = .5;
		private static var MAX_STEPS:int = 30;

		/**
		 * Указатель на вершину графа, которая будет использована в качестве первого/единственного операнда при выполнении ряда операций:
		 * перемещение, установление связи.
		 */
		public var selectedRect:Rect;
		/**
		 * Список вершин графа.
		 */
		private var rects:Vector.<Rect> = new Vector.<Rect>();
		/**
		 * Список ребер в данной ситуации показался мне более уместным, чем матрица смежности.
		 * Писать свою реализацию честного списка лишь для того, чтобы показать, что я знаю о списках, счел неуместным.
		 * Вектор в данном случае справится ничуть не хуже, а строк 10 кода сэкономлено.
		 */
		private var edges:Vector.<Edge> = new Vector.<Edge>();

		public function GraphModel()
		{
		}

		/**
		 * Добавляет вершину (прямоугольник) в граф в заданных координатах. Доступность координат здесь не проверяется.
		 * @param x
		 * @param y
		 * @return Добавленный прямоугольник.
		 */
		public function createRect(x:Number, y:Number):Rect
		{
			var rect:Rect = new Rect(x, y);
			rects.push(rect);
			return rect;
		}

		/**
		 * Добавляет связь между двумя вершинами (прямоугольниками). Существование ссылки между данными вершинами не проверяется, следует удостовериться в отсутствии связи перед вызовом этого метода.
		 * @param rectA
		 * @param rectB
		 * @return Добавленная связь.
		 */
		public function addLink(rectA:Rect, rectB:Rect):Edge
		{
			var edge:Edge = new model.VO.Edge();
			edge.rectA = rectA;
			edge.rectB = rectB;
			edges.push(edge);
			return edge
		}

		/**
		 * Возвращает <code>true</code>, если связь между данными вершинами существует,  <code>false</code> в противном случае.
		 * @param rectA
		 * @param rectB
		 * @return
		 */
		public function hasLink(rectA:Rect, rectB:Rect):Boolean
		{
			for each(var edge:Edge in edges) {
				if ((edge.rectA == rectA && edge.rectB == rectB) ||
						(edge.rectB == rectA && edge.rectA == rectB)) {
					return true;
				}
			}
			return false;
		}

		/**
		 * Удаляет переданную связь
		 * @param edge
		 */
		public function removeLink(edge:Edge):void
		{
			var position:Number = edges.indexOf(edge);
			edges.splice(position, 1);
		}

		/**
		 * Возвращает <code>true</code>, если в данных координатах можно расположить прямоугольник так, чтобы он не пересекался с другими прямоугольниками и  <code>false</code> в противном случае. Если установлен <code>selectedRect</code>, то он исключается из проверки.
		 * @return
		 * @param x
		 * @param y
		 */
		public function placeAvailable(x:Number, y:Number):Boolean
		{
			for each(var rect:Rect in rects) {
				if (rect == selectedRect) continue;
				if (Math.abs(x - rect.x) < Rect.SIZE && Math.abs(y - rect.y) < Rect.SIZE/Rect.ASPECT_RATIO) {
					return false;
				}
			}
			return true;
		}

		/**
		 * Рассчитывает координаты, в которые можно поместить <code>selectedRect</code>, чтобы он не пересекался с остальными прямоугольниками.
		 * @param targetX желаемая координата х.
		 * @param targetY желаемая координата у.
		 * @return Рассчитанная координата
		 */
		public function getPlace(targetX:Number, targetY:Number):Point
		{
			return new Point(getX(targetX), getY(targetY));
		}

		/**
		 * Простой, и достаточно дешевый способ не изобретать коллижн детектор. Если коодината х недоступна для размещения, то проверяется координата по середине между текущей и желаемой. Операция повторяется до тех пор, пока проверяемая окрестность не достигнет размеров <code>EPS</code>. Для непредвиденных ситуаций количество итераций ограничено <code>MAX_STEPS</code>.
		 * @param targetX
		 * @return
		 */
		private function getX(targetX:Number):Number
		{
			var steps:int = 0;
			var distanceX:Number = (targetX - selectedRect.x);
			var tempX:Number = targetX - distanceX/2;
			while (true) {
				distanceX = (targetX - tempX);
				if (Math.abs(targetX - tempX) < EPS || steps > MAX_STEPS) {
					if (!placeAvailable(tempX, selectedRect.y)) {
						tempX -= distanceX;
					}
					break;
				}

				var isMiddleAvailable:Boolean = placeAvailable(tempX, selectedRect.y);
				if (isMiddleAvailable) {
					tempX += distanceX/2;
				} else {
					targetX = tempX;
					tempX -= distanceX/2;
				}
				steps++;
			}
			return tempX;
		}

		private function getY(targetY:Number):Number
		{
			var steps:int = 0;
			var distanceY:Number = (targetY - selectedRect.y);
			var tempY:Number = targetY - distanceY/2;
			while (true) {
				distanceY = (targetY - tempY);
				if (Math.abs(targetY - tempY) < EPS || steps > MAX_STEPS) {
					if (!placeAvailable(selectedRect.x, tempY)) {
						tempY -= distanceY;
					}
					break;
				}

				var isMiddleAvailable:Boolean = placeAvailable(selectedRect.x, tempY);
				if (isMiddleAvailable) {
					tempY += distanceY/2;
				} else {
					targetY = tempY;
					tempY -= distanceY/2;
				}
				steps++;
			}
			return tempY;
		}
	}
}
