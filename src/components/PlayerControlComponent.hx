package components;

import ceramic.Entity;
import ceramic.Component;
import ceramic.InputMap;
import entities.Character;

/**
 * The input keys that will make player interaction
 */
 enum abstract PlayerInput(Int) {

    var RIGHT;

    var LEFT;

    var DOWN;

    var UP;

}

class PlayerControlComponent extends Entity implements Component {
    @entity var character:Character;

    var inputMap = new InputMap<PlayerInput>();

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
        // We use scan code for these so that it
        // will work with non-qwerty layouts as well
        inputMap.bindScanCode(RIGHT, KEY_D);
        inputMap.bindScanCode(LEFT, KEY_A);
        inputMap.bindScanCode(DOWN, KEY_S);
        inputMap.bindScanCode(UP, KEY_W);

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
    }

    function update(delta:Float):Void {
        var v = 80.0;
        var dx = 0;
        var dy = 0;

        if (inputMap.pressed(LEFT)) {
            dx -= 1;
        }

        if (inputMap.pressed(RIGHT)) {
            dx += 1;
        }

        if (inputMap.pressed(UP)) {
            dy -= 1;
        }

        if (inputMap.pressed(DOWN)) {
            dy += 1;
        }

        var dxf = dx*v*delta;
        var dyf = dy*v*delta;

        @:privateAccess character.control(dxf, dyf);
    }

    function bindAsComponent() {
        // Bind to app's 'update' event
        app.onUpdate(this, update);
    }
}