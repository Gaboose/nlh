package triggerables;

import systems.MessageSystem;
import components.AnimatedComponent;
import ceramic.Sprite;
import ceramic.NineSlice;
import ceramic.Visual;
import systems.EntityRegistrySystem;
import ceramic.Color;
import ceramic.Text;
import ceramic.LdtkData.LdtkEntityInstance;

class DialogTriggerable extends Triggerable {
    public static var identifier(default, never) = "Dialog";

    var ldtkEntity: LdtkEntityInstance;

    var fieldText: Any;
    var fieldAnimationTiles: Any;
    var fieldAnimationPivotX: Float;
    var fieldAnimationPivotY: Float;
    var fieldNext: LdtkEntityInstance;

    public function new(entity:LdtkEntityInstance) {
        super();

        this.ldtkEntity = entity;

        // EntityRegistrySystem.shared.emitSet(entity.iid, this);
        MessageSystem.triggers.topic(entity.iid).onBroadcast(this, trigger);

        var fields = new Map<String, Any>();
        for (fieldInstance in entity.fieldInstances) {
            fields.set(fieldInstance.def.identifier, fieldInstance.value);
        }

        this.fieldText = cast fields["Text"];
        this.fieldAnimationTiles = cast fields["AnimationTiles"];
        this.fieldAnimationPivotX = cast fields["AnimationPivotX"];
        this.fieldAnimationPivotY = cast fields["AnimationPivotY"];
        this.fieldNext = cast fields["Next"];

        trace("pivots", this.fieldAnimationPivotX, this.fieldAnimationPivotY);

        // this.visual = createVisual();
        // this.visual.visible = false;

        // createVisual();
        // var visual = createVisual();
        // this.visual = visual;
        // visual.x = 100;
        // visual.y = 100;
        // app.scenes.main.add(visual);
    }

    function createVisual(): ceramic.Visual {
        // var visual = new LdtkVisual(this.ldtkEntity);
        var visual = nineSliceFromLdtkEntity(this.ldtkEntity);
        var scale = 4;
        visual.scale(scale);
        
        visual.anchor(0.5, 1.0);

        var portrait = new Sprite();
        portrait.component("animated", new AnimatedComponent(this.ldtkEntity));
        portrait.depth = 1;
        portrait.x = portrait.width * (.5 - this.fieldAnimationPivotX);
        var portraitLayoutWidth = portrait.width;

        visual.add(portrait);

        var text = new Text();
        var padding = 4;
        var doublePadding = padding*2;
        var minNineSliceHeight = (visual.sliceTop + visual.sliceBottom);

        text.color = new Color(0x4B250A);
        text.content = fieldText;
        text.pointSize = 6;
        text.x = portraitLayoutWidth;
        text.y = padding;
        text.depth = 2;
        text.font = app.assets.font(Fonts.PIXELIFY_SANS);

        visual.add(text);

        trace("size", this.ldtkEntity.width, this.ldtkEntity.height);

        // var ldtkEntityWidthScaled = this.ldtkEntity.width * scale;

        var _resize = function() {
            visual.width = Math.min(screen.width/scale, this.ldtkEntity.width);
            var slack = screen.width - visual.width*scale;
            visual.pos(screen.width * 0.5, screen.height - Math.min(40, slack/2));

            text.fitWidth = visual.width - text.x - padding;

            visual.height = Math.max(minNineSliceHeight, text.height + doublePadding);

            // trace("set visual height", Math.max(minNineSliceHeight, text.height + doublePadding));
            // trace("height", text.height, visual.height);

            portrait.y = visual.height*.5 - portrait.height * this.fieldAnimationPivotY;
        };

        app.screen.onResize(visual, _resize);
        _resize();

        app.screen.oncePointerUp(this, function(info: ceramic.TouchInfo) {
            visual.destroy();
            if (this.fieldNext == null) {
                return;
            }

            MessageSystem.triggers.topic(this.fieldNext.iid).emitBroadcast();

            // var entity = EntityRegistrySystem.shared.get(this.fieldNext.iid);
            // if (entity == null) {
            //     return;
            // }

            // var trigger: Triggerable;
            // try {
            //     trigger = cast(entity, Triggerable);
            // } catch (e:Any) {
            //     return;
            // }

            // trigger.trigger();

            trace("next", this.fieldNext);
        });

        return visual;
    }

    public function trigger() {
        createVisual();
        // this.visual.visible = true;
    }

}

function nineSliceFromLdtkEntity(ldtkEntity: LdtkEntityInstance): NineSlice {
    var def = ldtkEntity.def;
    var nineSlice = new NineSlice();
    nineSlice.rendering(REPEAT);
    nineSlice.tile = def.tileRect.ceramicTile;
    nineSlice.slice(
        def.nineSliceBorders[0],
        def.nineSliceBorders[1],
        def.nineSliceBorders[2],
        def.nineSliceBorders[3]
    );
    return nineSlice;
}