package components;

import ceramic.Entity;
import ceramic.Component;
import ceramic.InputMap;
import entities.Character;
import systems.camera.CameraSystem;
import systems.movement.MovementSystem;
import systems.TouchSystem;
import ceramic.StateMachine;
import ceramic.Point;
import ceramic.Rect;

final velocity: Float = 80;

class PlayerControlComponent extends Entity implements Component {
    @entity var character:Character;

    public var velx: Float;
    public var vely: Float;

    public var action: Bool;

    public function new() {
        super();
        MovementSystem.shared.playerControlComponent = this;
        CameraSystem.shared.followerComponent = this;
    }

    function bindAsComponent() {
        
    }

    public inline function bufMoveToDirection(normalDir: Point) {
        velx = normalDir.x * velocity;
        vely = normalDir.y * velocity;
    }

    public inline function bufMoveToTarget(target: Point) {
        var dx = target.x - character.x;
        var dy = target.y - character.y;

        // Remove jitter when distance is close to zero in either axis.
        if (Math.abs(dx) < 1) { dx = 0; }
        if (Math.abs(dy) < 1) { dy = 0; }

        // Stop, if we're already here.
        var distance = Math.sqrt(dx*dx + dy*dy);
        if (distance == 0) {
            return;
        }

        // Set the velocity vector.
        velx = dx * velocity / distance;
        vely = dy * velocity / distance;
    }

    public inline function bufMoveToRect(rect: Rect) {
        bufMoveToTarget(new Point(
            Math.min(Math.max(character.x, rect.x), rect.x + rect.width),
            Math.min(Math.max(character.y, rect.y), rect.y + rect.height),
        ));
    }

    public inline function move(delta: Float) {
        @:privateAccess character.control(velx*delta, vely*delta, action);
        velx = 0;
        vely = 0;
        action = false;
    }
}