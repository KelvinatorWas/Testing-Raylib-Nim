import classes
import tables
from ../objects/tile import Tile
import ../objects/rect
import /tile_loader
import ../main/window
import nimraylib_now
import ../objects/camera
import ../objects/player


proc in_the_view(object_pos:Vector2, surface: Rectangle, camera_pos:Vector2): bool =
    if object_pos.x + surface.width >= camera_pos.x + surface.width-16 and object_pos.x <= camera_pos.x+surface.width and object_pos.y + surface.height >= camera_pos.y + surface.height-16 and object_pos.y - surface.height <= camera_pos.y - surface.height+180:
        result = true
    else:
        result = false


class World:
    var
        world_map: (seq[Table[string, seq[Tile]]], seq[Rect])
        collison: seq[Rect]
        tile_texture: Texture2D
        game_window:  Window
        camera: Game_Camera
        player*: Player

    method init(game_window: Window) =
        this.game_window = game_window
        this.tile_texture = loadTexture("data/game_data/gfx/tile_map.png")
        this.world_map = load_json_map("data/world/level.json")

        this.camera = Game_Camera.init(game_window)
        this.player = Player.init(this.world_map[1])


    method update(dt:float) = 
        this.camera.update()
        this.camera.target(this.player.position, dt)
        #this.camera.movement()
        this.player.update(dt)


    method render() =
       
        beginTextureMode(this.camera.target_screen)
        clearBackground(Black)
        beginMode2D(this.camera.camera)
        for data, table in this.world_map[0]:
            for layer, tiles in table:
                for tile in tiles:
                    if layer == "0":
                        this.player.render()
                    if in_the_view(tile.position, this.camera.sourceRect, this.camera.camera.target):
                        drawTexturePro(this.tile_texture, Rectangle(x: tile.texture_position.x, y:tile.texture_position.y, width: 16, height:16), Rectangle(x: tile.position.x, y:tile.position.y, width: 16, height:16), Vector2(x:0, y:0), 0.0, Color(r:255, g:255,b: 255,a: 255))
                 
        endMode2D()
        endTextureMode()


