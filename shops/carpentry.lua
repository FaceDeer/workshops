local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:sawhorse", {
	description = S("Sawhorse"),
	tiles = {"image.png"},
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1},
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