local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local mechanic_bench_def = {
	description = S("Mechanic's Workbench"),
	tiles = {"default_wood.png"},
	groups = {workshops_mechanic = 1, oddly_breakable_by_hand = 1, tubedevice = 1, tubedevice_receiver = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.3125, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{0.3125, -0.5, -0.4375, 0.4375, 0.3125, -0.3125}, -- NodeBox2
			{-0.4375, -0.5, -0.4375, -0.3125, 0.3125, -0.3125}, -- NodeBox3
			{-0.4375, -0.5, 0.3125, -0.3125, 0.3125, 0.4375}, -- NodeBox4
			{0.3125, -0.5, 0.3125, 0.4375, 0.3125, 0.4375}, -- NodeBox5
		}
	}
}

local table_functions = simplecrafting_lib.generate_table_functions("mechanic", {
	show_guides = true,
	alphabetize_items = false,
	description = simplecrafting_lib.get_crafting_info("mechanic").description,
	hopper_node_name = "workshops:mechanic_bench",
	enable_pipeworks = true,
	crafting_time_multiplier = function (pos, recipe)
		return workshops.get_crafting_time_multiplier(pos, workshops.radius, workshops.height, "workshops_mechanic", recipe)
	end,
})

for k, v in pairs(table_functions) do
	mechanic_bench_def[k] = v
end

minetest.register_node("workshops:mechanic_bench", mechanic_bench_def)

simplecrafting_lib.register_crafting_guide_item("workshops:mechanics_guide", "mechanic", {
	guide_color = "#566573",
	copy_item_to_book = "workshops:mechanic_bench",
})