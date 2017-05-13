local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:anvil", {
	description = S("Anvil"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_forge = 2, oddly_breakable_by_hand = 1},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
			{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
			{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
			{-0.35,-0.1,-0.2,0.35,0.1,0.2},
		},
	},
})

minetest.register_node("workshops:trip_hammer", {
	description = S("Trip Hammer"),
	tiles = {"image.png"},
	groups = {workshops_forge = 2, workshops_masonry=1, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:quenching_trough", {
	description = S("Quenching Trough"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_forge = 1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.1875, -0.5, 0.25, -0.0625, 0.5}, -- NodeBox1
			{-0.1875, -0.3125, -0.5, 0.1875, -0.1875, 0.5}, -- NodeBox2
			{-0.125, -0.4375, -0.5, 0.125, -0.3125, 0.5}, -- NodeBox3
			{-0.25, -0.5, -0.5, -0.1875, -0.1875, -0.4375}, -- leg1
			{-0.25, -0.5, 0.4375, -0.1875, -0.1875, 0.5}, -- leg2
			{0.1875, -0.5, -0.5, 0.25, -0.1875, -0.4375}, -- leg3
			{0.1875, -0.5, 0.4375, 0.25, -0.1875, 0.5}, -- leg4
		}
	}
})

minetest.register_node("workshops:metalworking_tool_rack", {
	description = S("Metalworking Tool Rack"),
	tiles = {"image.png"},
	groups = {workshops_forge = 1, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:forge", {
	description = S("Forge"),
	tiles = {"image.png"},
	groups = {workshops_forge = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:bellows", {
	description = S("Bellows"),
	tiles = {"image.png"},
	groups = {workshops_forge = 1, workshops_smelter = 1, oddly_breakable_by_hand = 1},
})