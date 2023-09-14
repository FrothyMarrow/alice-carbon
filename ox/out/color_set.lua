local eva_tokens_set = {
	["#56b7c3"] = "base09", -- ++ operator -- b09
	["#79859d"] = "base08", -- css.comma --b08
	["#838fa7cc"] = "base08", -- curly.css - b08
	["#40ad41"] = "base13", -- b08 - git.diff -> b13 (fix ? )
	["#8e99b1"] = "base08", -- typescript : type --b08
	["#6495ee"] = "base12", -- ts(try,catch -- b15 -> b12 >:C
	["#f14c4c"] = "base10", -- diff removed -- b10
	["#e51400"] = "base10", -- errors - b10
	["#ff8a4c"] = "base07", -- warning - b14
	--switched into 07 to be cleaner
	["#4480f4"] = "base11", -- log.info (???) - b09
	-- i think 11 goes harded
	["#b0b7c3"] = "base04", -- css.color -- b14 -- variable.other -> try 04
	-- split variable.other from variable.other.object
	-- and variable.other.readwrite
	-- this really needs to be separated
	["#8792aa"] = "base15", -- html bracket </> -- b15
	["#ff6ab3"] = "base08", -- typeof - b08
	["#e4bf7f"] = "base04", -- params - b04
	["#e06c75"] = "base10", -- namepsace - b08 -> b10
	["#98c379"] = "base14", -- string - b14
	["#a78cfa"] = "base11", -- "new" keyword -- b08 -> b11 >:(
	["#838fa7"] = "base08", -- ponctuation.acessor - b08
	["#ff9070"] = "base14", -- css.% -- b14
	["#cf68e1"] = "base11", -- instanceof - b08
	-- probably should be b11 rn ( constant.values and such )
	-- split the typeof part  ?
	["#c57bdb"] = "base14", -- css[inline,block,flex] - b14
	["#676e95"] = "base03", -- comment - b03
	["#8a97c3"] = "base10", -- css prop  - b10
	["#f02b77"] = "base04", -- ts this - b04 :C
	-- tried b10
	-- cant be close to cf6 b0b7
}

return eva_tokens_set
