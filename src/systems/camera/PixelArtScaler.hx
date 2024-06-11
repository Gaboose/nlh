package systems.camera;

import ceramic.Entity;
import ceramic.PixelArt;
import ceramic.Visual;
import ceramic.Component;

class PixelArtScaler extends Entity implements Component {
    @entity var visual:Visual;

    public var filter: PixelArt = new PixelArt();

    public var scale(default, set):Float = 1.0;

    public function new() {
        super();
        filter.sharpness = 1.0;
    }

    function bindAsComponent() {
        filter.content.add(visual);
        scale = 1.0;
    }

    public function set_scale(newScale:Float):Float {
        var contentScale = Math.min(Math.max(Math.floor(newScale), 1), 4);
        var filterScale = newScale/contentScale;

        // Match the filter size to the content size but not larger than the screen.
        filter.size(
            Math.round(Math.min(visual.width * contentScale, screen.width/filterScale)),
            Math.round(Math.min(visual.height * contentScale, screen.height/filterScale)),
        );

        // Scale content by an integer to reduce blurriness.
        filter.content.scale(contentScale);

        // Scale filter the rest of the way.
        filter.scale(filterScale);

        return scale = newScale;
    }
}