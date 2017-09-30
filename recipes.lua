-------------------------------
-- Masonry

-- Doesn't include entries that already belong to group "stone" in default.
local raw_stone = 
{
	["default:sandstone"] = true,
	["default:sandstonebrick"] = true,
	["default:sandstone_block"] = true,
	["default:desert_sandstone"] = true,
	["default:desert_sandstone_brick"] = true,
	["default:desert_sandstone_block"] = true,
	["default:silver_sandstone"] = true,
	["default:silver_sandstone_brick"] = true,
	["default:silver_sandstone_block"] = true,
	["default:obsidian"] = true,
	["default:obsidianbrick"] = true,
	["default:obsidian_block"] = true,
}

-- doesn't include entries already in wood-related groups
local raw_wood = 
{
	["default:cactus"] = true,
	["default:dry_shrub"] = true,
	["default:bush_stem"] = true,
	["default:acacia_bush_stem"] = true,
}

local carpentry_output_whitelist =
{
	["default:chest_locked"] = true,
}

local metal_ingots =
{
	['default:steel_ingot'] = true,
	['default:copper_ingot'] = true,
	['default:bronze_ingot'] = true,
	["default:gold_ingot"] = true,
	['moreores:mithril_ingot'] = true,
	['moreores:tin_ingot'] = true,
	['moreores:silver_ingot'] = true,
	["technic:cast_iron_ingot"] = true,
	["technic:stainless_steel_ingot"] = true,
	["metals:pig_iron_ingot"] = true,
	["metals:wrought_iron_ingot"] = true,
	["metals:steel_ingot"] = true,
}

local function is_group(item_name, group)
	return minetest.get_item_group(item_name, group) > 0 or item_name == "group:"..group
end

local function is_stone(item_name)
	if is_group(item_name, "stone") or raw_stone[item_name] then
		return true
	end
	return false
end

local function is_wood(item_name)
	if is_group(item_name, "wood") or is_group(item_name, "tree") or is_group(item_name, "stick") or is_group(item_name, "sapling") or raw_wood[item_name] then
		return true
	end
	return false
end

local function is_metal_ingot(item_name)
	if is_group(item_name, "metal_ingot") or metal_ingots[item_name] then
		return true
	end
	return false
end

--------------------------------------------------------------------------------------------

-- appropriates recipes with stone inputs
simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "normal" then 
		return
	end

	for item, count in pairs(recipe.input) do
		if is_stone(item) then
			return "masonry", true
		end
	end
end)

-- appropriate recipes with wood inputs but not metal or stone inputs
simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "normal" then 
		return
	end

	for item, count in pairs(recipe.output) do
		if carpentry_output_whitelist[item] then
			return "carpentry", true
		end
	end
	
	local contains_wood = false
	for item, count in pairs(recipe.input) do
		if is_stone(item) or is_metal_ingot(item) then
			return
		end
		if is_wood(item) then
			contains_wood = true
		end
	end
	
	if contains_wood then
		return "carpentry", true
	end
end)

----------------------------------------------
-- Smelter

-- creates "recycling" recipes that allow items to be melted down for their metal content
-- doesn't otherwise disturb the crafting systems.
simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "normal" then 
		return
	end
	
	local metal_inputs = {}
	local has_metal_inputs = false
	for item, count in pairs(recipe.input) do
		if is_metal_ingot(item) then
			metal_inputs[item] = count
			has_metal_inputs = true
		end
	end
	
	if has_metal_inputs then
		local max_item
		local max_count = 0
		local total_count = 0
		for item, count in pairs(metal_inputs) do
			total_count = total_count + count
			if count > max_count then
				max_count = count
				max_item = item
			end
		end
		metal_inputs[max_item] = nil
		local recycle_recipe = {}
		recycle_recipe.cooktime = total_count * 3.0
		recycle_recipe.input = {}
		for item, count in pairs(recipe.output) do
			recycle_recipe.input[item] = count
		end
		recycle_recipe.output = {[max_item] = max_count}
		recycle_recipe.returns = metal_inputs
		
		simplecrafting_lib.register("smelter", recycle_recipe)
	end
end)

-- appropriates recipes that output metal ingots for the smelter
simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "cooking" then 
		return
	end
	
	for item, count in pairs(recipe.output) do
		if is_metal_ingot(item) then
			return "smelter", true
		end
	end
end)
