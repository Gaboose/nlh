package triggerables;

import systems.MessageSystem;
import ceramic.Sprite;
import systems.EntityRegistrySystem;
import ceramic.LdtkData.LdtkEntityInstance;

class HideTriggerable extends Triggerable {
    public static var identifier(default, never) = "Hide";

    var targets:Array<LdtkEntityInstance>;
    var animation:String;

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
            MessageSystem.visible.topic(target.iid).value = false;
        }
    }
}