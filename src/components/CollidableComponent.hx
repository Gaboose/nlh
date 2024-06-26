package components;

import ceramic.Rect;
import ceramic.Entity;
import ceramic.Component;
import ceramic.Sprite;
import systems.CollisionSystem;

class CollidableComponent extends Entity implements Component {
    @entity var sprite:Sprite;

    var width:Int;
    var height:Int;

    var x:Float;
    var y:Float;

    public function new(width:Int, height:Int) {
        super();
        this.width = width;
        this.height = height;
    }

    function bindAsComponent() {
        this.x = sprite.x;
        this.y = sprite.y;
    }

    inline public function control(dx:Float, dy:Float) {
        var hitbox = new Rect(
            this.x-width/2,
            this.y-height/2,
            width,
            height
        );

        var newX = sprite.x + dx;
        var newY = sprite.y + dy;

        // Check the x axis.
        if (!CollisionSystem.shared.collidesRectangle(new Rect(
            newX-width/2,
            this.y-height/2,
            width,
            height
        ))) {
            this.x = newX;
            sprite.x = Math.round(newX);
            // sprite.x = newX;
        }
        // else if (dx < 0) {
        //     sprite.x -= hitbox.x % CollisionSystem.shared.tileGridSize - 1;
        // } else if (dx > 0) {
        //     var residual = (hitbox.x+hitbox.width) % CollisionSystem.shared.tileGridSize;
        //     if (residual != 0) {
        //         sprite.x += CollisionSystem.shared.tileGridSize - residual - 1;
        //     }
        // };

        // Check the y axis
        if (!CollisionSystem.shared.collidesRectangle(new Rect(
            this.x-width/2,
            newY-height/2,
            width,
            height
        ))) {
            this.y = newY;
            sprite.y = Math.round(newY);
            // sprite.y = newY;
        }
        // else if (dy < 0) {
        //     sprite.y -= hitbox.y % CollisionSystem.shared.tileGridSize - 1;
        // } else if (dy > 0) {
        //     var residual = (hitbox.y+hitbox.height) % CollisionSystem.shared.tileGridSize;
        //     if (residual != 0) {
        //         sprite.y += CollisionSystem.shared.tileGridSize - residual - 1;
        //     }
        // };
    }
}