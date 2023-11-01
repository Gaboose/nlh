package systems;

import ceramic.Entity;

class PubSubSystem extends Entity {

    public static var shared = new PubSubSystem();

    public var topics:Map<String, Topic> = [];

    public function topic(name: String):Topic {
        var t = topics.get(name);
        if (t == null) {
            t = new Topic();
            topics.set(name, t);
            t.destroy();
        }

        return t;
    }

}

class Topic extends Entity {
    @event public function publish();
}