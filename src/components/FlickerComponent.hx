package components;

import ceramic.Filter;
import ceramic.Assets;
import ceramic.Easing;
import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Component;
import ceramic.Entity;
import ceramic.Sprite;
import entities.Character;
import ceramic.Blending;

class FlickerComponent extends Entity implements Component {
    @entity var sprite:Sprite;

    var duration:Float;
    var elapsedTime:Float = 0.0;
    var elapsedFrames:Int = 0;

    public function new(duration:Float) {
        super();
        this.duration = duration;
    }

    function bindAsComponent() {
        // var blur = app.assets.shader(Shaders.GAUSSIAN_BLUR).clone();
        // blur.setVec2('resolution', sprite.width, sprite.height);
        // blur.setVec2('blurSize', 8.0, 8.0);
        // sprite.shader = blur;

        // var assets = 

        // var blur = app.assets.shader(Shaders.GAUSSIAN_BLUR).clone();

        app.onUpdate(this, update);
    }

    function update(delta:Float) {
        elapsedTime += delta;
        elapsedFrames++;

        sprite.visible = (elapsedFrames % 4) < 2;

        if (elapsedTime >= duration) {
            sprite.visible = true;
            destroy();
        }
    }
}