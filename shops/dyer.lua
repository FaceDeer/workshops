local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local dye_tub_def = {
	description = S("Dyer's Tub"),
	tiles = {"workshops_barrel_top.png", "workshops_barrel_top.png", "workshops_barrel_side.png"},
	groups = {workshops_kitchen = 1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.25, 0.375, 0.5, 0.25}, -- base
			{-0.5, -0.375, -0.25, 0.5, 0.375, 0.25}, -- outer_side
			{-0.25, -0.375, -0.5, 0.25, 0.375, 0.5}, -- outer_side
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.375}, -- inner_side
			{-0.25, -0.5, -0.375, 0.25, 0.5, 0.375}, -- NodeBox10
		}
	},
}

local table_functions = simplecrafting_lib.generate_table_functions("dyer", {
	show_guides = true,
	alphabetize_items = false,
	description = simplecrafting_lib.get_crafting_info("dyer").description,
	hopper_node_name = "workshops:dye_tub",
})

for k, v in pairs(table_functions) do
	dye_tub_def[k] = v
end

minetest.register_node("workshops:dye_tub", dye_tub_def)

simplecrafting_lib.register_crafting_guide_item("workshops:dying_guide", "dyer", {
	guide_color = "#8e44ad",
	copy_item_to_book = "workshops:dye_tub",
})