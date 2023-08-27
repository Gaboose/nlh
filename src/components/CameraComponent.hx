package components;

import haxe.Timer;
import entities.Character;
import ceramic.Entity;
import ceramic.Component;
import ceramic.StateMachine;

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

    var _targetX:Float;
    var _targetY:Float;

    public function new() {
        super();
    }

    function bindAsComponent() {
        screen.onPointerDown(this, function(info:ceramic.TouchInfo):Void {
            // Don't drag if it's not a left-mouse button or a touch.
            if (info.buttonId > 0) {
                return;
            }

            screen.onPointerMove(this, drag);
        });

        screen.onPointerUp(this, function(info:ceramic.TouchInfo):Void {
            screen.offPointerMove(drag);
        });
    }

    function drag(info:ceramic.TouchInfo):Void {
        _targetX -= screen.pointerDeltaX;
        _targetY -= screen.pointerDeltaY;

        // Restrict the camera to level size;
        setLimitedScenePos(-_targetX + screen.width/2, -_targetY + screen.height/2);

        machine.state = DRAG;
        lastDraggedAt = Timer.stamp();
        emitDragged();
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

        setTarget(player.x, player.y);
        player.onMoved(this, tryFollowPlayer);
    }

    function tryFollowPlayer() {
        // Don't follow if the user just dragged.
        if (machine.state != FOLLOW) {
            return;
        }

        setTarget(player.x, player.y);
    }

    function setTarget(targetX: Float, targetY: Float):Void {
        _targetX = targetX;
        _targetY = targetY;

        var newSceneX = -targetX + screen.width/2;
        var newSceneY = -targetY + screen.height/2;

        setLimitedScenePos(newSceneX, newSceneY);
    }

    public function targetX():Float {
        return _targetX;
    }

    public function targetY():Float {
        return _targetY;
    }

    public function setLimitedScenePos(x:Float, y:Float):Void {
        x = Math.min(Math.max(x, screen.width-scene.level.pxWid), 0);
        y = Math.min(Math.max(y, screen.height-scene.level.pxHei), 0);
        scene.pos(x, y);
    }

    @event function dragged();
}