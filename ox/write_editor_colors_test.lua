require("utils")
local eva = require("out/color_set")
local ox = require("out/ox_base_colors")

-- validation

local eva_color_set_len = 0
for eva_color, ox_key in pairs(eva) do
	if ox_key == nil or type(ox_key) ~= "string" then
		error("invalid value in eva set key:" .. eva_color .. " value: ", ox_key)
	end

	if ox[ox_key] == nil or type(ox[ox_key]) ~= "string" then
		error(
			"eva set pointing into invalid value"
				.. eva_color
				.. " pointing to : "
				.. ox_key
				.. " value: "
				.. ox[ox_key]
		)
	end
	print("eva :" .. eva_color .. " : ", ox_key)

	eva_color_set_len = eva_color_set_len + 1
end
--

local tokens_parsed = read_json(out_file_path("tokens_parsed.json"))

print("eva_colors_set", eva_color_set_len)
print("parsed_tokens colors:", tokens_parsed["info"]["colors"])

if eva_color_set_len ~= tokens_parsed["info"]["colors"] then
	error("invalid eva_set size , should be " .. tokens_parsed["info"]["colors"])
end

-- END OF VALIDATION

-- comparing the eva_colors with the vscode ones
print("\n\n\n\n\n")
local vscode_edits = read_json(out_file_path("vscode_colors.json"))
local matched_colors = 0
local matched_keys = 0

for eva_color, ox_key in pairs(eva) do
	if vscode_edits[eva_color] ~= nil then
		matched_colors = matched_colors + 1
		print(eva_color .. " is present on vscode_colors")

		for k2, v2 in pairs(vscode_edits[eva_color]) do
			matched_keys = matched_keys + 1
		end
	else
		print(eva_color .. " is not present on vscode_colors")
	end
end

print("total matched: ", matched_colors)
print("keys: ", matched_keys)

local total_colors = 0
local total_keys = 0

for k, v in pairs(vscode_edits) do
	total_colors = total_colors + 1

	for k2, v2 in pairs(vscode_edits[k]) do
		total_keys = total_keys + 1
	end
end

print("in total there's ", total_colors, " colors")
print("missing from matching : ", total_colors - matched_colors)
print("keys : ", total_keys)
