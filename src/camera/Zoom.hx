package camera;

import camera.Pinch;
import ceramic.Entity;
import ceramic.Point;

class Zoom extends Entity {
    @event public function scaleChange(lastScale: Float, scale:Float, anchorScreen: Point);

    public var scale(default, null):Float = 2.0;

    var _pinch: Pinch;

    // var _startScale:Float;
    var _minScale:Float;
    var _maxScale:Float;

    public function new(touches: TouchesPointer, minScale: Float, maxScale: Float) {
        super();

        _minScale = minScale;
        _maxScale = maxScale;

        _pinch = new Pinch(touches);
        _pinch.onMove(this, handlePinchMove);

        screen.onMouseWheel(this, handleMouseWheel);
    }

    function handlePinchMove() {
        setScale(scale * _pinch.scaleChange());
    }

    function handleMouseWheel(x:Float, y:Float) {
        setScale(scale * (1 - y * 0.005));
    }

    inline function setScale(v: Float) {
        var _lastScale = scale;
        scale = Math.min(Math.max(v, _minScale), _maxScale);
        emitScaleChange(_lastScale, scale, new Point(screen.pointerX, screen.pointerY));
    }
}