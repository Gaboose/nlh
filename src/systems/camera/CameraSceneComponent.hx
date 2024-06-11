package systems.camera;

import systems.camera.TouchesPointer;
import systems.camera.TouchesPointer;
import systems.camera.TouchesPointer;
import systems.camera.TouchesPointer;
import ceramic.Entity;
import ceramic.Component;
import ceramic.Point;
import ceramic.Scene;

class CameraSceneComponent extends Entity implements Component {
    @entity var _scene:LdtkScene;

    var _vel: Point = new Point();

    public function new() {
        super();
    }

    function bindAsComponent() {
        CameraSystem.shared.sceneComponent = this;
    }

    public function moveToTarget(target: Point, delta: Float) {
        var center = visualCenter();
        var dx = target.x-center.x;
        var dy = target.y-center.y;

        var factor = delta * 3;
        _vel.x -= dx * factor;
        _vel.y -= dy * factor;

        // var factor = 1-Math.exp(-delta*5);

        // _scene.x -= dx*factor;
        // _scene.y -= dy*factor;
    }

    public inline function setMomentum(velx:Float, vely:Float):Void {
        _vel.x = velx;
        _vel.y = vely;
    }

    public inline function applyMomentum(delta:Float):Void {
        _vel.x *= 0.95;
        _vel.y *= 0.95;
        _scene.x += _vel.x * delta;
        _scene.y += _vel.y * delta;
    }

    public function moveByScreenDelta(screenDelta: Point) {
        var scenePos = new Point();
        _scene.visualToScreen(0, 0, scenePos);
        var visualDelta = new Point();
        _scene.screenToVisual(screenDelta.x+scenePos.x, screenDelta.y+scenePos.y, visualDelta);
        _scene.x += visualDelta.x;
        _scene.y += visualDelta.y;
    }

    public function moveToFit(pxWid:Float, pxHei:Float) {
        var invPxScale = 1/_scene.pxScale;
        var right = screen.width*invPxScale - pxWid;
        var bottom = screen.height*invPxScale - pxHei;

        if (_scene.x > 0) {
            _scene.x = 0;
            _vel.x = 0;
        } else if (_scene.x < right) {
            _scene.x = right;
            _vel.x = 0;
        }

        if (_scene.y > 0) {
            _scene.y = 0;
            _vel.y = 0;
        } else if (_scene.y < bottom) {
            _scene.y = bottom;
            _vel.y = 0;
        }
    }

    public function visualCenter(): Point {
        var p = new Point();
        _scene.screenToVisual(screen.nativeWidth/2, screen.nativeHeight/2, p);
        return p;
    }

    public function zoom(lastScale: Float, scale: Float, anchorScreen: Point) {
        _scene.pxScale = scale;

        var invScaleDiff = 1.0/scale - 1.0/lastScale;
        _scene.x += anchorScreen.x * invScaleDiff;
        _scene.y += anchorScreen.y * invScaleDiff;
    }

    public inline function scene() {
        return this._scene;
    }
}