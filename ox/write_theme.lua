local utils = require("utils")
local eva = require("out/color_set")

-- validation

local eva_color_set_len = 0
for k, v in pairs(eva) do
	if v ~= nil and type(v) ~= "boolean" then
		error("invalid value in eva set key:" .. k .. " value: ", v)
	end

	print("eva :" .. k .. " : ", v)

	eva_color_set_len = eva_color_set_len + 1
end
--

local tokens_parsed = read_json(out_file_path("tokens_parsed.json"))

print("eva_colors_set", eva_color_set_len)
print("parsed_tokens colors:", tokens_parsed["info"]["colors"])

if eva_colors_set ~= tokens_parsed["info"]["colors"] then
	error("invalid eva_set size , should be " .. tokens_parsed["info"]["colors"])
end
