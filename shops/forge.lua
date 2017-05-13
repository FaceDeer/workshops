local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:anvil", {
	description = S("Anvil"),
	tiles = {"image.png"},
	groups = {workshops_forge = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:trip_hammer", {
	description = S("Trip Hammer"),
	tiles = {"image.png"},
	groups = {workshops_forge = 2, workshops_masonry=1, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:quenching_trough", {
	description = S("Quenching Trough"),
	tiles = {"image.png"},
	groups = {workshops_forge = 1, oddly_breakable_by_hand = 1},
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