package;

import systems.CollisionSystem;
import systems.CameraSystem;
import ceramic.Sprite;
import components.PlayerControlComponent;
import ceramic.Visual;
import ceramic.Scene;
import ceramic.Tilemap;
import ceramic.LdtkData.LdtkEntityInstance;
import components.LdtkSpriteComponent;
import components.CollidableComponent;
import entities.Character;

using ceramic.TilemapPlugin;

class LdtkScene extends Scene {

    public var level:ceramic.LdtkData.LdtkLevel;

    var ldtkPath:String;
    var ldtkDir:String;

    public function new(ldtkPath:String):Void {
        super();
        this.ldtkPath = ldtkPath;
        ldtkDir = ldtkPath.substr(0, ldtkPath.lastIndexOf("/"));
    }

    override function preload() {
        assets.addTilemap(ldtkPath);
    }

    override function create() {
        var ldtkData = assets.ldtk(ldtkPath);
        level = ldtkData.worlds[0].levels[0];

        level.ensureLoaded(() -> {
            // ensureLoaded() wrapping is only needed when using external levels,
            // but can still be used on any LDtk project too

            // Create and display tilemap
            var tilemap = new Tilemap();
            tilemap.depth = 1;
            tilemap.tilemapData = level.ceramicTilemap;
            add(tilemap);

            // Also create visuals for applicable entities
            level.createVisualsForEntities(tilemap, null, function (entity:LdtkEntityInstance): Visual {
                if (entity.def.identifier == "Player") {
                    var p = new Character();
                    p.component("ldtkSprite", new LdtkSpriteComponent(assets, ldtkDir, entity));
                    p.component("playerControl", new PlayerControlComponent());
                    p.component("collidable", new CollidableComponent(10, 4));

                    // Move camera to the player.
                    CameraSystem.shared.cameraComponent.setPlayer(p);

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

            var collision = level.layerInstance("Collision");

            CollisionSystem.shared = new CollisionSystem(
                collision.cWid,
                collision.cHei,
                collision.def.gridSize
            );

            CollisionSystem.shared.setIntGrid(collision.intGrid);
        });
    }
}