local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:sawhorse", {
	description = S("Sawhorse"),
	tiles = {"default_wood.png"},
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.25, -0.125, 0.5, 0.5, 0.125}, -- crossbeam
			{-0.5, 0, -0.25, -0.3125, 0.375, -0.125}, -- NodeBox2
			{-0.5, -0.25, -0.375, -0.3125, 0.125, -0.25}, -- NodeBox3
			{-0.5, -0.5, -0.5, -0.3125, -0.125, -0.375}, -- NodeBox4
			{-0.5, 0, 0.125, -0.3125, 0.375, 0.25}, -- NodeBox5
			{-0.5, -0.5, 0.375, -0.3125, -0.125, 0.5}, -- NodeBox6
			{-0.5, -0.25, 0.25, -0.3125, 0.125, 0.375}, -- NodeBox7
			{0.3125, -0.25, 0.25, 0.5, 0.125, 0.375}, -- NodeBox8
			{0.3125, 0, 0.125, 0.5, 0.375, 0.25}, -- NodeBox9
			{0.3125, -0.5, 0.375, 0.5, -0.125, 0.5}, -- NodeBox10
			{0.3125, 0, -0.25, 0.5, 0.375, -0.125}, -- NodeBox11
			{0.3125, -0.25, -0.375, 0.5, 0.125, -0.25}, -- NodeBox12
			{0.3125, -0.5, -0.5, 0.5, -0.125, -0.375}, -- NodeBox13
			{-0.4375, -0.4375, -0.5, -0.375, -0.3125, 0.5}, -- NodeBox14
			{0.375, -0.4375, -0.5, 0.4375, -0.3125, 0.5}, -- NodeBox15
		}
	}
})

minetest.register_node("workshops:table_saw", {
	description = S("Table Saw"),
	tiles = {"image.png"},
	groups = {workshops_carpentry = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:drill_press", {
	description = S("Drill Press"),
	tiles = {"image.png"},
	groups = {workshops_carpentry = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:woodworking_tool_rack", {
	description = S("Woodworking Tool Rack"),
	tiles = {"image.png"},
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:woodworking_table", {
	description = S("Woodworking Table"),
	tiles = {"image.png"},
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1},
})