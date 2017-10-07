local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local woodworking_table_def = {
	description = S("Woodworking Table"),
	tiles = {"default_wood.png"},
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.3125, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{0.3125, -0.5, -0.4375, 0.4375, 0.3125, -0.3125}, -- NodeBox2
			{-0.4375, -0.5, -0.4375, -0.3125, 0.3125, -0.3125}, -- NodeBox3
			{-0.4375, -0.5, 0.3125, -0.3125, 0.3125, 0.4375}, -- NodeBox4
			{0.3125, -0.5, 0.3125, 0.4375, 0.3125, 0.4375}, -- NodeBox5
		}
	}
}

local table_functions = simplecrafting_lib.generate_autocraft_functions("carpentry", {
	show_guides = true,
	alphabetize_items = false,
	description = simplecrafting_lib.get_crafting_info("carpentry").description,
	hopper_node_name = "workshops:woodworking_table",
	enable_pipeworks = true,
	crafting_time_multiplier = function (pos, recipe)
		return workshops.get_crafting_time_multiplier(pos, workshops.radius, workshops.height, "workshops_carpentry", recipe)
	end,
})

for k, v in pairs(table_functions) do
	woodworking_table_def[k] = v
end

minetest.register_node("workshops:woodworking_table", woodworking_table_def)

simplecrafting_lib.register_crafting_guide_item("workshops:carpentry_guide", "carpentry", {
	guide_color = "#a04000",
	copy_item_to_book = "workshops:woodworking_table",
})


minetest.register_node("workshops:sawhorse", {
	description = S("Sawhorse"),
	tiles = {"default_wood.png"},
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1, tubedevice = 1, tubedevice_receiver = 1},
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
	tiles = {"workshops_table_saw_top.png", "workshops_table_saw_bottom.png", "workshops_table_saw_side.png"},
	groups = {workshops_carpentry = 2, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4, -0.5, -0.4, -0.25, 0.375, -0.25}, -- Leg
			{0.25, -0.5, 0.25, 0.4, 0.375, 0.4}, -- Leg
			{-0.4, -0.5, 0.25, -0.25, 0.375, 0.4}, -- Leg
			{0.25, -0.5, -0.4, 0.4, 0.375, -0.25}, -- Leg
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- Tabletop
			{-0.01, 0.5625, -0.125, 0.01, 0.625, 0.125}, -- Saw blade (top)
			{-0.01, 0.5, -0.1875, 0.01, 0.5625, 0.1875}, -- Saw blade (bottom)
			{-0.25, 0.0625, -0.25, 0.25, 0.375, 0.25}, -- Motor case
		},
	},
})

minetest.register_node("workshops:drill_press", {
	description = S("Drill Press"),
	tiles = {"image.png"},
	groups = {workshops_carpentry = 2, oddly_breakable_by_hand = 1},
	tiles = {
		"workshops_drill_top.png",
		"workshops_drill_bottom.png^[transformR180",
		"workshops_drill_rside.png",
		"workshops_drill_lside.png",
		"workshops_drill_back.png",
		"workshops_drill_front.png"
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, 0.0625, -0.125, 0.1875, 0.5, 0.3125}, 
			{-0.1875, 0.125, -0.1875, 0.1875, 0.4375, 0.375}, 
			{-0.1875, -0.5, 0.375, -0.0625, 0.3125, 0.5}, 
			{0.0625, -0.5, 0.375, 0.1875, 0.3125, 0.5}, 
			{-0.0625, -0.25, -0.0625, 0, 0.5, 0}, 
			{-0.1875, 0.3125, 0.375, 0.1875, 0.375, 0.4375}, 
			{0.1875, 0.1875, -0.0625, 0.25, 0.375, 0.125}, 
			{0.1875, 0.25, -0.5, 0.25, 0.3125, 0}, 
		}
	},
})

minetest.register_node("workshops:woodworking_tool_rack", {
	description = S("Woodworking Tool Rack"),
	tiles = {"image.png"},
	groups = {workshops_carpentry = 1, oddly_breakable_by_hand = 1},
})
