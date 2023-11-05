package;

import ceramic.Visual;
import ceramic.Point;

class Utils {
    public static function visualPointerDelta(visual: Visual, lastPointerX: Float, lastPointerY: Float): Point {
        var point = new Point();
        visual.screenToVisual(screen.pointerX, screen.pointerY, point);
    
        var lastPoint = new Point();
        visual.screenToVisual(lastPointerX, lastPointerY, lastPoint);
    
        var pointerDelta = new Point();
        pointerDelta.x = point.x-lastPoint.x;
        pointerDelta.y = point.y-lastPoint.y;
    
        return pointerDelta;
    }
}
