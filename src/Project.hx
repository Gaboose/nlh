package;

import ceramic.Text;
import ceramic.Filter;
import systems.TouchSystem;
import systems.CameraSystem;
import components.CameraComponent;
import ceramic.Color;
import ceramic.Entity;
import ceramic.InitSettings;
import ceramic.PixelArt;
import ceramic.Assets;
import camera.PixelArtScaler;

class Project extends Entity {

    function new(settings:InitSettings) {
        super();

        settings.antialiasing = 0;
        settings.background = Color.BLACK;
        // settings.targetWidth = 640;
        // settings.targetHeight = 480;
        // settings.windowWidth = 800;
        // settings.windowHeight = 600;
        // settings.scaling = FIT;
        // settings.scaling = FIT_RESIZE;
        settings.resizable = true;
        // settings.fullscreen = false;

        settings.targetFps = 60;

        app.onceDefaultAssetsLoad(this, loadAssets);
        app.onceReady(this, ready);
    }

    function loadAssets(assets:Assets) {
        assets.addShader(Shaders.GAUSSIAN_BLUR);
        assets.addFont(Fonts.PIXELIFY_SANS);
    }

    function ready() {
        // Set LdtkScene as the current scene.
        app.scenes.main = new LdtkScene("ldtk-project/ldtk.ldtk", app.assets);

        var pixelArtScaler = new PixelArtScaler();
        pixelArtScaler.filter.bindToScreenSize();
        app.scenes.main.component("pixelArtScaler", pixelArtScaler);

        // Set up camera.
        var c = new CameraComponent();
        app.scenes.main.component("camera", c);
        CameraSystem.shared = new CameraSystem(c);

        // Set up TouchSystem
        TouchSystem.shared = new TouchSystem();
    }
}
