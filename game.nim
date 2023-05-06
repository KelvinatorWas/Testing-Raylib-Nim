import nimraylib_now
import classes,strformat
import /scripts/main/window, /scripts/main/input, /scripts/world/world


class Findow:
        var title: cstring
        var width: int
        var height: int
        var window: Window
        var input: Input
        var world: World
        


        method init(width:int, height:int, title: cstring) =
                this.title = title
                this.width = width
                this.height = height
                this.window = Window.init()
                this.input = Input.init()
                this.world = World.init(this.window)
                       
        method render() =
                this.world.render()
                beginDrawing()
                clearBackground(Red)
                
                beginMode2D(this.world.camera.screen_camera)
                drawTexturePro(this.world.camera.target_screen.texture, this.world.camera.sourceRect, this.world.camera.destRect, Vector2(x:0.0, y:0.0), 0.0, White)
                endMode2D()

     
                drawFPS(10,30)
                #drawText(fmt("dt: {(int)(1.0f/this.window.dt)}").cstring, 10, 30, 18, Raywhite)
                drawText(fmt("CamPos: {this.world.camera.position}").cstring, 10, 60, 18, Raywhite)
                drawText(fmt("Gravity: {this.world.player.gravity}").cstring, 10, 90, 18, Raywhite)
                endDrawing()
        
        method update() =
                while not windowShouldClose():
                        this.input.update()
                        this.world.update(this.window.dt)
                        this.render()
                        this.window.update()
                this.shut_down()

        method shut_down() =
                unloadRenderTexture(this.world.camera.target_screen)
                unloadTexture(this.world.player.player_texture)
                unloadTexture(this.world.tile_texture)
                closeWindow()
                echo("FILE FINISHED")

                
                

let game = Findow.init(800, 600, "Test")

game.update()
