package triggerables;

import systems.MessageSystem;
import ceramic.Sprite;
import systems.EntityRegistrySystem;
import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Entity;
import components.FlickerComponent;

class FlickerTriggerable extends Triggerable {
    public static var identifier(default, never) = "Flicker";

    var targets:Array<LdtkEntityInstance>;
    var duration:Float;

    public function new(entity:LdtkEntityInstance) {
        super();

        MessageSystem.triggers.topic(entity.iid).onBroadcast(this, trigger);

        for (fieldInstance in entity.fieldInstances) {
            switch fieldInstance.def.identifier {
                case "targets":
                    targets = fieldInstance.value;
                case "duration":
                    duration = fieldInstance.value;
            }
        }
    }

    public function trigger() {
        for (target in targets) {
            MessageSystem.flicker.topic(target.iid).emitBroadcast(duration);
        }
    }
}