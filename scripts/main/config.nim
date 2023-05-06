import json
import os,system,sequtils,strutils

import tables

# Paths

var dir = parentDir(parentDir(parentDir(currentSourcePath()))) # Main directory

var data = dir / "data"

var cg = data / "config"

var LOADED = initTable[string, JsonNode]()

proc read_file(f_dir: string, f_name: string) =
    if f_name.endsWith(".json"):
        var f = open(f_dir / f_name)
        var file_name:string = f_name
        var name = file_name.replace(".json", "").toUpper()
        if name in LOADED:
            return
        LOADED[name] = json.parseJson(f.readAll())

proc read_dirs(dirs: seq[string]) =  # Read all files in the given directories
    for i in dirs:
        for (kind,path) in toSeq(walkDir(i, relative = true)):
            #echo path
            read_file(i, path)

# Read directories and files
read_dirs(@[data, cg])

var configs = LOADED
export configs



#echo configs["WINDOW"]["Window"]