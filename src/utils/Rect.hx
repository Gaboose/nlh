package utils;

import ceramic.Visual;

class Rect {
    public static function screenToVisual(visual:Visual, rect:ceramic.Rect):ceramic.Rect {
        var topLeft = new ceramic.Point();
        visual.screenToVisual(rect.x, rect.y, topLeft);
    
        var bottomRight = new ceramic.Point();
        visual.screenToVisual(rect.x + rect.width, rect.y + rect.height, bottomRight);

        var rect = new ceramic.Rect();
        rect.x = topLeft.x;
        rect.y = topLeft.y;
        rect.width = bottomRight.x - topLeft.x;
        rect.height = bottomRight.y - topLeft.y;

        return rect;
    }
}