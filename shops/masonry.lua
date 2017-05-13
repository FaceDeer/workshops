local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("workshops:stone_support", {
	description = S("Slab Support"),
	tiles = {"image.png"},
	groups = {workshops_masonry = 2, oddly_breakable_by_hand = 1},
})

minetest.register_node("workshops:stoneworking_tool_rack", {
	description = S("Stoneworking Tool Rack"),
	tiles = {"image.png"},
	groups = {workshops_masonry = 2, oddly_breakable_by_hand = 1},
})