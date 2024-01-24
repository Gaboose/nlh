package triggerables;

import ceramic.Sprite;
import systems.EntityRegistrySystem;
import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Entity;

class HideTriggerable extends Entity implements Triggerable {
    public static var identifier(default, never) = "Hide";

    var targets:Array<LdtkEntityInstance>;
    var animation:String;

    public function new(entity:LdtkEntityInstance) {
        super();

        EntityRegistrySystem.shared.emitSet(entity.iid, this);

        for (fieldInstance in entity.fieldInstances) {
            switch fieldInstance.def.identifier {
                case "targets":
                    targets = fieldInstance.value;
            }
        }
    }

    public function trigger() {
        for (target in targets) {
            var entity = EntityRegistrySystem.shared.get(target.iid);
            if (entity == null) {
                continue;
            }

            try {
                var sprite = cast(entity, Sprite<Dynamic>);
                sprite.visible = false;
            } catch(e) {
                continue;
            }
        }
    }
}