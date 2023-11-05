package camera;

import ceramic.Entity;

class Drag extends Entity {

    @event function drag(justChanged: Bool);

    var _touches: TouchesPointer;

    public function new(touches:TouchesPointer) {
        super();
        _touches = touches;
        _touches.onMoveGteOne(this, emitDrag);
    }
}