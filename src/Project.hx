package;

import systems.TouchSystem;
import systems.CameraSystem;
import components.CameraComponent;
import ceramic.Color;
import ceramic.Entity;
import ceramic.InitSettings;
import ceramic.Assets;
import haxe.io.Path;

class Project extends Entity {

    function new(settings:InitSettings) {
        super();

        settings.antialiasing = 0;
        settings.background = Color.BLACK;
        settings.resizable = true;
        settings.targetFps = 60;
        settings.defaultFont = Fonts.PIXELIFY_SANS;

        app.onceReady(this, ready);
    }

    function ready() {
        // Set up camera.
        CameraSystem.shared = new CameraSystem(new CameraComponent());

        // Set up TouchSystem
        TouchSystem.shared = new TouchSystem();

        function loadScene() {
            var levelNumber = (js.Syntax.code("window.location.hash"):String).substr(1);
            if (levelNumber == "") {
                levelNumber = "1";
            }

            // Set LdtkScene as the current scene.
            app.scenes.main = new LdtkScene(Path.join(["level" + levelNumber, "ldtk.ldtk"]), app.assets);
        }
        loadScene();

        js.Browser.window.addEventListener("hashchange", function(ev) {
            loadScene();
        });
    }
}
