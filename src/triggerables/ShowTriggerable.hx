package triggerables;

import systems.MessageSystem;
import ceramic.Visual;
import ceramic.Sprite;
import systems.EntityRegistrySystem;
import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Entity;

class ShowTriggerable extends Triggerable {
    public static var identifier(default, never) = "Show";

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
            MessageSystem.visible.topic(target.iid).value = true;
        }
    }
}