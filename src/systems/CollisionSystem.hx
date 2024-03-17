package systems;

import ceramic.LdtkData.LdtkLayerInstance;
import ceramic.Rect;
import ceramic.Entity;

class CollisionSystem {
    public static var shared:CollisionSystem = new CollisionSystem();

    var layers: Array<CollisionLayer> = [];

    public function new() {}

    // public function new(
        // cWid:Int,
        // cHei:Int,
        // tileGridSize:Int
    // ):Void {
        // this.cWid = cWid;
        // this.cHei = cHei;
        // this.tileGridSize = tileGridSize;
    // }

    public function add(layerInstance: LdtkLayerInstance) {
        layers.push(new CollisionLayer(layerInstance));
    }

    public function collidesRectangle(rect: Rect): Bool {
        for (layer in layers) {
            if (layer.collidesRectangle(rect))
                return true;
        }

        return false;
    }

    // public function setIntGrid(intGrid:Array<Int>):Void {
    //     this.intGrid = intGrid;
    // }
}

class CollisionLayer extends Entity {
    var cWid: Int;
    var gridSize: Int;
    var intGrid: Array<Int>;
    var entityRects: Map<String, {rect: ceramic.Rect, enabled: Bool}> = [];

    public function new(layerInstance: LdtkLayerInstance) {
        super();

        this.cWid = layerInstance.cWid;
        this.gridSize = layerInstance.def.gridSize;
        this.intGrid = layerInstance.intGrid;

        for (entityInstance in layerInstance.entityInstances) {
            var obj = {rect: new ceramic.Rect(
                entityInstance.pxX, entityInstance.pxY,
                entityInstance.width, entityInstance.height,
            ), enabled: true};

            entityRects.set(entityInstance.iid, obj);

            trace("my entityRects", entityRects);

            MessageSystem.enabled.topic(entityInstance.iid).onValueChange(this, function(current: Bool, previous: Bool) {
                obj.enabled = current;
            });
        }
    }

    public function collidesRectangle(rect:ceramic.Rect):Bool {
        return collidesCellRectangle(rect) || collidesEntityRectangle(rect);
    }

    private inline function cellExists(cx:Int, cy:Int):Bool {
        var int = intGrid[cx + cy*cWid];
        return int != 0 && int != null;
    }

    private function collidesCellRectangle(rect: ceramic.Rect): Bool {
        if (intGrid == null) {
            return false;
        }

        for (cx in Std.int(rect.x/gridSize)...Std.int((rect.x+rect.width)/gridSize)+1) {
            for (cy in Std.int(rect.y/gridSize)...Std.int((rect.y+rect.height)/gridSize)+1) {
                if (cellExists(cx, cy)) {
                    return true;
                }
            }
        }

        return false;
    }

    private function collidesEntityRectangle(rect: ceramic.Rect): Bool {
        for (entityRect in entityRects) {
            if (entityRect.enabled && Utils.intersects(entityRect.rect, rect))
                return true;
        }

        return false;
    }
}