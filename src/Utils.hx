package;

import ceramic.Visual;
import ceramic.Point;
import ceramic.Rect;

using StringTools;

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

    // Returns the string without the given prefix, or null if the prefix wasn't found.
    public static function trimPrefix(string: String, prefix: String): String {
        if (!string.startsWith(prefix))
            return null;

        return string.substr(prefix.length);
    }

    // Returns true if the given point is within the given rectangle.
    public static function within(px, py, left, top, width, height): Bool {
        return px >= left && px < left + width && py >= top && py < top + height;
    }

    // Returns true if the two rectangles intersect.
    public static function intersects(r1: Rect, r2: Rect): Bool {
        return !(r1.x >= r2.x + r2.width || r2.x >= r1.x + r1.width || r1.y >= r2.y + r2.height || r2.y >= r1.y + r1.height);
    }
}
