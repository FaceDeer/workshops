
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

dofile(MP.."/shops/smelter.lua")
dofile(MP.."/shops/carpentry.lua")
dofile(MP.."/shops/masonry.lua")
dofile(MP.."/shops/forge.lua")
dofile(MP.."/shops/kitchen.lua")


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

local function is_metal_input(item_name)
	if minetest.get_item_group(item_name, "metal_ingot") > 0 then
		return true
	end
	return metal_ingots[item_name]
end

-- creates "recycling" recipes that allow items to be melted down for their metal content
-- doesn't otherwise disturb the crafting systems.
crafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "normal" then 
		return
	end
	
	local metal_inputs = {}
	local has_metal_inputs = false
	for item, count in pairs(recipe.input) do
		if is_metal_input(item) then
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
		
		crafting_lib.register("smelter", recycle_recipe)
	end
end)

-- appropriates recipes that output metal ingots for the smelter
crafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "cooking" then 
		return
	end
	
	for item, count in pairs(recipe.output) do
		if is_metal_input(item) then
			return "smelter", true
		end
	end
end)


crafting_lib.import_legacy_recipes()
