import /config,json, tables, classes
from nimraylib_now import isKeyDown, isKeyUp, isMouseButtonUp, isMouseButtonDown


class Input:
    var
        input:JsonNode
    
    method init() =
        this.input = configs["INPUT"]["Beta_Input"]
        this.restart()
    
    method restart() =
        for key, value in this.input["input"].pairs:
            if this.input["input"][key]["type_action"].getStr() == "pressed":
                this.input["input"][key]["in_action"].bval = false
        
        for button, value in this.input["mouse_input"].pairs:
            if this.input["mouse_input"][button]["type_action"].getStr() == "pressed":
                this.input["mouse_input"][button]["in_action"].bval = false

    method update() = 

        this.restart()

        # when key is down and key is up
        for key, value in this.input["input"]:
            if key != "event":
                var pressed_key:cint = this.input["input"][key]["key"].getInt().cint
                if isKeyDown(pressed_key):
                    this.input["input"][key]["in_action"].bval = true
                    this.input["input"][key]["type_action"].str = "hold"
                if isKeyUp(pressed_key):
                    if this.input["input"][key]["in_action"].getBool():
                        this.input["input"][key]["type_action"].str = "pressed"
        
        # when mouse
        for button, value in this.input["mouse_input"]:
            var pressed_button:cint = this.input["mouse_input"][button]["mouse_key"].getInt().cint
            if isMouseButtonDown(pressed_button):
                this.input["mouse_input"][button]["in_action"].bval = true
                this.input["mouse_input"][button]["type_action"].str = "hold"

        for button, value in this.input["mouse_input"]:
            var pressed_button:cint = this.input["mouse_input"][button]["mouse_key"].getInt().cint
            if isMouseButtonUp(pressed_button):
                if this.input["mouse_input"][button]["in_action"].getBool():
                    this.input["mouse_input"][button]["type_action"].str = "pressed"