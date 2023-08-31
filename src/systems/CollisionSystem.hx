package systems;

class CollisionSystem {
    public static var shared:CollisionSystem = new CollisionSystem(0, 0, 1);

    var cWid:Int;
    var cHei:Int;
    public var tileGridSize:Int;

    var intGrid:Array<Int>;

    public function new(
        cWid:Int,
        cHei:Int,
        tileGridSize:Int
    ):Void {
        this.cWid = cWid;
        this.cHei = cHei;
        this.tileGridSize = tileGridSize;
    }

    public function setIntGrid(intGrid:Array<Int>):Void {
        this.intGrid = intGrid;
    }

    public inline function collidesCell(cx:Int, cy:Int):Bool {
        if (intGrid == null) {
            return false;
        }
        return intGrid[cx + cy*cWid] != 0;
    }

    public inline function collidesPoint(px:Float, py:Float):Bool {
        return collidesCell(Std.int(px/tileGridSize), Std.int(py/tileGridSize));
    }

    public function collidesRectangle(rect:ceramic.Rect):Bool {
        for (cx in Std.int(rect.x/tileGridSize)...Std.int((rect.x+rect.width)/tileGridSize)+1) {
            for (cy in Std.int(rect.y/tileGridSize)...Std.int((rect.y+rect.height)/tileGridSize)+1) {
                if (collidesCell(cx, cy)) {
                    return true;
                }
            }
        }

        return false;
    }
}