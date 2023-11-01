package triggerables;

import ceramic.Sprite;
import systems.EntityRegistrySystem;
import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Entity;
import components.FlickerComponent;

class FlickerTriggerable extends Entity implements Triggerable {
    public static var identifier(default, never) = "Flicker";

    var targets:Array<LdtkEntityInstance>;
    var duration:Float;

    public function new(entity:LdtkEntityInstance) {
        super();

        EntityRegistrySystem.shared.emitSet(entity.iid, this);

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
            var entity = EntityRegistrySystem.shared.get(target.iid);
            if (entity == null) {
                continue;
            }

            var sprite:Sprite<Dynamic>;
            try {
                sprite = cast(entity, Sprite<Dynamic>);
            } catch(e) {
                continue;
            }

            sprite.component("flicker", new FlickerComponent(duration));
        }
    }
}