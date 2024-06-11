package systems.camera;

import ceramic.Entity;
import ceramic.Point;

class Drag extends Entity {

    @event function drag(touchIndexesChanged: Bool);

    var _touches: TouchesPointer;

    public function new(touches:TouchesPointer) {
        super();
        _touches = touches;
        _touches.onMoveGteOne(this, emitDrag);
    }

    public function isHeld(): Bool {
        return _touches.touchesPointer().length > 0;
    }

    public function moved(): Bool {
        return isHeld() && !_touches.jumped() && (screen.pointerDeltaX != 0 || screen.pointerDeltaY != 0);
    }

    public function delta(): Point {
        var p = new Point();
        p.x = screen.pointerDeltaX;
        p.y = screen.pointerDeltaY;
        return p;
    }
}