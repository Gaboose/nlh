package triggers;

import systems.EntityRegistrySystem;
import systems.SpatialPubSubSystem;
import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Entity;
import triggerables.Triggerable;

class TriggerArea extends Entity implements Trigger {
    public static var identifier(default, never) = "TriggerArea";

    var onTrigger:Array<LdtkEntityInstance>;
    var condition:String;

    public function new(entity:LdtkEntityInstance) {
        super();

        // Parse fields.
        for (fieldInstance in entity.fieldInstances) {
            switch fieldInstance.def.identifier {
                case "onTrigger":
                    onTrigger = fieldInstance.value;
                case "condition":
                    condition = fieldInstance.value;
            }
        }

        SpatialPubSubSystem.shared.on(
            this, 
            new Box(entity.pxX, entity.pxY, entity.width, entity.height),
            condition,
            trigger
        );
    }

    function trigger() {
       
        for (ldtkEntity in onTrigger) {
            var entity = EntityRegistrySystem.shared.get(ldtkEntity.iid);
            if (entity == null) {
                continue;
            }

            var trigger: Triggerable;
            try {
                trigger = cast(entity, Triggerable);
            } catch (e:Any) {
                continue;
            }

            trigger.trigger();
        }

        destroy();
    }
}