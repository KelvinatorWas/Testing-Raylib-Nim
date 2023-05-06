from nimraylib_now import Vector2

type
    TileObject* {.bycopy.} = object
        tile_type*: string
        position*: Vector2
        texture_position*: Vector2
    Tile* = ref TileObject
