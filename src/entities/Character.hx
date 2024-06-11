package entities;

import ceramic.Sprite;
import components.CollidableComponent;
import ceramic.Entity;

var ANIMATION_IDLE = 'idle';
var ANIMATION_WALK = 'walk';
var ANIMATION_DEFAULT = ANIMATION_IDLE;

enum CharacterState {
    MOVE;
    ACTION;
}

class Character extends Sprite {
    public var machineState = CharacterState.MOVE;

    @event function action();
    @event function moved();

    public function new() {
        super();
    }

    // Called from PlayerControlComponent.
    inline function control(dx:Float, dy:Float, action:Bool):Void {
        // Don't move when doing an action.
        if (machineState == CharacterState.ACTION) {
            return;
        }

        // Check whether to trigger action.
        if (action) {
            emitAction();
            return;
        }

        // Check if we're standing still.
        if (dx == 0 && dy == 0) {
            animation = ANIMATION_IDLE;
            return;
        }

        // Show walking animation.
        animation = ANIMATION_WALK;

        if (dx > 0) {
            scaleX = 1;
        } else if (dx < 0) {
            scaleX = -1;
        }

        // Move character.
        var collidable:CollidableComponent = this.component("collidable");
        collidable.control(dx, dy);

        emitMoved();
    }

    // If animation is not found, set default animation.
    override function set_animation(s:String):String {
        if (s == ANIMATION_DEFAULT) {
            return super.set_animation(ANIMATION_IDLE);
        }

        for (a in sheet.animations) {
            if (a.name == s) {
                return super.set_animation(s);
            }
        }

        return super.set_animation(ANIMATION_IDLE);
    }
}