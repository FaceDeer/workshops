local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local forge_def = {
	description = S("Forge"),
	tiles = {"image.png"},
	groups = {workshops_forge = 2, oddly_breakable_by_hand = 1},
	tiles = {
		"default_stone_block.png^(workshops_coal_bed.png^[mask:workshops_forge_bed_mask.png)",
		"default_stone_brick.png",
		"default_stone_brick.png",
		"default_stone_brick.png",
		"default_stone_brick.png",
		"default_stone_brick.png",
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, -0.5, 0.5}, -- plat
			{-0.5, 0.375, 0.375, 0.5, 0.5, 0.5}, -- edge
			{-0.5, 0.375, -0.5, 0.5, 0.5, -0.375}, -- edge
			{0.375, 0.375, -0.375, 0.5, 0.5, 0.375}, -- edge
			{-0.5, 0.375, -0.375, -0.375, 0.5, 0.375}, -- edge
		},
	},

	-- TODO: make sophisticated
	-- Pipeworks compatibility
	----------------------------------------------------------------

	tube = (function() if minetest.get_modpath("pipeworks") then return {
		insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("input", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:room_for_item("input", stack)
		end,
		input_inventory = "main",
		connect_sides = {left = 1, right = 1, back = 1, front = 1, bottom = 1, top = 1}
	} end end)(),

}

local forge_functions = simplecrafting_lib.generate_multifurnace_functions("forge", "smelter_fuel", {
	show_guides = true,
	alphabetize_items = false,
	description = simplecrafting_lib.get_crafting_info("forge").description,
	hopper_node_name = "workshops:forge",
})

for k, v in pairs(forge_functions) do
	forge_def[k] = v
end

minetest.register_node("workshops:forge", forge_def)


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
	tiles = {"default_furnace_top.png"},
	groups = {workshops_forge = 2, workshops_masonry=1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}, -- base
			{-0.25, -0.375, -0.4375, 0.25, -0.25, 0.0625}, -- anvil
			{-0.5, -0.375, -0.3125, -0.3125, 0.3125, -0.0625}, -- support
			{0.3125, -0.375, -0.3125, 0.5, 0.3125, -0.0625}, -- support2
			{-0.5, 0.3125, -0.3125, 0.5, 0.5, -0.0625}, -- crossbeam
			{-0.125, -0.25, -0.375, 0.125, 0, 0}, -- hammer
			{-0.0625, -0.1875, 0, 0.0625, -0.0625, 0.3125}, -- NodeBox7
			{-0.125, -0.375, 0.3125, 0.125, 0, 0.5}, -- NodeBox8
		}
	},
	
	on_punch = function(pos, node, player, pointed_thing)
		minetest.swap_node(pos, {name="workshops:trip_hammer_up", param2=node.param2})
	end,
})

minetest.register_node("workshops:trip_hammer_up", {
	description = S("Trip Hammer"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_forge = 2, workshops_masonry=1, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	drop = "workshops:trip_hammer",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",	
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}, -- base
			{-0.25, -0.375, -0.4375, 0.25, -0.25, 0.0625}, -- anvil
			{-0.5, -0.375, -0.3125, -0.3125, 0.3125, -0.0625}, -- support
			{0.3125, -0.375, -0.3125, 0.5, 0.3125, -0.0625}, -- support2
			{-0.5, 0.3125, -0.3125, 0.5, 0.5, -0.0625}, -- crossbeam
			{-0.125, 0.0625, -0.375, 0.125, 0.3125, 0}, -- hammer
			{-0.0625, -0.0625, 0.25, 0.0625, 0.0625, 0.375}, -- handle
			{-0.125, -0.375, 0.3125, 0.125, 0, 0.5}, -- handlesupport
			{-0.0625, 0, 0.125, 0.0625, 0.125, 0.25}, -- handle
			{-0.0625, 0.0625, 0, 0.0625, 0.1875, 0.125}, -- handle
		}
	},
	
	on_punch = function(pos, node, player, pointed_thing)
		minetest.swap_node(pos, {name="workshops:trip_hammer", param2=node.param2})
	end,
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

minetest.register_node("workshops:bellows", {
	description = S("Bellows"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_forge = 1, workshops_smelter = 1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.25, 0.5, 0.5, -0.125}, -- frametop
			{0.375, -0.5, -0.25, 0.5, 0.375, -0.125}, -- support1
			{-0.5, -0.5, -0.25, -0.375, 0.375, -0.125}, -- support2
			{-0.3125, -0.375, -0.25, 0.3125, 0.1875, -0.0625}, -- NodeBox4
			{-0.25, -0.375, -0.0625, 0.25, 0.0625, 0.125}, -- NodeBox5
			{-0.1875, -0.375, 0.125, 0.1875, -0.0625, 0.3125}, -- NodeBox6
			{-0.125, -0.375, 0.3125, 0.125, -0.1875, 0.5}, -- NodeBox7
			{-0.375, -0.375, -0.4375, 0.375, 0.3125, -0.25}, -- NodeBox8
			{-0.0625, 0.3125, -0.5, 0.0625, 0.375, -0.3125}, -- NodeBox9
		}
	},
	
	on_punch = function(pos, node, player, pointed_thing)
		minetest.swap_node(pos, {name="workshops:bellows_compressed", param2=node.param2})
	end,
})

minetest.register_node("workshops:bellows_compressed", {
	description = S("Bellows"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_forge = 1, workshops_smelter = 1, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	drop = "workshops:bellows",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.25, 0.5, 0.5, -0.125}, -- frametop
			{0.375, -0.5, -0.25, 0.5, 0.375, -0.125}, -- support1
			{-0.5, -0.5, -0.25, -0.375, 0.375, -0.125}, -- support2
			{-0.3125, -0.375, -0.25, 0.3125, -0.1875, -0.0625}, -- NodeBox4
			{-0.25, -0.375, -0.0625, 0.25, -0.1875, 0.125}, -- NodeBox5
			{-0.1875, -0.375, 0.125, 0.1875, -0.1875, 0.3125}, -- NodeBox6
			{-0.125, -0.375, 0.3125, 0.125, -0.1875, 0.5}, -- NodeBox7
			{-0.375, -0.375, -0.4375, 0.375, -0.1875, -0.25}, -- NodeBox8
			{-0.0625, -0.1875, -0.5, 0.0625, -0.125, -0.3125}, -- NodeBox9
		}
	},
	
	on_punch = function(pos, node, player, pointed_thing)
		minetest.swap_node(pos, {name="workshops:bellows", param2=node.param2})
	end,
})