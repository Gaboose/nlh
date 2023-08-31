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

// Reads ldtk entity fields "sprite" and "sprite_states",
// loads the specified sprite sheet and sets up animation states.
class LdtkSpriteComponent extends Entity implements Component {
    @entity var sprite:Sprite;

    var assets:Assets;

    var ldtkEntity:LdtkEntityInstance;

    var fieldSprite:String;

    var fieldSpriteStates:Array<{name:String, numCells:Int}>;

    var texture:Texture;

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
    
                // Find the sprite_states field.
                if (fieldInstance.value is Array && fieldSpriteStates == null) {
                    var arr:Array<String> = cast fieldInstance.value;
                    fieldSpriteStates = [];
                    for (row in arr) {
                        var parts = cast(row, String).split(" ");
                        fieldSpriteStates.push({name: parts[0], numCells: Std.parseInt(parts[1])});
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

        if (fieldSpriteStates != null && fieldSpriteStates.length > 0) {
            // Set animations from fieldSpriteStates;
            for (i in 0...fieldSpriteStates.length) {
                var state = fieldSpriteStates[i];
                var cells = [for (j in 0...state.numCells) i*cellsByRow + j];
                sheet.addGridAnimation(state.name, cells, 0.2);
            }
        } else {
            // Default, if animations is not set
            sheet.addGridAnimation(ANIMATION_IDLE, [for (j in 0...cellsByRow) j], 0.2);
        }

        sprite.sheet = sheet;
        sprite.animation = ANIMATION_IDLE;
        sprite.anchor(ldtkEntity.def.pivotX, ldtkEntity.def.pivotY);
    }
}