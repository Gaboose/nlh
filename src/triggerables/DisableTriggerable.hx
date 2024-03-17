package triggerables;

import systems.MessageSystem;
import ceramic.LdtkData.LdtkEntityInstance;

class DisableTriggerable extends Triggerable {
    public static var identifier(default, never) = "Disable";

    var targets:Array<LdtkEntityInstance>;

    public function new(entity:LdtkEntityInstance) {
        super();

        MessageSystem.triggers.topic(entity.iid).onBroadcast(this, trigger);

        for (fieldInstance in entity.fieldInstances) {
            switch fieldInstance.def.identifier {
                case "targets":
                    targets = fieldInstance.value;
            }
        }
    }

    public function trigger() {
        for (target in targets) {
            MessageSystem.enabled.topic(target.iid).value = false;
        }
    }
}