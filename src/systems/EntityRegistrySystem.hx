package systems;

import ceramic.Entity;

class EntityRegistrySystem extends Entity {

    public static var shared = new EntityRegistrySystem();

    var byIid: Map<String, Entity> = [];

    @event public function set(iid: String, value: Entity);

    public function new() {
        super();
        onSet(this, _set);
    }

    public function get(iid: String):Entity {
        return byIid[iid];
    }

    public function getEventually(owner:Null<Entity>, iid: String, callback: (Entity) -> Void) {
        if (byIid.exists(iid)) {
            callback(byIid[iid]);
            return;
        }

        var handler:(String, Entity) -> Void;
        handler = function(otherIid: String, value: Entity) {
            if (iid == otherIid) {
                callback(value);
                offSet(handler);
            }
        }

        onSet(owner, handler);
    }

    function _set(iid: String, value: Entity) {
        return byIid[iid] = value;
    }
}