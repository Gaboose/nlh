package triggerables;

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

interface Triggerable {
    function trigger():Void;
}