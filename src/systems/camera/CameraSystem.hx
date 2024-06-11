package systems.camera;

import ceramic.System;
import components.PlayerControlComponent;
import ceramic.Point;
import ceramic.Rect;

// TODO: add momentum to dragging.
class CameraSystem extends System {
    @lazy public static var shared:CameraSystem = new CameraSystem();

    public var attractorComponent: CameraAttractorComponent;
    public var followerComponent: PlayerControlComponent;
    public var sceneComponent(default, set): CameraSceneComponent;

    var _touches:TouchesPointer = new TouchesPointer();
    var _drag:Drag;
    var _zoom:Zoom;

    public function new() {
        super();
        _drag = new Drag(_touches);
        _zoom = new Zoom(_touches, 1.0, 10.0);

        earlyUpdateOrder = 10000;
    }

    override function earlyUpdate(delta:Float):Void {    
        if (sceneComponent != null) {
            var scene = sceneComponent.scene();
            var centerRect = new Rect(screen.width/2-60, screen.height/2-15, 120, 30);

            if (followerComponent != null) {
                // followerComponent.bufMoveToTarget(scene.screenToVisual(screen.width/2, screen.height/2, screenCenterWorld););
                followerComponent.bufMoveToRect(utils.Rect.screenToVisual(scene, centerRect));
            }

            if (_drag.isHeld()) {
                var factor = 1/(delta*scene.pxScale);
                sceneComponent.setMomentum(screen.pointerDeltaX*factor, screen.pointerDeltaY*factor);
            } else if (attractorComponent != null) {
                sceneComponent.applyMomentum(delta);
                sceneComponent.moveToTarget(attractorComponent.targetWorld(), delta);
            }

            if (_drag.moved()) {
                sceneComponent.moveByScreenDelta(_drag.delta());
            }
    
            _zoom.scaleToFitAtLeast(scene.level.pxWid, scene.level.pxHei);
            if (_zoom.moved()) {
                sceneComponent.zoom(_zoom.lastFrameScale, _zoom.scale, new Point(screen.pointerX, screen.pointerY));
            }

            sceneComponent.moveToFit(scene.level.pxWid, scene.level.pxHei);
        }
    }

    function set_sceneComponent(newSceneComponent:CameraSceneComponent):CameraSceneComponent {
        var scene = newSceneComponent.scene();
        _zoom.scaleToFitAtLeast(scene.level.pxWid, scene.level.pxHei);
        newSceneComponent.zoom(_zoom.lastFrameScale, _zoom.scale, new Point());
        return sceneComponent = newSceneComponent;
    }

    public inline function scale(): Float {
        return _zoom.scale;
    }
}