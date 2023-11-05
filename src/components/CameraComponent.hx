package components;

import ceramic.TouchInfo;
import camera.Drag;
import ceramic.Visual;
import ceramic.Point;
import haxe.Timer;
import entities.Character;
import ceramic.Entity;
import ceramic.Component;
import ceramic.StateMachine;
import camera.Zoom;
import camera.PixelArtScaler;

enum abstract CameraComponentState(Int) {
    var FOLLOW;
    var DRAG;
}

// Controls the camera. It's restricted by the level size,
// follows the player and can be moved with touch drags.
//
// NOTE: should these functionalities be split into separate components?
class CameraComponent extends Entity implements Component {
    @entity var scene:LdtkScene;

    @component var machine = new StateMachine<CameraComponentState>();

    var dragCooldown:Timer;
    var lastDraggedAt:Float;

    var player:Character;

    var _target:Visual = new Visual();

    var _touches:camera.TouchesPointer = new camera.TouchesPointer();
    var _drag:Drag;
    var _zoom:Zoom;

    @event function dragged();

    public function new() {
        super();
        _drag = new Drag(_touches);
        _zoom = new Zoom(_touches, 1.0, 10.0);
    }

    function bindAsComponent() {
        var pixelArtScaler: PixelArtScaler = scene.component("pixelArtScaler");
        pixelArtScaler.scale(_zoom.scale);

        _drag.onDrag(this, function(justChanged:Bool) {
            if (justChanged) {
                return;
            }

            var p = Utils.visualPointerDelta(scene, _touches.lastPointerX, _touches.lastPointerY);

            scene.x += p.x;
            scene.y += p.y;
            setTargetToScreenCenter();

            machine.state = DRAG;
            lastDraggedAt = Timer.stamp();
            emitDragged();
        });

        _zoom.onScaleChange(this, function(lastScale:Float, scale: Float, anchorScreen: Point) {
            var pixelArtScaler: PixelArtScaler = scene.component("pixelArtScaler");
            pixelArtScaler.scale(scale);

            var invScaleDiff = 1.0/scale - 1.0/lastScale;
            scene.x += anchorScreen.x * invScaleDiff;
            scene.y += anchorScreen.y * invScaleDiff;

            setTargetToScreenCenter();

            machine.state = DRAG;
            lastDraggedAt = Timer.stamp();
            emitDragged();
        });

        scene.add(_target);
    }

    function DRAG_update(delta:Float):Void {
        if (Timer.stamp() > lastDraggedAt + 2) {
            machine.state = FOLLOW;
        }
    }

    public function setPlayer(player:Character):Void {
        if (this.player != null) {
            player.offMoved(tryFollowPlayer);
        }

        this.player = player;

        _target.x = player.x;
        _target.y = player.y;
        setSceneToTarget();

        player.onMoved(this, tryFollowPlayer);
    }

    function tryFollowPlayer() {
        // Don't follow if the user just dragged.
        if (machine.state != FOLLOW) {
            return;
        }

        _target.x = player.x;
        _target.y = player.y;
        // setSceneToTarget();
    }

    public function targetX():Float {
        return _target.x;
    }

    public function targetY():Float {
        return _target.y;
    }

    // public function setLimitedScenePos(x:Float, y:Float):Void {
    //     // x = Math.min(Math.max(x, screen.width-scene.level.pxWid), 0);
    //     // y = Math.min(Math.max(y, screen.height-scene.level.pxHei), 0);
    //     scene.pos(x, y);
    // }

    public function setTargetToScreenCenter():Void {
        var p = new Point();
        scene.screenToVisual(screen.nativeWidth/2, screen.nativeHeight/2, p);

        _target.x = p.x;
        _target.y = p.y;

        // _targetX = -scene.x + p.x;
        // _targetY = -scene.y + p.y;
    }

    public function setSceneToTarget():Void {
        var center = new Point();
        scene.screenToVisual(screen.actualWidth/2, screen.actualHeight/2, center);

        scene.x = center.x - _target.x;
        scene.y = center.y - _target.y;
    }
}