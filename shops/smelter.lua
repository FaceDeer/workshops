local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")


local function refresh_score(pos, meta)
	local score = workshops.get_workshop_score(pos, 5, 2, "workshops_smelter", {"group:workshops_smelter"})
	--meta:set_int("workshop_score", score)
	return score
end

-------------------------------------------------------------------
-- Smelter furnace

local smelter_def = {
	description = S("Smelting Furnace"),
	tiles = {
		"default_cobble.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 1, cracky=3, workshops_smelter = 3},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{0.125, -0.5, -0.5, 0.5, -0.1875, 0.5}, -- base1
			{-0.4375, -0.1875, -0.4375, 0.4375, 0.0625, 0.4375}, -- layer2
			{-0.375, 0.0625, -0.375, 0.375, 0.25, 0.375}, -- layer3
			{-0.3125, 0.25, -0.3125, 0.3125, 0.375, 0.3125}, -- layer4
			{-0.125, 0.4375, -0.125, 0.125, 0.5, 0.125}, -- layer6
			{-0.25, 0.375, -0.25, 0.25, 0.4375, 0.25}, -- layer5
			{-0.5, -0.5, -0.5, -0.125, -0.1875, 0.5}, -- base2
			{-0.125, -0.5, 0.25, 0.125, -0.1875, 0.5}, -- base3
			{-0.25, -0.1875, -0.5, 0.25, -0.0625, -0.4375}, -- arch
		}
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

local smelter_functions = simplecrafting_lib.generate_multifurnace_functions("smelter", "smelter_fuel", {
	show_guides = true,
	alphabetize_items = false,
})

for k, v in pairs(smelter_functions) do
	smelter_def[k] = v
end

minetest.register_node("workshops:smelting_furnace", smelter_def)


if minetest.get_modpath("hopper") and hopper ~= nil and hopper.add_container ~= nil then
	hopper:add_container({
		{"top", "workshops:smelting_furnace", "output"},
		{"bottom", "workshops:smelting_furnace", "input"},
		{"side", "workshops:smelting_furnace", "fuel"},
})
end


-------------------------------------------------------------------------
-- Other nodes

minetest.register_craftitem("workshops:smelter_guide", {
	description = S("Crafting Guide (Smelter)"),
	inventory_image = "crafting_guide_cover.png^[colorize:#ff120088^crafting_guide_contents.png",
	wield_image = "crafting_guide_cover.png^[colorize:#ff120088^crafting_guide_contents.png",
	stack_max = 1,
	groups = {book = 1},
	on_use = function(itemstack, user)
		simplecrafting_lib.show_crafting_guide("smelter", user)
	end,
})

minetest.register_node("workshops:crucible", {
	description = S("Crucible"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_smelter = 2, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.1875, -0.375, 0.375, 0.375, -0.25}, -- body
			{-0.5, -0.5, -0.125, -0.375, 0.25, 0.125}, -- support1
			{0.375, -0.5, -0.125, 0.5, 0.25, 0.125}, -- support2
			{-0.375, -0.1875, 0.25, 0.375, 0.5, 0.375}, -- rim1
			{-0.375, 0.375, -0.375, -0.0625, 0.5, -0.25}, -- rim2
			{0.25, -0.1875, -0.25, 0.375, 0.5, 0.25}, -- rim3
			{-0.375, -0.1875, -0.25, -0.25, 0.5, 0.25}, -- rim4
			{0.0625, 0.375, -0.375, 0.375, 0.5, -0.25}, -- rim5
			{-0.1875, 0.25, -0.5, 0.1875, 0.375, -0.375}, -- spout1
			{0.0625, 0.375, -0.5, 0.1875, 0.5, -0.375}, -- spout2
			{-0.1875, 0.375, -0.5, -0.0625, 0.5, -0.375}, -- spout3
			{-0.25, -0.3125, -0.25, 0.25, -0.1875, 0.25}, -- bottom
		}
	},

	on_punch = function(pos, node, player, pointed_thing)
		minetest.swap_node(pos, {name="workshops:crucible_tipped", param2=node.param2})
	end,
})

minetest.register_node("workshops:crucible_tipped", {
	description = S("Crucible"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_smelter = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	drop = "workshops:crucible",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.3125, -0.25, 0.375, -0.1875, 0.3125}, -- body
			{-0.5, -0.5, -0.125, -0.375, 0.25, 0.125}, -- support1
			{0.375, -0.5, -0.125, 0.5, 0.25, 0.125}, -- support2
			{-0.375, 0.3125, -0.375, 0.375, 0.4375, 0.3125}, -- rim1
			{-0.375, -0.3125, -0.375, -0.0625, -0.1875, -0.25}, -- rim2
			{0.25, -0.1875, -0.375, 0.375, 0.3125, 0.3125}, -- rim3
			{-0.375, -0.1875, -0.375, -0.25, 0.3125, 0.3125}, -- rim4
			{0.0625, -0.3125, -0.375, 0.375, -0.1875, -0.25}, -- rim5
			{-0.1875, -0.4375, -0.25, 0.1875, -0.3125, -0.125}, -- spout1
			{0.0625, -0.4375, -0.375, 0.1875, -0.3125, -0.25}, -- spout2
			{-0.1875, -0.4375, -0.375, -0.0625, -0.3125, -0.25}, -- spout3
			{-0.25, -0.1875, 0.3125, 0.25, 0.3125, 0.4375}, -- bottom
		}
	},
	
	on_punch = function(pos, node, player, pointed_thing)
		minetest.swap_node(pos, {name="workshops:crucible", param2=node.param2})
	end,
})

minetest.register_node("workshops:rock_grinder", {
	description = S("Rock Grinder"),
	tiles = {"default_furnace_top.png"},
	groups = {workshops_smelter = 1, oddly_breakable_by_hand = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.4375, -0.4375, 0.3125, 0.4375, 0.5}, -- body1
			{-0.4375, -0.3125, -0.4375, 0.4375, 0.3125, 0.5}, -- body2
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- base
			{-0.1875, 0.4375, 0.0625, 0.1875, 0.5, 0.4375}, -- inlet
			{-0.125, -0.4375, -0.5, 0.125, -0.1875, -0.4375}, -- outlet
		}
	}
})

