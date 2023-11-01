package triggers;

import ceramic.LdtkData.LdtkEntityInstance;

function newTrigger(entity:LdtkEntityInstance): Trigger {
    switch entity.def.identifier {
        case TriggerArea.identifier: return new TriggerArea(entity);
    }

    return null;
}

interface Trigger {
}