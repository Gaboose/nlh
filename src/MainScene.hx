package;

import ceramic.Sprite;
import components.PlayerControlComponent;
import ceramic.Visual;
import ceramic.Scene;
import ceramic.Tilemap;
import ceramic.LdtkData.LdtkEntityInstance;
import components.LdtkSpriteComponent;
import entities.Player;

using ceramic.TilemapPlugin;

var ldtkDir = "ldtk-project";
var ldtkName = "ldtk-project/ldtk.ldtk";

class MainScene extends Scene {
    // var ldtkName = Tilemaps.LDTK_PROJECT__LDTK;

    override function preload() {
        assets.addTilemap(ldtkName);
    }

    override function create() {
        var tilemap:Tilemap = null;

        var ldtkData = assets.ldtk(ldtkName);
        var level = ldtkData.worlds[0].levels[0];

        level.ensureLoaded(() -> {

            // ensureLoaded() wrapping is only needed when using external levels,
            // but can still be used on any LDtk project too

            // Create and display tilemap
            tilemap = new Tilemap();
            tilemap.depth = 1;
            tilemap.tilemapData = level.ceramicTilemap;
            add(tilemap);

            // Also create visuals for applicable entities
            level.createVisualsForEntities(tilemap, null, function (entity:LdtkEntityInstance): Visual {
                if (entity.def.identifier == "Player") {
                    var p = new Player();
                    p.component("ldtkSprite", new LdtkSpriteComponent(assets, ldtkDir, entity));
                    p.component("playerControl", new PlayerControlComponent());
                    return p;
                }

                if (entity.def.tags.contains("sprite")) {
                    var s = new Sprite();
                    s.component("ldtkSprite", new LdtkSpriteComponent(assets, ldtkDir, entity));
                    return s;
                }

                return new Visual();
            });

            assets.load();
        });

    }

}
