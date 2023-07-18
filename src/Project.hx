package;

import ceramic.Color;
import ceramic.Entity;
import ceramic.InitSettings;
import ceramic.PixelArt;

class Project extends Entity {

    function new(settings:InitSettings) {

        super();

        settings.antialiasing = 2;
        settings.background = Color.BLACK;
        settings.targetWidth = 576;
        settings.targetHeight = 320;
        settings.windowWidth = 1024;
        settings.windowHeight = 520;
        settings.scaling = FIT;
        settings.resizable = true;
        settings.fullscreen = false;

        app.onceReady(this, ready);

    }

    function ready() {
        // Render as low resolution / pixel art
        var pixelArt = new PixelArt();
        pixelArt.bindToScreenSize();
        app.scenes.filter = pixelArt;

        // Set MainScene as the current scene (see MainScene.hx)
        app.scenes.main = new MainScene();
    }

}
