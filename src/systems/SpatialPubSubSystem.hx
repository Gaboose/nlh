package systems;

import ceramic.Entity;

class SpatialPubSubSystem extends Entity {

    public static var shared = new SpatialPubSubSystem();

    var subs: Array<BoxSub> = [];

    function new() {
        super();
    }

    public function emit(box:Box, topic:String) {
        for (sub in subs) {
            if (sub.box.overlaps(box) && sub.topic == topic) {
                sub.emitPublish();
            }
        }
    }

    public function on(owner: Null<Entity>, box: Box, topic: String, handle: () -> Void) {
        var sub = new BoxSub(box, topic);
        sub.onPublish(owner, handle);
        subs.push(sub);

        owner.onDestroy(this, function(entity:Entity):Void {
            sub.destroy();
        });

        sub.onDestroy(this, function(entity:Entity):Void {
            subs.remove(sub);
        });
    }
}

class BoxSub extends Entity {
    public var box:Box;
    public var topic:String;

    public function new(box:Box, topic: String) {
        super();
        this.box = box;
        this.topic = topic;
    }

    @event public function publish();
}

class Box {
    public var px:Float;
    public var py:Float;
    public var width:Float;
    public var height:Float;

    public function new(px:Float, py:Float, width:Float, height:Float) {
        this.px = px;
        this.py = py;
        this.width = width;
        this.height = height;
    }

    public function overlaps(other: Box): Bool {
        return overlaps1D(px, width, other.px, other.width) && 
            overlaps1D(py, height, other.py, other.height);
    }
}

function overlaps1D(x1:Float, w1:Float, x2:Float, w2:Float):Bool {
    return (x1 <= x2 && x1 + w1 >= x2) || (x1 >= x2 && x1 <= x2 + w2);
}