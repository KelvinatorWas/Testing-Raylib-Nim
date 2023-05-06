from ../main/functions import FVector2, jFloat,fvector2FromJSON
import json, strutils
import ../objects/rect, ../objects/tile
import tables

from nimraylib_now import Vector2



proc load_json_map*(path: string): (seq[Table[string, seq[Tile]]], seq[Rect]) =
    var world_map = initTable[string, JsonNode]()
    var debug: bool = false
    if path.endsWith(".json"):
            var f = open(path)
            world_map["World"] = json.parseJson(f.readAll())
  
  
    var layers: seq[Table[string, seq[Tile]]] = @[]
    var collision_rects: seq[Rect] = @[]

    for layer_name, layer_data in world_map.pairs():
        for key_name, tiles in layer_data.pairs():
            if key_name != "collision":
                if debug: echo "[ LAYER: ", key_name, " ]"

                var tile_map: seq[Tile] = @[]
                for hash_pos, tile in tiles.pairs():
                    if debug: echo "[ HASH_POS: ", hash_pos, " ] [ TILE: ", tile, " ]"
                    if tile[0].str == "tile":
                        var tile_data = Tile(
                            tile_type: tile[0].str,
                            position: Vector2(x: tile[1][0].jFloat(), y: tile[1][1].jFloat()),
                            texture_position: Vector2(x: tile[2][0].jFloat(), y: tile[2][1].jFloat())
                        )
                        tile_map.add(tile_data)
                
                var layer = initTable[string, seq[Tile]]()
                layer[key_name] = tile_map
                layers.add(layer)
                    
            elif key_name == "collision":
                if debug: echo "[ PASSED TO COLLISION ]"
                for tile in tiles:
                    var tile_rect = Rect(
                        x: tile[0][0].jFloat(),
                        y: tile[0][1].jFloat(),
                        width: tile[1][0].jFloat(),
                        height: tile[1][1].jFloat()
                    )
                    collision_rects.add(tile_rect)

    return (layers, collision_rects)
