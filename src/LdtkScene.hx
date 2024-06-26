package;

import systems.MessageSystem.SpriteSubscriber;
import ceramic.Assets;
import triggerables.Triggerable.newTriggerable;
import triggers.Trigger.newTrigger;
import systems.CollisionSystem;
import systems.camera.CameraSystem;
import ceramic.Sprite;
import components.PlayerControlComponent;
import components.AnimatedComponent;
import ceramic.Visual;
import ceramic.Scene;
import ceramic.Tilemap;
import ceramic.LdtkData.LdtkEntityInstance;
import components.LdtkSpriteComponent;
import components.CollidableComponent;
import components.AbilitiesComponent;
import entities.Character;
import systems.EntityRegistrySystem;
import systems.camera.PixelArtScaler;
import systems.camera.CameraSceneComponent;
import systems.camera.CameraAttractorComponent;

using ceramic.TilemapPlugin;
using StringTools;

class LdtkScene extends Scene {

    public var level:ceramic.LdtkData.LdtkLevel;

    public var pxScale(get, set): Float;

    var ldtkPath:String;
    var ldtkDir:String;

    public function new(ldtkPath:String, assets:Assets):Void {
        super();
        this.ldtkPath = ldtkPath;
        ldtkDir = ldtkPath.substr(0, ldtkPath.lastIndexOf("/"));

        var pixelArtScaler = new PixelArtScaler();
        pixelArtScaler.filter.bindToScreenSize();
        this.component("pixelArtScaler", pixelArtScaler);
    }

    override function preload() {
        assets.parent = app.assets;
        assets.addTilemap(ldtkPath);
    }

    override function create() {
        var ldtkData = assets.ldtk(ldtkPath);
        level = ldtkData.worlds[0].levels[0];

        this.component("cameraScene", new CameraSceneComponent());

        level.ensureLoaded(() -> {
            // ensureLoaded() wrapping is only needed when using external levels,
            // but can still be used on any LDtk project too

            // Create and display tilemap
            var tilemap = new Tilemap();
            tilemap.depth = 1;
            tilemap.tilemapData = level.ceramicTilemap;
            add(tilemap);

            // var entitiesByIdentifier:Map<String, Array<LdtkEntityInstance>> = [];
            // var entitiesByIid:Map<String, Entity> = [];

            // Create visuals for applicable entities and index entities and visuals.
            level.createVisualsForEntities(tilemap, null, function (entity:LdtkEntityInstance): Visual {
                if (entity.def.tags.contains("triggerable")) {
                    var triggerable = newTriggerable(entity);
                    if (triggerable == null) {
                        // Triggerables present in ldtk, but not implemented in the game engine.
                        trace("Unimplemented triggerable", entity);
                        return null;
                    }
                    return triggerable.visual;
                }

                if (entity.def.tags.contains("trigger")) {
                    newTrigger(entity);
                }

                if (entity.def.identifier == "Player") {

                    var p = new Character();
                    p.component("ldtkSprite", new LdtkSpriteComponent(assets, ldtkDir, entity));
                    p.component("playerControl", new PlayerControlComponent());
                    p.component("collidable", new CollidableComponent(10, 4));
                    p.component("abilities", new AbilitiesComponent(entity));

                    // Move camera to the player.
                    p.component("cameraAttractor", new CameraAttractorComponent());

                    return p;
                }

                if (entity.def.identifier == "Animated") {
                    trace("animated entity found");
                    var s = new Sprite();
                    s.component("spriteSubscriber", new SpriteSubscriber(entity.iid));
                    s.component("animated", new AnimatedComponent(entity));
                    s.x = entity.pxX;
                    s.y = entity.pxY;
                    // EntityRegistrySystem.shared.emitSet(entity.iid, s);
                    return s;
                }

                if (entity.def.tags.contains("sprite")) {
                    // var filter = new Filter();
                    // filter.size(250, 260);
                    // s.bindToScreenSize();

                    // var filter = new Filter();
                    var s = new Sprite();
                    // var filter = s;
                    s.component("ldtkSprite", new LdtkSpriteComponent(assets, ldtkDir, entity));
                    s.component("spriteSubscriber", new SpriteSubscriber(entity.iid));
                    // EntityRegistrySystem.shared.emitSet(entity.iid, s);

                    // filter.content.add(s);
                    // add(filter);

                    // var blur = app.assets.shader(Shaders.GAUSSIAN_BLUR).clone();
                    // blur.setVec2('resolution', filter.width, filter.height);
                    // trace("filter size", filter.width, filter.height);
                    // trace("sprite size", s.width, s.height);
                    // blur.setVec2('blurSize', 2, 2);
                    // filter.shader = blur;
                    
                    // return null;
                    return s;
                }

                return null;
            });

            // Assign Show components.
            // for (entity in entitiesByIdentifier["Show"]) {
            //     var comp = new ShowComponent(entity);

            //     for (fieldInstance in entity.fieldInstances) {
            //         if (fieldInstance.def.identifier == "targets") {
            //             var val = cast(fieldInstance.value, Array<Dynamic>);
            //             trace("Ldtk scene", fieldInstance.def.identifier, fieldInstance.value, val);
            //             for (v in val) {
            //                 var ent = cast (v, LdtkEntityInstance);
            //                 entitiesByIid[ent.iid].component("Show", comp);
            //             }
            //         }
            //     }
            // }

            // // Assign OnPub components.
            // for (entity in entitiesByIdentifier["OnPub"]) {
            //     var comp = new OnPubComponent(entity);

            //     for (fieldInstance in entity.fieldInstances) {
            //         if (fieldInstance.def.identifier == "target") {
            //             var ent = cast (fieldInstance.value, LdtkEntityInstance);
            //             entitiesByIid[ent.iid].component("OnPub", comp);
            //         }
            //     }
            // }

            assets.load();

            CollisionSystem.shared = new CollisionSystem();

            for (layerInstance in level.layerInstances) {
                var suffix = Utils.trimPrefix(layerInstance.def.identifier, "Collision");
                if (suffix == null)
                    continue;

                CollisionSystem.shared.add(layerInstance);
            }

            // var collision = level.layerInstance("Collision16x16");

            // CollisionSystem.shared = new CollisionSystem(
            //     collision.cWid,
            //     collision.cHei,
            //     collision.def.gridSize
            // );

            // CollisionSystem.shared.setIntGrid(collision.intGrid);
        });
    }

    public inline function set_pxScale(scale:Float):Float {
        var pixelArtScaler: PixelArtScaler = this.component("pixelArtScaler");
        pixelArtScaler.scale = scale;
        return scale;
    }

    public inline function get_pxScale():Float {
        var pixelArtScaler: PixelArtScaler = this.component("pixelArtScaler");
        return pixelArtScaler.scale;
    }
}