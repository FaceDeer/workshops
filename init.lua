local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

workshops = {}

dofile(MP.."/shops/smelter.lua")
dofile(MP.."/shops/carpentry.lua")
dofile(MP.."/shops/masonry.lua")
dofile(MP.."/shops/forge.lua")
dofile(MP.."/shops/kitchen.lua")


workshops.get_workshop_score = function(pos, radius, height, group_name, workshop_nodes)

	local node_list = minetest.find_nodes_in_area(
			{x=pos.x-radius, y=pos.y-height, z=pos.z-radius},
			{x=pos.x+radius, y=pos.y+height, z=pos.z+radius},
			workshop_nodes
		)
	for _, accessory_pos in pairs(node_list) do
		local val = minetest.get_item_group(minetest.get_node(accessory_pos).name, group_name)
		if val > 0 then
			return val
		else
			return 1
		end
	end
end



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
simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
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
		
		simplecrafting_lib.register("smelter", recycle_recipe)
	end
end)

-- appropriates recipes that output metal ingots for the smelter
simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "cooking" then 
		return
	end
	
	for item, count in pairs(recipe.output) do
		if is_metal_input(item) then
			return "smelter", true
		end
	end
end)

simplecrafting_lib.import_legacy_recipes()

simplecrafting_lib.register("smelter_fuel", {
	input={["default:coal_lump"]=1},
	burntime = 30,
	returns={["workshops:coal_ash"]=1}
})
simplecrafting_lib.register("smelter_fuel", {
	input={["default:coalblock"]=1},
	burntime = 270,
	returns={["workshops:coal_ash"]=9}
})

minetest.register_craftitem("workshops:coal_ash", {
	description = S("Coal Ash"),
	inventory_image = "workshops_coal_ash.png",
	groups = {ash=1},	
})

minetest.register_node("workshops:coal_ash_block",{
	description = S("Coal Ash Block"),
	groups = {ash=1, falling_node=1, crumbly=3},
	drawtype = "normal",
	tiles = {"workshops_coal_ash_block.png"},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_craft({
	type="shapeless",
	output="workshops:coal_ash_block",
	recipe={"workshops:coal_ash", "workshops:coal_ash", "workshops:coal_ash", "workshops:coal_ash", "workshops:coal_ash", "workshops:coal_ash", "workshops:coal_ash", "workshops:coal_ash", "workshops:coal_ash"}
})
minetest.register_craft({
	type="shapeless",
	output="workshops:coal_ash 9",
	recipe={"workshops:coal_ash_block"}
})