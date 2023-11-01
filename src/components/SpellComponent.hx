package components;

import systems.EntityRegistrySystem;
import systems.SpatialPubSubSystem;
import ceramic.Entity;
import ceramic.Component;
import entities.Character;
import haxe.Timer;
import ceramic.LdtkData.LdtkEntityInstance;

// Should match the animation name in ldtk.
var ANIMATION_SPELL = 'spell';

class SpellComponent extends Entity implements Component {
    static var identifier(default, never) = "Spell";

    @entity var character:Character;

    function bindAsComponent() {
        character.onAction(this, startAction);
    }

    function startAction() {
        var px = character.x;
        var py = character.y;
        var width = 30;
        var height = 30;
        SpatialPubSubSystem.shared.emit(
            new Box(px-width/2, py-height/2, width, height),
            identifier
        );

        character.machineState = CharacterState.ACTION;
        character.animation = ANIMATION_SPELL;
        Timer.delay(endAction, Std.int(character.currentAnimation.duration*1000));
    }

    function endAction() {
        character.machineState = CharacterState.MOVE;
        character.animation = ANIMATION_IDLE;
    }
}