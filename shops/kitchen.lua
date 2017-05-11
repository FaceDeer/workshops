local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:oven", {
	description = S("Oven"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:cauldron", {
	description = S("Cauldron"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:kitchen_countertop", {
	description = S("Kitchen Countertop"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:kitchen_grinder", {
	description = S("Kitchen Grinder"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 1, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:icebox", {
	description = S("Icebox"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 1, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:barrel", {
	description = S("Barrel"),
	tiles = {"image.png"},
	groups = {workshops_kitchen = 1, oddly_breakable_by_hand = 1},
})