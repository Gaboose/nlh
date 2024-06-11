package systems.camera;

import ceramic.Entity;
import ceramic.Touch;

class TouchesPointer extends Entity {
    public var touches(default, null):Array<Touch> = [];

    // Updated per move event (can be multiple times per frame).
    // screen.pointerDeltaX/Y accumulates over a frame, which is not helpful when
    // dragging per move event. Use these instead.
    public var lastPointerX(default, null):Float = null;
    public var lastPointerY(default, null):Float = null;

    @event function moveGteOne(touchIndexesChanged: Bool);
    @event function moveGteTwo(touchIndexesChanged: Bool);

    // We need this buf to be set to true in handlePointerUp/Down to account
    // for touch change events that happen without any move events in between.
    var touchIndexesChangedBuf:Bool = false;
    var touchIndexesChangedBufSentFrame:Int = 0;

    public function new() {
        super();
        screen.onMultiTouchPointerMove(this, handlePointerMove);
        screen.onMultiTouchPointerDown(this, handlePointerDown);
        screen.onMultiTouchPointerUp(this, handlePointerUp);
    }

    public function distanceFromMean() {
        var acc = 0.0;
        for (touch in touches) {
            var dx = touch.x - screen.pointerX;
            var dy = touch.y - screen.pointerY;
            acc += Math.sqrt(dx*dx + dy*dy);
        }
        return acc / touches.length;
    }

    public function jumped():Bool {
        // Clear touchPressBuf, but return true for the whole frame.
        if (touchIndexesChangedBuf || app.frame == touchIndexesChangedBufSentFrame) {
            touchIndexesChangedBuf = false;
            touchIndexesChangedBufSentFrame = app.frame;
            return true;
        }

        return false;
    }

    function handlePointerDown(info:ceramic.TouchInfo) {
        touchIndexesChangedBuf = true;
    }

    function handlePointerUp(info:ceramic.TouchInfo) {
        touchIndexesChangedBuf = true;
    }

    function handlePointerMove(info:ceramic.TouchInfo):Void {
        updateTouches();
        emitUpdates();
        updatePointer();
    }

    function emitUpdates() {
        // When the touch indexes change, the average touch position jumps.
        // Let the event listeners know, so that they can update derivative
        // vars to compare with the next iteration, but don't react otherwise.
        var jumped = jumped();

        if (touches.length == 0) {
            return;
        }

        emitMoveGteOne(jumped);

        if (touches.length == 1) {
            return;
        }

        emitMoveGteTwo(jumped);
    }

    function updateTouches() {
        this.touches = touchesPointer();
    }

    public function touchesPointer(): Array<Touch> {
        var touches = [];
        for (touch in screen.touches) {
            touches.push(touch);
        }

        if (touches.length == 0 && screen.isPointerDown) {
            var t: Touch = {index: -1, x: screen.pointerX, y: screen.pointerY, deltaX: 0, deltaY: 0};
            touches.push(t);
        }
        
        return touches;
    }

    function updatePointer() {
        lastPointerX = screen.pointerX;
        lastPointerY = screen.pointerY;
    }
}