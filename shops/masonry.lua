local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local raw_stone = 
{
-- Commented out entries already belong to group "stone" in default.
--	["default:stone"] = true
--	["default:cobble"] = true
--	["default:stonebrick"] = true
--	["default:stone_block"] = true
--	["default:mossycobble"] = true
--	["default:desert_stone"] = true
--	["default:desert_cobble"] = true
--	["default:desert_stonebrick"] = true
--	["default:desert_stone_block"] = true
	["default:sandstone"] = true,
	["default:sandstonebrick"] = true,
	["default:sandstone_block"] = true,
	["default:desert_sandstone"] = true,
	["default:desert_sandstone_brick"] = true,
	["default:desert_sandstone_block"] = true,
	["default:silver_sandstone"] = true,
	["default:silver_sandstone_brick"] = true,
	["default:silver_sandstone_block"] = true,
	["default:obsidian"] = true,
	["default:obsidianbrick"] = true,
	["default:obsidian_block"] = true,
}

local function is_stone_input(item_name)
	if minetest.get_item_group(item_name, "stone") > 0 then
		return true
	end
	return raw_stone[item_name]
end

-- appropriates recipes with stone inputs
simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method ~= "normal" then 
		return
	end
	
	for item, count in pairs(recipe.input) do
		if is_stone_input(item) then
			return "masonry", true
		end
	end
end)

local table_functions = simplecrafting_lib.generate_table_functions("masonry", true, false)

local table_def = {
	description = S("Slab Support"),
	tiles = {"default_wood.png"},
	groups = {workshops_masonry = 2, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{0.1875, -0.5, 0.125, 0.5, 0.1875, 0.4375}, -- NodeBox1
			{-0.5, -0.5, 0.125, -0.1875, 0.1875, 0.4375}, -- NodeBox2
			{-0.5, 0.1875, 0.125, 0.5, 0.5, 0.4375}, -- NodeBox3
			{-0.5, 0.1875, -0.4375, 0.5, 0.5, -0.125}, -- NodeBox4
			{-0.5, -0.5, -0.4375, -0.1875, 0.1875, -0.125}, -- NodeBox5
			{0.1875, -0.5, -0.4375, 0.5, 0.1875, -0.125}, -- NodeBox6
		}
	}
}

for k, v in pairs(table_functions) do
	table_def[k] = v
end

minetest.register_node("workshops:stone_support", table_def)

minetest.register_node("workshops:stoneworking_tool_rack", {
	description = S("Stoneworking Tool Rack"),
	tiles = {"image.png"},
	groups = {workshops_masonry = 2, oddly_breakable_by_hand = 1},
})