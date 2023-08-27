package entities;

import ceramic.Sprite;

var ANIMATION_IDLE = 'idle';
var ANIMATION_WALK = 'walk';
var ANIMATION_SPELL = 'spell';
var ANIMATION_DEFAULT = ANIMATION_IDLE;

class Character extends Sprite {
    public function new() {
        super();
    }

    // Called from PlayerControlComponent.
    function control(dx:Float, dy:Float):Void {
        if (dx == 0 && dy == 0) {
            animation = ANIMATION_IDLE;
            return;
        }

        animation = ANIMATION_WALK;

        if (dx > 0) {
            scaleX = 1;
        } else if (dx < 0) {
            scaleX = -1;
        }

        x += dx;
        y += dy;

        emitMoved();
    }

    override function update(delta:Float) {
        // Update sprite
        super.update(delta);
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