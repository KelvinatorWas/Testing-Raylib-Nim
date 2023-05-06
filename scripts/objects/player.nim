import classes, nimraylib_now, tables
import ./rect, ./tile, ../main/config
from ./camera import Game_Camera
import json

type
    World = object
        world_map: (seq[Table[string, seq[Tile]]], seq[Rect])
        collison: seq[Rect]
        tile_texture: Texture2D
        camera: Game_Camera



class Player:

    var
        position: Vector2
        rect: Rect
        velocity: Vector2
        world: World
        input: JsonNode
        speed: float
        jump_height: float
        gravity: float
        max_gravity: float
        can_jump: bool
        is_falling: bool
        tile_col: seq[Rect]
        flip: cfloat
        

        player_texture: Texture2D
    
    method init(game_world:seq[Rect]) =

        this.input = configs["INPUT"]["Beta_Input"]
        this.tile_col = game_world
        this.position = Vector2(x:16*100+128, y:16*100)
        this.rect = Rect(x: this.position.x, y: this.position.y, width:9.0, height:15.0)
        this.velocity = Vector2(x:0.0, y:0.0)
        this.speed = 200f
        this.gravity = 5f
        this.max_gravity = 500f
        this.jump_height = 600f
        this.can_jump = true
        this.is_falling = true
        this.flip = this.rect.width
        
        this.player_texture = loadTexture("data/game_data/gfx/player/0.png")
    
    method movement_collision(dt:float): seq[bool] =
        # LEFT RIGHT  TOP     DOWN
        var collision: seq[bool] = @[false, false, false, false]

        # this x move
        this.position.x += this.velocity.x * dt
        this.rect.x = (float)this.position.x.int

        var hits: seq[Rect] = collision_with_rects(this.rect, this.tile_col)

        # in x tile
        for tile in hits:
            if this.velocity.x > 0:
                #echo "heloo"
                this.rect.x = tile.left-this.rect.width
                collision[1] = true # RIGHT
            elif this.velocity.x < 0:
                this.rect.x = tile.right
                #echo "wow"
                collision[0] = true # Left
            this.position.x = this.rect.x
            this.position.y = this.rect.y+1
        
        # this y move

        if this.is_falling:
            this.gravity += 50
        
        if this.gravity >= this.max_gravity:
            this.gravity = this.max_gravity
        if this.is_falling:
            this.velocity.y += (float)this.gravity
        else: this.gravity = 0


        this.position.y += this.velocity.y * dt
        this.rect.y = (float)this.position.y.int


        hits = collision_with_rects(this.rect, this.tile_col)
        # in y tile
        for tile in hits:

            if this.velocity.y < 0:
                this.rect.y = tile.bottom
                collision[2] = true # TOP
            elif this.velocity.y > 0:
                this.rect.y = tile.top-this.rect.height
                this.gravity = 0
                collision[3] = true # BOTTOM

            this.position.y = (float)this.rect.y.int+1

        return collision


    method movement() =
        if this.input["input"]["D"]["type_action"].getStr() == "hold":
            this.velocity.x += this.speed
        
        if this.input["input"]["A"]["type_action"].getStr() == "hold":
            this.velocity.x -= this.speed
        
        if this.input["input"]["jump"]["type_action"].getStr() == "hold":
            if this.can_jump:
                this.gravity = -this.jump_height
                this.can_jump = false
        


    method update(dt:float) =
        this.velocity = Vector2(x:0.0, y:0.0)
        this.movement()
        #echo this.velocity.x
        var collision = this.movement_collision(dt)

        if collision[3]:
            if not this.can_jump:
                this.can_jump = true
                this.is_falling = false
        this.is_falling = true

        if collision[2]:
            this.gravity = 0

        if this.velocity.x < 0:
            this.flip = -this.rect.width
        if this.velocity.x > 0:
            this.flip = this.rect.width
    method render() =
        #drawRectangle(this.rect.x.cint, this.rect.y.cint, this.rect.width.cint, this.rect.height.cint, Red)
        drawTexturePro(this.player_texture, Rectangle(x:0,y: 0, width: this.flip, height: this.rect.height), Rectangle(x:this.position.x,y: this.position.y-1, width: this.rect.width.cfloat, height: this.rect.height), Vector2(x: 0.0, y: 0.0), 0.0, White)

