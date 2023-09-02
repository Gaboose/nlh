package systems;
import ceramic.Entity;

class TouchSystem extends Entity {
    public static var shared:TouchSystem;

    @event public function click();

    var start:ceramic.TouchInfo;
    var threshold:Float = 1.;

    public function new() {
        super();

        screen.onPointerDown(this, function(info:ceramic.TouchInfo):Void {
            start = info;
        });

        screen.onPointerUp(this, function(info:ceramic.TouchInfo):Void {
            if (Math.abs(info.x - start.x) < threshold && Math.abs(info.y - start.y) < threshold) {
                emitClick();
            }
        });
    }
}