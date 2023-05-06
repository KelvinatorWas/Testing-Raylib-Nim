import  classes, nimraylib_now
import config,tables,json,functions


class Window:
    var
        title:cstring
        size:IVector2
        virtual_size: IVector2
        frame_rate:int
        ratio: FVector2
        config:JsonNode
        old_time: float
        new_time: float
        dt: float
    

    method init() =
        this.config = configs["WINDOW"]["Window"]
        this.size = ivector2FromJSON(this.config["size"])
        this.frame_rate = jInt(this.config["fps"])
        this.title = this.config["title"].jStrToCstr()
        this.virtual_size = this.config["virtual_size"].ivector2FromJSON()

        # delta_time
        this.dt = 0.0
        this.new_time = 0f
        this.old_time = 0f

        # Setup Ratio
        this.ratio = FVector2(x: this.size.x / this.virtual_size.x, y: this.size.y / this.virtual_size.y)

        initWindow(this.size.x, this.size.y, this.title)

        if this.config["fullscreen"].getBool:
            toggleFullscreen()
        setTargetFPS(this.frame_rate)

    
    method update() =

        #var now:float = cpuTime()
        this.dt = getFrameTime() #(now - this.old_time)
        #this.old_time = now