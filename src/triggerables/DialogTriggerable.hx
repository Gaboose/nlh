package triggerables;

import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Entity;

class DialogTriggerable extends Entity implements Triggerable {
    public static var identifier(default, never) = "Dialog";

    var targets:Array<String>;

    public function new(entity:LdtkEntityInstance) {
        super();
    }

    public function trigger() {
        
    }
}