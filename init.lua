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