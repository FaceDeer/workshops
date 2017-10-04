local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local oven_def = {
	description = S("Oven"),
	tiles = {
		"default_cobble.png", "default_furnace_bottom.png",
		"default_furnace_side.png", "default_furnace_side.png",
		"default_furnace_side.png", "default_furnace_front.png"
	},
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1, tubedevice = 1, tubedevice_receiver = 1},
	sounds = default.node_sound_stone_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}, -- NodeBox1
			{-0.375, 0, -0.5, 0.375, 0.25, 0.5}, -- NodeBox2
			{-0.25, 0.25, -0.5, 0.25, 0.4375, 0.5}, -- NodeBox3
			{-0.125, 0.4375, -0.5, 0.125, 0.5, 0.5}, -- NodeBox4
		}
	}
}

local oven_functions = simplecrafting_lib.generate_multifurnace_functions("cooking", "cooking_fuel", {
	show_guides = true,
	alphabetize_items = false,
	description = simplecrafting_lib.get_crafting_info("cooking").description,
	hopper_node_name = "workshops:oven",
	enable_pipeworks = true,
})

for k, v in pairs(oven_functions) do
	oven_def[k] = v
end

minetest.register_node("workshops:oven", oven_def)

simplecrafting_lib.register_crafting_guide_item("workshops:kitchen_guide", "cooking", {
	guide_color = "#e74c3c",
	copy_item_to_book = "workshops:oven",
})

minetest.register_node("workshops:oven_active", {
	description = S("Oven"),
	tiles = {
		"default_cobble.png", "default_furnace_bottom.png",
		"default_furnace_side.png", "default_furnace_side.png",
		"default_furnace_side.png",
		{
			image = "default_furnace_front_active.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5
			},
		}
	},
	light_source = 8,
	drop = "workshops:oven",
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}, -- NodeBox1
			{-0.375, 0, -0.5, 0.375, 0.25, 0.5}, -- NodeBox2
			{-0.25, 0.25, -0.5, 0.25, 0.4375, 0.5}, -- NodeBox3
			{-0.125, 0.4375, -0.5, 0.125, 0.5, 0.5}, -- NodeBox4
		}
	}
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
	tiles = {"workshops_kitchen_cabinet_top.png", "default_wood.png",
		"default_wood.png", "default_wood.png",
		"default_wood.png", "workshops_kitchen_cabinet_front.png"
	},
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
	groups = {workshops_kitchen = 2, oddly_breakable_by_hand = 1},
	tiles = {"default_wood.png", "default_wood.png",
		"default_wood.png", "default_wood.png",
		"default_wood.png", "workshops_icebox_doors.png"
	},
	drawtype="nodebox",
	paramtype = "light",
	paramtype2 = "facedir",	
	node_box = {
		type="fixed",
		fixed = {
			{-0.5, -0.4375, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.375, -0.4375, -0.375},
			{0.5, -0.5, -0.5, 0.375, -0.4375, -0.375},
			{-0.5, -0.5, 0.5, -0.375, -0.4375, 0.375},
			{0.5, -0.5, 0.5, 0.375, -0.4375, 0.375},
		},
	},
})

minetest.register_node("workshops:barrel", {
	description = S("Barrel"),
	tiles = {"workshops_barrel_top.png", "workshops_barrel_top.png", "workshops_barrel_side.png"},
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