package entities;

import haxe.Timer;
import ceramic.Sprite;
import components.CollidableComponent;
import ceramic.StateMachine;

var ANIMATION_IDLE = 'idle';
var ANIMATION_WALK = 'walk';
var ANIMATION_ACTION = 'action';
var ANIMATION_DEFAULT = ANIMATION_IDLE;

enum abstract CharacterState(Int) {
    var MOVE;
    var ACTION;
}

class Character extends Sprite {
    @component var machine = new StateMachine<CharacterState>();

    public function new() {
        super();
    }

    // Called from PlayerControlComponent.
    function control(dx:Float, dy:Float, action:Bool):Void {
        // Don't move when doing an action.
        if (machine.state == ACTION) {
            return;
        }

        // Check whether to trigger action.
        if (action) {
            machine.state = ACTION;
            animation = ANIMATION_ACTION;
            Timer.delay(end_action, Std.int(currentAnimation.duration*1000));
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

    function end_action() {
        machine.state = MOVE;
        animation = ANIMATION_IDLE;
    }

    function MOVE_update(delta:Float) {

    }

    function ACTION_update(delta:Float) {

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

    @event function moved();
}