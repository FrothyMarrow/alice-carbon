local json = require("json")

function read_json(path)
    local f = io.open(path, "r")

    if type(f) == "nil" then
        error("Couldn't load file" .. path)
    end


    local reset = io.input()

    io.input(f)
    local out = json.decode(io.read("*all"))

    if reset ~= nil then
        io.output(reset)
    end


    return out
end

function write_json(path, value)
    if (type(path) ~= "string") then
        error("Invalid path")
    end

    local reset = io.output()

    io.output(path)
    io.write(json.encode(value))
    io.flush()

    -- prettify json
    os.execute("prettier " .. path .. " -w")

    if reset ~= nil then
        io.output(reset)
    end
end

local out_dir_global_dir = "./out/"
function out_file_path(file_name)
    return out_dir_global_dir .. file_name
end
