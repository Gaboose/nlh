package components;

import ceramic.Entity;
import ceramic.Component;

// Controls the camera. It's restricted by the level size, follows the player
// and can be moved with touch swipes.
//
// NOTE: should these functionalities be split into separate components?
class CameraComponent extends Entity implements Component {
    @entity var scene:LdtkScene;

    var startX:Float;
    var startY:Float;

    public function new() {
        super();
    }

    function bindAsComponent() {
        screen.onPointerDown(this, function(info:ceramic.TouchInfo):Void {
            // Don't drag if it's not a left-mouse button or a touch.
            if (info.buttonId > 0) {
                return;
            }

            startX = scene.x - screen.pointerX;
            startY = scene.y - screen.pointerY;

            screen.onPointerMove(this, drag);
        });

        screen.onPointerUp(this, function(info:ceramic.TouchInfo):Void {
            screen.offPointerMove(drag);
        });
    }

    function drag(info:ceramic.TouchInfo):Void {
        var newX = startX + screen.pointerX;
        var newY = startY + screen.pointerY;

        // Restrict the camera to level size;
        newX = Math.min(Math.max(newX, screen.width-scene.level.pxWid), 0);
        newY = Math.min(Math.max(newY, screen.height-scene.level.pxHei), 0);

        scene.pos(newX, newY);

        emitDragged();
    }

    public function centerX():Float {
        return screen.width/2 - scene.x;
    }

    public function centerY():Float {
        return screen.height/2 - scene.y;
    }

    @event function dragged();
}