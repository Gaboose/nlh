package systems.movement;

import systems.camera.TouchesPointer;
import ceramic.InputMap;
import ceramic.Point;

enum abstract PlayerInput(Int) {
    var RIGHT;
    var LEFT;
    var DOWN;
    var UP;
    var ACTION;
}

class Input {
    public var inputMap(default, null) = new InputMap<PlayerInput>();

    public function new() {
        bindInput();
    }

    function bindInput() {
        // Bind keyboard
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
        inputMap.bindGamepadAxisToButton(RIGHT, LEFT_X, 0.25);
        inputMap.bindGamepadAxisToButton(LEFT, LEFT_X, -0.25);
        inputMap.bindGamepadAxisToButton(DOWN, LEFT_Y, 0.25);
        inputMap.bindGamepadAxisToButton(UP, LEFT_Y, -0.25);
        inputMap.bindGamepadButton(RIGHT, DPAD_RIGHT);
        inputMap.bindGamepadButton(LEFT, DPAD_LEFT);
        inputMap.bindGamepadButton(DOWN, DPAD_DOWN);
        inputMap.bindGamepadButton(UP, DPAD_UP);
    }

    public function direction(): ceramic.Point {
        var d = new Point();
        var returnNull = true;

        if (inputMap.pressed(LEFT)) { returnNull = false; d.x -= 1; }
        if (inputMap.pressed(RIGHT)) { returnNull = false; d.x += 1; }
        if (inputMap.pressed(UP)) { returnNull = false; d.y -= 1; }
        if (inputMap.pressed(DOWN)) { returnNull = false; d.y += 1; }

        if (returnNull) {
            return null;
        }

        return d;
    }

    inline public function actionJustPressed(): Bool {
        return inputMap.justPressed(ACTION);
    }
}