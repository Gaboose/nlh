package quadtree;

class QuadTree<T> {
    var cellCapacity:Int;
    var root:Cell<T>;

    function new(?cellCapacity:Int=5) {
        this.cellCapacity = cellCapacity;
        this.root = new Cell(cellCapacity);
    }

    function add(x:Float, y:Float, value:T) {
        root.add(new Item(x, y, value));
    }

    function get(x:Float, y:Float, width:Float, height:Float):Array<T> {
        return root.get(x, y, width, height);
    }
}

class Cell<T> {
    var capacity:Int;

    var items:Array<Item<T>> = [];

    var midX:Float = null;
    var midY:Float = null;
    var children:Array<Cell<T>> = null;

    public function new(capacity:Int) {
        this.capacity = capacity;
    }

    public function add(item: Item<T>):Void {
        if (children != null) {
            addToChildren(item);
        }

        items.push(item);

        if (items.length > capacity) {
            split();
        }
    }

    public function get(x:Float, y:Float, width:Float, height:Float):Array<T> {
        var res:Array<T> = [];

        if (children != null) {
            if (x < midX && y < midY) {
                res = res.concat(children[0].get(x, y, width, height));
            }
            if (x + width >= midX && y < midY) {
                res = res.concat(children[1].get(x, y, width, height));
            }
            if (x < midX && y + height >= midY) {
                res = res.concat(children[2].get(x, y, width, height));
            }
            if (x + width >= midX && y + height >= midY) {
                res = res.concat(children[3].get(x, y, width, height));
            }

            return res;
        }

        for (item in items) {
            if (item.x >= x && item.x < x + width && item.y >= y && item.y < y + height) {
                res.push(item.value);
            }
        }

        return res;
    }

    function addToChildren(item:Item<T>):Void {
        if (item.x < midX) {
            if (item.y < midY) {
                children[0].add(item);
            } else {
                children[2].add(item);
            }
        } else {
            if (item.y < midY) {
                children[1].add(item);
            } else {
                children[3].add(item);
            }
        }
    }

    function split() {
        setMids();

        children = [
            new Cell<T>(capacity),
            new Cell<T>(capacity),
            new Cell<T>(capacity),
            new Cell<T>(capacity)
        ];

        for (item in items) {
            addToChildren(item);
        }

        items = null;
    }

    function setMids() {
        var minX:Float = items[0].x;
        var maxX:Float = items[0].x;
        var minY:Float = items[0].y;
        var maxY:Float = items[0].y;

        for (item in items.slice(1)) {
            if (item.x < minX) { minX = item.x; }
            if (item.x > maxX) { maxX = item.x; }
            if (item.y < minY) { minY = item.y; }
            if (item.y > maxY) { maxY = item.y; }
        }

        midX = (maxX - minX)/2;
        midY = (maxY - minY)/2;
    }
}

class Item<T> {
    public var x:Float;
    public var y:Float;
    public var value:T;

    public function new(x:Float, y:Float, value:T) {
        this.x = x;
        this.y = y;
        this.value = value;
    }
}