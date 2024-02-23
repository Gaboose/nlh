package triggerables;

import ceramic.Entity;
import ceramic.Visual;
import ceramic.LdtkData.LdtkEntityInstance;

function newTriggerable(entity:LdtkEntityInstance): Triggerable {
    switch entity.def.identifier {
        case ShowTriggerable.identifier: return new ShowTriggerable(entity);
        case HideTriggerable.identifier: return new HideTriggerable(entity);
        case DialogTriggerable.identifier: return new DialogTriggerable(entity);
        case FlickerTriggerable.identifier: return new FlickerTriggerable(entity);
    }

    return null;
}

abstract class Triggerable extends Entity {
    public var visual:Visual;
    abstract public function trigger():Void;
}