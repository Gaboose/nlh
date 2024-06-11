package systems.movement;

import ceramic.System;
import components.PlayerControlComponent;

class MovementSystem extends System {
    @lazy public static var shared:MovementSystem = new MovementSystem();

    public var playerControlComponent: PlayerControlComponent;

    private var _input: Input = new Input();

    public function new() {
        super();

        TouchSystem.shared.onClick(this, function() {playerControlComponent.action = true;});

        earlyUpdateOrder = 20000;
    }

    override function earlyUpdate(delta:Float):Void {
        var d = _input.direction();
        if (d != null) {
            playerControlComponent.bufMoveToDirection(d);
        }

        playerControlComponent.action = playerControlComponent.action || _input.actionJustPressed();

        playerControlComponent.move(delta);
    }
}