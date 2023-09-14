local json = require("json")
local utils = require("utils")

local semantic_token_colors = read_json(out_file_path("semantic_tokens_colors.json"))
print(semantic_token_colors)

write_empty_lua_set(out_file_path("./color_set.lua"), "eva_tokens_set", semantic_token_colors)
