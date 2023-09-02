package components;

import ceramic.Entity;
import ceramic.Component;
import ceramic.InputMap;
import entities.Character;
import systems.CameraSystem;
import systems.TouchSystem;
import ceramic.StateMachine;

/**
 * The input keys that will make player interaction
 */
 enum abstract PlayerInput(Int) {
    var RIGHT;
    var LEFT;
    var DOWN;
    var UP;
    var ACTION;
}

enum abstract PlayerControlState(Int) {
    var KEYBOARD;
    var CAMERA;
}

class PlayerControlComponent extends Entity implements Component {
    @entity var character:Character;

    @component var machine = new StateMachine<PlayerControlState>();

    var inputMap = new InputMap<PlayerInput>();

    var velocity = 80.0;

    var _clicked = false;

    public function new() {
        super();

        bindInput();
    }

    function bindInput() {
        // Bind keyboard
        //
        inputMap.bindKeyCode(RIGHT, RIGHT);
        inputMap.bindKeyCode(LEFT, LEFT);
        inputMap.bindKeyCode(DOWN, DOWN);
        inputMap.bindKeyCode(UP, UP);
        inputMap.bindScanCode(ACTION, SPACE);
        // We use scan code for these so that it
        // will work with non-qwerty layouts as well
        inputMap.bindScanCode(RIGHT, KEY_D);
        inputMap.bindScanCode(LEFT, KEY_A);
        inputMap.bindScanCode(DOWN, KEY_S);
        inputMap.bindScanCode(UP, KEY_W);
        inputMap.bindScanCode(ACTION, KEY_E);

        // Bind gamepad
        //
        inputMap.bindGamepadAxisToButton(RIGHT, LEFT_X, 0.25);
        inputMap.bindGamepadAxisToButton(LEFT, LEFT_X, -0.25);
        inputMap.bindGamepadAxisToButton(DOWN, LEFT_Y, 0.25);
        inputMap.bindGamepadAxisToButton(UP, LEFT_Y, -0.25);
        inputMap.bindGamepadButton(RIGHT, DPAD_RIGHT);
        inputMap.bindGamepadButton(LEFT, DPAD_LEFT);
        inputMap.bindGamepadButton(DOWN, DPAD_DOWN);
        inputMap.bindGamepadButton(UP, DPAD_UP);

        TouchSystem.shared.onClick(this, function() {_clicked = true;});
    }

    function CAMERA_update(delta:Float):Void {
        // Switch to keyboard state if any of the relevant keys are pressed.
        if (inputMap.pressed(LEFT) ||
            inputMap.pressed(RIGHT) ||
            inputMap.pressed(UP) ||
            inputMap.pressed(DOWN)
        ) {
            machine.state = KEYBOARD;
            KEYBOARD_update(delta);
            return;
        }

        // Find the distance vector to the screen center.
        var c = CameraSystem.shared.cameraComponent;
        var dx = c.targetX() - character.x;
        var dy = c.targetY() - character.y;

        // Remove jitter when distance is close to zero in either axis.
        if (Math.abs(dx) < 1) { dx = 0; }
        if (Math.abs(dy) < 1) { dy = 0; }

        // Stop, if we're already here.
        var distance = Math.sqrt(dx*dx + dy*dy);
        if (distance == 0) {
            // Trigger the idle animation;
            control(0, 0);
            return;
        }

        // Move character.
        var f = delta * velocity / distance;
        control(dx*f, dy*f);
    }

    function KEYBOARD_update(delta:Float):Void {
        var dx = 0;
        var dy = 0;

        if (inputMap.pressed(LEFT)) { dx -= 1; }
        if (inputMap.pressed(RIGHT)) { dx += 1; }
        if (inputMap.pressed(UP)) { dy -= 1; }
        if (inputMap.pressed(DOWN)) { dy += 1; }

        var f = delta * velocity;
        control(dx*f, dy*f);
    }

    function control(dx:Float, dy:Float):Void {
        @:privateAccess character.control(dx, dy, inputMap.justPressed(ACTION) || _clicked);
        _clicked = false;
    }

    function bindAsComponent() {
        // Bind to the camera drag event.
        CameraSystem.shared.cameraComponent.onDragged(this, dragged);
    }

    function dragged():Void {
        machine.state = CAMERA;
    }
}