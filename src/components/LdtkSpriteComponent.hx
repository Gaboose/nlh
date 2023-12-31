package components;

import entities.Character.ANIMATION_IDLE;
import ceramic.Assets;
import ceramic.Entity;
import ceramic.Component;
import ceramic.Sprite;
import ceramic.SpriteSheet;
import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Texture;

import haxe.Exception;

// Reads ldtk entity fields "sprite" and "animations",
// loads the specified sprite sheet and sets up animation states.
class LdtkSpriteComponent extends Entity implements Component {
    @entity var sprite:Sprite;

    var assets:Assets;

    var ldtkEntity:LdtkEntityInstance;

    var fieldSprite:String;

    var fieldAnimations:Array<{name:String, numCells:Int, frameDuration:Float}>;

    var texture:Texture;

    var defaultFrameDuration = 0.2;

    public function new(assets:Assets, ldtkDir:String, ldtkEntity:LdtkEntityInstance) {
        super();

        this.assets = assets;
        this.ldtkEntity = ldtkEntity;

        try {
            // fieldInstance.def is not populated, me thinks because
            // of a bug in ceramic. So we guess which field is which
            // for now. Close your eyes and cross your fingers 🤞.
            for (fieldInstance in ldtkEntity.fieldInstances) {
                // Find the sprite field.
                if (fieldInstance.value is String && fieldSprite == null) {
                    fieldSprite = ldtkDir + "/" + fieldInstance.value;
                }
    
                // Find the animations field.
                if (fieldInstance.value is Array && fieldAnimations == null) {
                    var arr:Array<String> = cast fieldInstance.value;
                    fieldAnimations = [];
                    for (row in arr) {
                        var parts = cast(row, String).split(" ");
                        var ss = {
                            name: parts[0],
                            numCells: Std.parseInt(parts[1]),
                            frameDuration: defaultFrameDuration
                        };
                        if (parts.length >= 3) {
                            ss.frameDuration = Std.parseFloat(parts[2]);
                        }

                        fieldAnimations.push(ss);
                    }
                }
            }
        } catch(e:Exception) {
            log.error(e);
            trace(e.stack);
        }

        // Set texture field.
        if (fieldSprite != null) {
            assets.addImage(fieldSprite);
            assets.onceComplete(this, function(success:Bool): Void {
                if (!success) {
                    log.error("could not load asset from entity field " + fieldSprite);
                    return;
                }

                texture = assets.texture(fieldSprite);
                trySetupSpriteSheet();
            });
        } else {
            texture = ldtkEntity.def.tileset.ceramicTileset.texture;
        }
    }

    function bindAsComponent() {
        sprite.x = ldtkEntity.pxX;
        sprite.y = ldtkEntity.pxY;

        sprite.quad.roundTranslation = 1;

        trySetupSpriteSheet();
    }

    // Resolves the race between asset loader and the
    // bindAsComponent function.
    function trySetupSpriteSheet() {
        if (texture == null) {
            // Texture is not loaded yet.
            return;
        }

        if (sprite == null) {
            // Sprite is not bound yet.
            return;
        }

        setupSpriteSheet();
    }

    function setupSpriteSheet():Void {
        var sheet = new SpriteSheet();
        sheet.texture = texture;
        
        sheet.grid(ldtkEntity.def.width, ldtkEntity.def.height);

        var cellsByRow = Math.round(sheet.texture.width / sheet.gridWidth);
        var firstAnimationName = ANIMATION_IDLE;

        if (fieldAnimations != null && fieldAnimations.length > 0) {
            firstAnimationName = fieldAnimations[0].name;

            // Set animations from fieldAnimations;
            for (i in 0...fieldAnimations.length) {
                var state = fieldAnimations[i];
                var cells = [for (j in 0...state.numCells) i*cellsByRow + j];
                sheet.addGridAnimation(state.name, cells, state.frameDuration);
            }
        } else {
            // Default, if animations is not set
            sheet.addGridAnimation(firstAnimationName, [for (j in 0...cellsByRow) j], defaultFrameDuration);
        }

        sprite.sheet = sheet;
        sprite.animation = firstAnimationName;
        sprite.anchor(ldtkEntity.def.pivotX, ldtkEntity.def.pivotY);
    }
}