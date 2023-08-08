package systems;

import components.CameraComponent;

class CameraSystem {
    // Shared instance should be set manually. 
    public static var shared:CameraSystem;

    public var cameraComponent:CameraComponent;

    public function new(cameraComponent:CameraComponent) {
        this.cameraComponent = cameraComponent;
    }
}