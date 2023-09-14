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

print("\n\nCOLORS VALIDATED PASSED \n\n")

local vscode_edits = read_json(out_file_path("vscode_colors.json"))
local eva_tokens = tokens_parsed["tokens"]
local final_theme = {
	["$schema"] = "vscode://schemas/color-theme",
	name = "Alice Oxocarbon Port BOLD",
	type = "dark",
	semanticHighlighting = false,
	colors = {},
	tokenColors = {},
}

for eva_color, tokens in pairs(eva_tokens) do
	local ox_color_key = eva[eva_color]
	local ox_color = ox[ox_color_key]

	-- color not present in editor -> skip
	if vscode_edits[eva_color] == nil then
		goto skipeditor
	end

	for _, editor_key in pairs(vscode_edits[eva_color]) do
		print(editor_key, " -> ", ox_color)
		final_theme["colors"][editor_key] = ox_color
	end

	::skipeditor::
	-- Semantic Tokens
	for _, eva_token in pairs(tokens) do
		local new_token = {
			name = eva_token["name"],
			scope = eva_token["scope"],
			settings = {
				fontStyle = eva_token["fontStyle"],
				foreground = ox_color,
			},
		}
		table.insert(final_theme["tokenColors"], new_token)
	end
end

write_json(out_file_path("alice-carbon-final.json"), final_theme)
