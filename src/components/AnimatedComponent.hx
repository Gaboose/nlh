package components;

import ceramic.Quad;
import ceramic.Tileset;
import ceramic.SpriteSheetAnimation;
import ceramic.SpriteSheetFrame;
import ceramic.LdtkData.LdtkTilesetRectangle;
import ceramic.Assets;
import ceramic.Entity;
import ceramic.Component;
import ceramic.Sprite;
import ceramic.SpriteSheet;
import ceramic.LdtkData.LdtkEntityInstance;

// Reads ldtk entity fields "sprite" and "animations",
// loads the specified sprite sheet and sets up animation states.
class AnimatedComponent extends Entity implements Component {
    @entity var sprite:Sprite;

    var ldtkEntity:LdtkEntityInstance;

    var fieldSprite:String;

    var fieldAnimationTiles:Array<LdtkTilesetRectangle>;
    var fieldAnimationRate:Float;
    var fieldHidden:Bool;

    public function new(ldtkEntity:LdtkEntityInstance) {
        super();

        this.ldtkEntity = ldtkEntity;

        var fields = new Map<String, Any>();
        for (fieldInstance in ldtkEntity.fieldInstances) {
            fields.set(fieldInstance.def.identifier, fieldInstance.value);
        }

        this.fieldAnimationTiles = cast fields["AnimationTiles"];
        this.fieldAnimationRate = cast setOrDefault(fields["AnimationRate"], 5);
        this.fieldHidden = cast setOrDefault(fields["Hidden"], false);
    }

    function bindAsComponent() {
        sprite.x = ldtkEntity.pxX;
        sprite.y = ldtkEntity.pxY;
        sprite.visible = !fieldHidden;

        sprite.quad.roundTranslation = 1;

        if (fieldAnimationTiles == null) {
            trace("animation tiles is null");
            return;
        }

        // Set sprite sheet from animation fields;
        setSpriteSheet();
    }

    function setSpriteSheet() {
        if (fieldAnimationTiles == null || fieldAnimationTiles.length == 0) {
            return;
        }

        var sheet = new SpriteSheet();
        trace(fieldAnimationTiles[0]);
        sheet.texture = fieldAnimationTiles[0].ceramicTile.texture;
        var atlas = sheet.atlas;

        var name = "main";
        var frameDuration = 1.0 / this.fieldAnimationRate;

        var frames = [];
        for (i in (0...this.fieldAnimationTiles.length)) {
            var tile = this.fieldAnimationTiles[i];
            var width = tile.w;
            var height = tile.h;

            var frame = new SpriteSheetFrame(atlas, name + '#' + i, 0);
            frame.duration = frameDuration;
            var region = frame.region;
            region.width = width;
            region.height = height;
            region.originalWidth = width;
            region.originalHeight = height;
            region.packedWidth = width;
            region.packedHeight = height;
            region.frame(
                tile.x,
                tile.y,
                width,
                height
            );

            frames.push(frame);
        }

        var animation = new SpriteSheetAnimation();
        animation.name = name;
        animation.frames = frames;

        sheet.addAnimation(animation);

        sprite.sheet = sheet;
        sprite.animation = name;
        sprite.anchor(ldtkEntity.def.pivotX, ldtkEntity.def.pivotY);
    }
}

function setOrDefault(val:Any, def:Any): Any {
    return cast (val != null ? val : def);
}