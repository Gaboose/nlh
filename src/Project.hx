package;

import systems.TouchSystem;
import systems.CameraSystem;
import components.CameraComponent;
import ceramic.Color;
import ceramic.Entity;
import ceramic.InitSettings;
import ceramic.PixelArt;

class Project extends Entity {

    function new(settings:InitSettings) {
        super();

        settings.antialiasing = 2;
        settings.background = Color.BLACK;
        settings.targetWidth = Std.int(576 / 2);
        settings.targetHeight = Std.int(320 / 2);
        settings.resizable = true;
        settings.fullscreen = false;

        app.onceReady(this, ready);
    }

    function ready() {
        // Render as low resolution / pixel art
        var pixelArt = new PixelArt();
        pixelArt.bindToScreenSize();
        app.scenes.filter = pixelArt;

        // Set LdtkScene as the current scene.
        app.scenes.main = new LdtkScene("ldtk-project/ldtk.ldtk");

        // Set up camera.
        var c = new CameraComponent();
        app.scenes.main.component("camera", c);
        CameraSystem.shared = new CameraSystem(c);

        // Set up TouchSystem
        TouchSystem.shared = new TouchSystem();
    }

}
