local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local loom_tex = "(default_wood.png^[mask:workshops_loom_frame_mask.png)^workshops_loom_fabric.png"

local loom_def = {
	description = S("Loom"),
	tiles = {"default_wood.png", "default_wood.png", "default_wood.png", "default_wood.png", loom_tex, loom_tex.."^[transformFX"},
	groups = {workshops_loom = 1, oddly_breakable_by_hand = 1, tubedevice = 1, tubedevice_receiver = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.0625, 0.5, 0.5, 0.125}, -- top_frame
			{0.375, -0.375, -0.0625, 0.5, 0.375, 0.125}, -- right_upright
			{-0.5, -0.375, -0.0625, -0.375, 0.375, 0.125}, -- left_upright
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.125}, -- mid_base
			{-0.5, -0.5, -0.5, -0.375, -0.375, 0.5}, -- left_base
			{0.375, -0.5, -0.5, 0.5, -0.375, 0.5}, -- right_base
			{-0.375, -0.5, -0.5, 0.375, -0.375, -0.375}, -- back_base
			{-0.5, -0.5, 0.375, 0.5, -0.375, 0.5}, -- front_base
			{-0.375, -0.375, 0, 0.375, -0.125, 0.0625}, -- sheet
			{-0.375, -0.125, 0, -0.3125, 0.375, 0.0625}, -- thread1
			{-0.125, -0.125, 0, -0.0625, 0.375, 0.0625}, -- thread3
			{-0.25, -0.125, 0, -0.1875, 0.375, 0.0625}, -- thread2
			{0, -0.125, 0, 0.0625, 0.375, 0.0625}, -- thread4
			{0.125, -0.125, 0, 0.1875, 0.375, 0.0625}, -- thread5
			{0.25, -0.125, 0, 0.3125, 0.375, 0.0625}, -- thread6
		}
	}
}

local table_functions = simplecrafting_lib.generate_table_functions("loom", {
	show_guides = true,
	alphabetize_items = false,
	description = simplecrafting_lib.get_crafting_info("loom").description,
	hopper_node_name = "workshops:loom",
	enable_pipeworks = true,
})

for k, v in pairs(table_functions) do
	loom_def[k] = v
end

minetest.register_node("workshops:loom", loom_def)

simplecrafting_lib.register_crafting_guide_item("workshops:loom_guide", "loom", {
	guide_color = "#5d6d7e",
	copy_item_to_book = "workshops:loom",
})