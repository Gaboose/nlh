package systems.camera;

import ceramic.Entity;
import ceramic.Point;

class Zoom extends Entity {
    @event public function scaleChange(lastScale: Float, scale:Float, anchorScreen: Point);

    public var scale:Float = 2.0;
    public var lastScale(default, null):Float = 2.0;
    public var lastFrameScale(default, null):Float = 2.0;

    var _touches: TouchesPointer;
    var _pinch: Pinch;

    // var _startScale:Float;
    var _minScale:Float;
    var _maxScale:Float;

    var scaleSetFrame:Int;

    public function new(touches: TouchesPointer, minScale: Float, maxScale: Float) {
        super();

        _minScale = minScale;
        _maxScale = maxScale;

        _touches = touches;
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

    public inline function setScale(v: Float) {
        if (scaleSetFrame != app.frame) {
            scaleSetFrame = app.frame;
            lastFrameScale = scale;
        }
        lastScale = scale;
        scale = Math.min(Math.max(v, _minScale), _maxScale);
        emitScaleChange(lastScale, scale, new Point(screen.pointerX, screen.pointerY));
    }

    public inline function scaleToFitAtLeast(pxWid:Float, pxHei:Float) {
        var minScale = Math.max(screen.width / pxWid, screen.height / pxHei);
        if (scale < minScale) {
            setScale(minScale);
        }
    }

    public function isHeld() {
        return _touches.touches.length > 1;
    }

    public function moved() {
        return !_touches.jumped() && scaleSetFrame == app.frame;
    }
}