local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:oven", {
	description = S("Oven"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:cauldron", {
	description = S("Cauldron"),
	tiles = {"default_furnace_top.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",	
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.3125, 0.375, 0.1875, -0.25}, -- body
			{-0.375, -0.375, 0.375, 0.375, 0.25, 0.4375}, -- rim1
			{-0.375, 0.1875, -0.3125, -0.0625, 0.25, -0.25}, -- rim2
			{0.3125, -0.375, -0.25, 0.375, 0.25, 0.375}, -- rim3
			{-0.375, -0.375, -0.25, -0.3125, 0.25, 0.375}, -- rim4
			{0.0625, 0.1875, -0.3125, 0.375, 0.25, -0.25}, -- rim5
			{-0.125, 0.125, -0.4375, 0.125, 0.1875, -0.3125}, -- spout1
			{0.0625, 0.1875, -0.4375, 0.125, 0.3125, -0.3125}, -- spout2
			{-0.125, 0.1875, -0.4375, -0.0625, 0.3125, -0.3125}, -- spout3
			{-0.3125, -0.5, -0.25, 0.3125, -0.375, 0.375}, -- bottom
			{-0.4375, 0.25, 0.4375, 0.4375, 0.3125, 0.5}, -- lip1
			{0.375, 0.25, -0.3125, 0.4375, 0.3125, 0.4375}, -- lip2
			{-0.4375, 0.25, -0.3125, -0.375, 0.3125, 0.4375}, -- lip3
			{0.125, 0.25, -0.375, 0.4375, 0.3125, -0.3125}, -- lip4
			{-0.4375, 0.25, -0.375, -0.125, 0.3125, -0.3125}, -- lip5
		}
	}
})

minetest.register_node("workshops:kitchen_countertop", {
	description = S("Kitchen Countertop"),
	tiles = {"default_wood.png"},
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",	
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.375, 0.5, 0.375, 0.5}, -- NodeBox2
		}
	},
})

minetest.register_node("workshops:kitchen_grinder", {
	description = S("Kitchen Grinder"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_kitchen = 1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.25, -0.3125, 0.125, 0, 0.3125}, -- NodeBox1
			{-0.1875, -0.3125, 0.3125, 0.1875, 0.0625, 0.5}, -- NodeBox2
			{-0.1875, -0.3125, -0.1875, 0.1875, 0.0625, 0.1875}, -- NodeBox3
			{-0.125, -0.4375, -0.125, 0.125, 0.1875, 0.125}, -- NodeBox4
			{-0.1875, 0.1875, -0.1875, 0.1875, 0.375, 0.1875}, -- NodeBox5
			{-0.5, -0.1875, -0.375, 0.0625, -0.0625, -0.3125}, -- NodeBox6
			{-0.5, -0.1875, -0.5, -0.375, -0.0625, -0.375}, -- NodeBox7
			{-0.25, -0.5, -0.25, 0.25, -0.4375, 0.25}, -- NodeBox8
		}
	},
})

minetest.register_node("workshops:icebox", {
	description = S("Icebox"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 1, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:barrel", {
	description = S("Barrel"),
	tiles = {"default_wood.png"},
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
})