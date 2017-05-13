local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:stone_support", {
	description = S("Slab Support"),
	tiles = {"default_wood.png"},
	groups = {workshops_masonry = 2, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{0.1875, -0.5, 0.125, 0.5, 0.1875, 0.4375}, -- NodeBox1
			{-0.5, -0.5, 0.125, -0.1875, 0.1875, 0.4375}, -- NodeBox2
			{-0.5, 0.1875, 0.125, 0.5, 0.5, 0.4375}, -- NodeBox3
			{-0.5, 0.1875, -0.4375, 0.5, 0.5, -0.125}, -- NodeBox4
			{-0.5, -0.5, -0.4375, -0.1875, 0.1875, -0.125}, -- NodeBox5
			{0.1875, -0.5, -0.4375, 0.5, 0.1875, -0.125}, -- NodeBox6
		}
	}
})

minetest.register_node("workshops:stoneworking_tool_rack", {
	description = S("Stoneworking Tool Rack"),
	tiles = {"image.png"},
	groups = {workshops_masonry = 2, oddly_breakable_by_hand = 1},
})