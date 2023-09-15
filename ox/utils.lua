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
	if type(path) ~= "string" then
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

function write_empty_lua_set(path, obj_name, value)
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

function write_into_lua_obj(path, obj_name, value)
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

		io.write(string.format("%s%q%s%q%s", "\t[", k, "] = ", v, ",\n"))
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

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end
