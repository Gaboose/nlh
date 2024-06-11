package systems.camera;

import systems.camera.TouchesPointer;
import ceramic.TouchInfo;
import ceramic.Visual;
import ceramic.Point;
import haxe.Timer;
import entities.Character;
import ceramic.Entity;
import ceramic.Component;
import ceramic.StateMachine;
import ceramic.Point;

class CameraAttractorComponent extends Entity implements Component {
    @entity var visual:Visual;

    public function new() {
        super();
        CameraSystem.shared.attractorComponent = this;
    }

    function bindAsComponent() {
        
    }

    public inline function targetWorld(): Point {
        // var d = cameraDisplacement();
        // return new Point(visual.x + d.x, visual.y + d.y);
        return new Point(visual.x, visual.y);
    }

    // public inline function cameraDisplacement(): Point {
    //     return new Point(30 * visual.scaleX, -10);
    // }
}