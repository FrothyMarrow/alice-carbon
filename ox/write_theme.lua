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
		error("eva set pointing into invalid value" .. eva_color .. " pointing to : " .. ox_key)
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
print("\n\nCOLOR VALIDATION PASSED \n\n")

-- END OF VALIDATION

local vscode_edits = read_json(out_file_path("eva_vscode_colors.json"))
local eva_tokens = tokens_parsed["tokens"]
local final_theme = {
	["$schema"] = "vscode://schemas/color-theme",
	name = "Alice Oxocarbon Port Bold",
	type = "dark",
	semanticHighlighting = false,
	colors = {},
	tokenColors = {},
}

--overrides
local overrides = require("manual")
for override_key, override_color in pairs(overrides) do
	print("Override : ", override_key)
	final_theme["colors"][override_key] = override_color
end

local final_theme_nobold = deepcopy(final_theme)
final_theme_nobold["name"] = "Alice Oxocarbon Port"

for eva_color, tokens in pairs(eva_tokens) do
	local ox_color_key = eva[eva_color]
	local ox_color = ox[ox_color_key]

	-- check if it is a editor color
	if vscode_edits[eva_color] ~= nil then
		for _, editor_key in pairs(vscode_edits[eva_color]) do
			print(editor_key, " -> ", ox_color)
			-- check for editor.key override
			if final_theme["colors"][editor_key] == nil then
				final_theme["colors"][editor_key] = ox_color
				-- TODO:Make this cleaner ?
				final_theme_nobold["colors"][editor_key] = ox_color
			else
				print("editor key : ", editor_key, " has manual override")
			end
		end

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

			local nobold_token = deepcopy(new_token)
			nobold_token["settings"]["fontStyle"] = ""
			table.insert(final_theme_nobold["tokenColors"], nobold_token)
		end
	end
end

write_json("../themes/alice-carbon-bold.json", final_theme)
write_json("../themes/alice-carbon.json", final_theme_nobold)
