package systems.camera;

import ceramic.Entity;
import ceramic.Touch;

class Pinch extends Entity {

    public var distance(default,null):Float = null;
    public var lastDistance(default,null):Float = null;

    @event function move();

    var _touches:TouchesPointer;

    public function new(touches: TouchesPointer) {
        super();

        _touches = touches;
        touches.onMoveGteTwo(this, handleTouchMove);
    }

    public inline function scaleChange(): Float {
        if (lastDistance == null) {
            return 1.0;
        }

        return distance / lastDistance;
    }

    function handleTouchMove(touchIndexesChanged: Bool) {
        lastDistance = distance;
        distance = _touches.distanceFromMean();

        if (touchIndexesChanged) {
            return;
        }

        emitMove();
    }
}