local json = require("json")
local utils = require("utils")

local ox_base_colors = read_json(out_file_path("colors.json"))
print(ox_base_colors)

write_into_lua_obj(out_file_path("ox_base_colors.lua"), "ox_base_colors", ox_base_colors)
