import classes

#import nimraylib_now
from nimraylib_now import Camera2D, Vector2, RenderTexture2D, loadRenderTexture, Rectangle
from ../main/window import Window
import ../main/config
import json, tables




class Game_Camera:
    var
        camera: Camera2D
        screen_camera: Camera2D
        game_window: Window
        position: Vector2
        input: JsonNode
        speed: cfloat
        target_screen: RenderTexture2D
        sourceRect: Rectangle
        destRect: Rectangle


    method init(gameWindow: Window) =
        this.input = configs["INPUT"]["Beta_Input"]
        # World Camera
        this.game_window = gameWindow
        this.camera = Camera2D()
        this.camera.zoom = 1.0
        this.camera.rotation = 0.0
        # Screen Camera
        this.screen_camera = Camera2D()
        this.screen_camera.zoom = 1.0
        this.screen_camera.rotation = 0.0
        # Target
        this.target_screen = loadRenderTexture(this.game_window.virtual_size.x, this.game_window.virtual_size.y)
        # Rectangle
        this.sourceRect = Rectangle(x:0.0, y:0.0, width: this.target_screen.texture.width.cfloat, height: -this.target_screen.texture.height.cfloat)
        this.destRect = Rectangle(x: -this.game_window.ratio.x.cfloat, y: -this.game_window.ratio.y.cfloat, width: this.game_window.size.x.cfloat + (this.game_window.ratio.x.cfloat * 2), height: this.game_window.size.y.cfloat + (this.game_window.ratio.y.cfloat * 2))

        this.position = Vector2(x:16*100, y:16*100)
        this.speed = 0.2
    
    method target(target_pos: Vector2,dt:float) =

        var target: Vector2 = Vector2(x:(target_pos.x - (this.game_window.virtual_size.x.cfloat/2.0)+4), y: (target_pos.y - (this.game_window.virtual_size.y.cfloat/2.0)+8))

        this.position.x += (target.x-this.position.x) / (this.speed.float / dt)
        this.position.y += (target.y-this.position.y) / (this.speed.float / dt)

    method update() =

        this.screen_camera.target = this.position


        this.camera.target.x = (cfloat)this.screen_camera.target.x
        this.screen_camera.target.x -= this.camera.target.x
        this.screen_camera.target.x *= this.game_window.ratio.x

        this.camera.target.y = (cfloat)this.screen_camera.target.y
        this.screen_camera.target.y -= this.camera.target.y
        this.screen_camera.target.y *= this.game_window.ratio.y


    method movement() =
        if this.input["input"]["D"]["type_action"].getStr() == "hold":
            this.position.x += this.speed
        
        if this.input["input"]["A"]["type_action"].getStr() == "hold":
            this.position.x -= this.speed
        
        if this.input["input"]["W"]["type_action"].getStr() == "hold":
            this.position.y -= this.speed
        
        if this.input["input"]["S"]["type_action"].getStr() == "hold":
            this.position.y += this.speed


