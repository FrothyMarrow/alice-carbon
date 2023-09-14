local json = require("json")
local utils = require("utils")

local function write_lua_obj(path, obj_name, value)
  if type(path) ~= "string" then
    error("Invalid path")
  end

  local test = io.open(path, "r")

  if test ~= nil then
    error(obj_name .. "set already written")
  end

  -- Get's current output file
  local reset = io.output()

  io.output(path)
  io.write(string.format("%s%s%s", "local ", obj_name, " = {\n"))

  for k, v in pairs(value) do
    if v == nil then
      print("invalid value " .. k .. "|" .. v)
    end

    io.write(string.format("%s%q%s", "\t[", v, "] = nil ,\n"))
  end
  io.write("}\n\n\n")
  io.write("return " .. obj_name)
  io.flush()

  -- prettify
  os.execute("stylua " .. path)

  --Resets output to output before function call
  if reset ~= nil then
    io.output(reset)
  end
end

local semantic_token_colors = read_json(out_file_path("semantic_tokens_colors.json"))
print(semantic_token_colors)

write_lua_obj(out_file_path("./color_set.lua"), "eva_tokens_set", semantic_token_colors)
