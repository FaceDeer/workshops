local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

workshops = {}

workshops.height = 5
workshops.radius = 5

dofile(MP.."/recipes.lua")

dofile(MP.."/shops/smelter.lua")
dofile(MP.."/shops/carpentry.lua")
dofile(MP.."/shops/masonry.lua")
dofile(MP.."/shops/forge.lua")
dofile(MP.."/shops/kitchen.lua")
dofile(MP.."/shops/mechanic.lua")
dofile(MP.."/shops/dyer.lua")
dofile(MP.."/shops/loom.lua")

local get_workshop_score = function(pos, radius, height, group_name)
	local node_list = minetest.find_nodes_in_area(
			{x=pos.x-radius, y=pos.y-height, z=pos.z-radius},
			{x=pos.x+radius, y=pos.y+height, z=pos.z+radius},
			"group:" .. group_name
		)
	local val = 0
	for _, accessory_pos in pairs(node_list) do
		val = val + minetest.get_item_group(minetest.get_node(accessory_pos).name, group_name)
	end
	return val
end

workshops.get_crafting_time_multiplier = function(pos, radius, height, group_name, recipe)
	local score = get_workshop_score(pos, radius, height, group_name)
	local input_count = 0
	if recipe.cooktime then
		input_count = recipe.cooktime
	else
		for _, count in pairs(recipe.input) do
			input_count = input_count + count
		end
	end
	return input_count / score
end

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