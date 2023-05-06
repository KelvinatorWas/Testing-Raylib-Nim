import system
type
  Rect* {.bycopy.} = object
    x*, y*: float
    width*, height*: float

    left, right, top, bottom: float


proc right*(r: Rect): float = return r.x + r.width
proc left*(r: Rect): float = return r.x
proc bottom*(r: Rect): float = return r.y + r.height
proc top*(r: Rect): float = return r.y

proc rect_collision*(rect1, rect2: Rect): bool =
  if rect1.x + rect1.width > rect2.x and rect1.x < rect2.x + rect2.width and
     rect1.y + rect1.height > rect2.y and rect1.y < rect2.y + rect2.height:
    result = true
  else:
    result = false

proc collision_with_rects*(obj_rect:Rect, rect_list:seq[Rect]): seq[Rect] =
  var hits: seq[Rect] = @[]
  for tile in rect_list:
    if rect_collision(obj_rect, tile):
      hits.add(tile)
  
  return hits 
  