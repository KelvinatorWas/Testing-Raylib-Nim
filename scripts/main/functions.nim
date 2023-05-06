import json, system
type 
    IntVector2* = object
        x*: cint 
        y*: cint
    IVector2* = ref IntVector2

type 
    FloatVector2* = object
        x*: cfloat 
        y*: cfloat
    FVector2* = ref FloatVector2


proc xy*(this: FVector2): (float, float) =
    return (this.x.float, this.y.float)

proc listToIVec2*(list: seq[int]): IVector2 =
    result = new(IVector2)
    result.x = list[0].cint
    result.y = list[1].cint

proc ivector2FromJSON*(node: JsonNode): IVector2 =
  result = new(IVector2)
  result.x = node[0].getInt().cint
  result.y = node[1].getInt().cint

proc jBools*(node:JsonNode): bool =
    result = node.getBool()

proc fvector2FromJSON*(node: JsonNode): FVector2 =
  result = new(FVector2)
  result.x = node[0].getFloat().cfloat
  result.y = node[1].getFloat().cfloat

proc jInt*(node:JsonNode): cint =
    result = node.getInt().cint

proc jStrToCstr*(node: JsonNode): cstring =
    result = node.getStr().cstring

proc jFloat*(node:JsonNode): cfloat =
    result = node.getFloat().cfloat


