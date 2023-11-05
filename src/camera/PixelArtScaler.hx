package camera;

import ceramic.Entity;
import ceramic.PixelArt;
import ceramic.Visual;
import ceramic.Component;

class PixelArtScaler extends Entity implements Component {
    @entity var visual:Visual;

    public var filter: PixelArt = new PixelArt();

    public function new() {
        super();
        filter.sharpness = 1.0;
    }

    function bindAsComponent() {
        filter.content.add(visual);
        scale(1.0);
    }

    public function scale(scale:Float) {
        var intScale = Math.min(Math.max(Math.floor(scale), 1), 4);
        var filterScale = scale/intScale;

        filter.size(
            Math.round(Math.min(visual.width * intScale, screen.width/filterScale)),
            Math.round(Math.min(visual.height * intScale, screen.height/filterScale)),
        );
        filter.content.scale(intScale);
        filter.scale(filterScale);
    }
}