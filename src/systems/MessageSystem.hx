package systems;

import components.FlickerComponent;
import ceramic.Sprite;
import ceramic.Entity;
import ceramic.Component;
import tracker.Observable;

// Think of MessageSystem as a network abstraction even though the game is
// single player only so far. In that case state like "visible" and "enabled"
// is better stored here instead of entity components so that newly joined
// players can access it.
class MessageSystem {
    public static var triggers = new PubSubVoid();
    public static var flicker = new PubSub<Float>();
    public static var visible = new SetGet<Bool>();
    public static var enabled = new SetGet<Bool>();
}

class PubSubVoid {
    private var broadcasters:Map<String, BroadcasterVoid> = [];

    public function new() {};

    public function topic(topic: String): BroadcasterVoid {
        var b = broadcasters.get(topic);
        if (b == null) {
            b = new BroadcasterVoid();
            broadcasters.set(topic, b);
        }

        return b;
    }
}

class BroadcasterVoid extends Entity {
    @event public function broadcast();
}

class PubSub<T> {
    private var broadcasters:Map<String, Broadcaster<T>> = [];

    public function new() {};

    public function topic(topic: String): Broadcaster<T> {
        var b = broadcasters.get(topic);
        if (b == null) {
            b = new Broadcaster<T>();
            broadcasters.set(topic, b);
        }

        return b;
    }
}

class Broadcaster<T> extends Entity {
    @event public function broadcast(message: T);
}

class SetGet<T> {
    private var observers: Map<String, Observer<T>> = [];

    public function new() {};

    public function topic(topic: String): Observer<T> {
        var o = observers.get(topic);
        if (o == null) {
            o = new Observer<T>();
            observers.set(topic, o);
        }

        return o;
    }
}

class Observer<T> extends Entity implements Observable {
    @observe public var value: T;

    // If the value is not null getNonNull calls back immediatelly with it.
    // Otherwise it calls back with the value when it is set.
    public function getNonNull(handle: (value: T) -> Void) {
        if (value != null)
            handle(value);

        onceValueChange(this, function(current: T, previous: T) {
            handle(current);
        });
    }
}

class SpriteSubscriber extends Entity implements Component {
    @entity var sprite:Sprite;

    var iid: String;

    public function new(iid: String) {
        super();
        this.iid = iid;
    }

    function bindAsComponent() {
        MessageSystem.visible.topic(iid).onValueChange(this, function(current: Bool, previous: Bool) {
            sprite.visible = current;
        });

        MessageSystem.flicker.topic(iid).onBroadcast(this, function(duration: Float) {
            sprite.component("flicker", new FlickerComponent(duration));
        });
    }
}