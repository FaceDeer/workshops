local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local function get_formspec()
	return table.concat({
		"size[10,9.2]",
		default.gui_bg,
		default.gui_bg_img,
		default.gui_slots,

		"list[context;input;0,0.25;4,2;]",
		"list[context;fuel;0,2.75;4,2]",
		
		"image[4.5,0.7;1,1;gui_furnace_arrow_bg.png^[transformR270]",
		"list[context;target;4.5,2;1,1;]",
		"image[4.5,3.3;1,1;default_furnace_fire_bg.png]",

		"list[context;output;6,0.25;4,2;]",
		"list[context;products;6,2.75;4,2;]",

		"list[current_player;main;1,5;8,1;0]",
		"list[current_player;main;1,6.2;8,3;8]",
	})
end

local function refresh_output(inv)
	local craftable = crafting.get_craftable_items("smelter", inv:get_list("input"))
	inv:set_list("products", craftable)
end


local function smelter_timer(pos, elapsed)
	local meta = minetest.get_meta(pos)
	
	local cook_time = meta:get_float("cook_time") or 0
	local burn_time = meta:get_float("burn_time") or 0

	burn_time = burn_time - elapsed
	cook_time = cook_time + elapsed
	
	local inv = meta:get_inventory()
	
	local recipe
	if not inv:is_empty("target") then
		recipe = crafting.get_crafting_result("smelter", inv:get_list("input"), inv:get_stack("target", 1))
	end
	
	if recipe == nil then
		-- we're not cooking anything.
		cook_time = 0
	else
		if cook_time >= recipe.time then
			-- produce product
			-- check if we can make more. Loop?
			cook_time = cook_time - recipe.time
		end
	end
	
	
	
	
	minetest.debug(dump(recipe))

	
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	if listname == "input" then
		if crafting.is_possible_input("smelter", stack:get_name()) then
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "fuel" then
		if crafting.is_fuel(stack:get_name()) then
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "target" then
		if crafting.is_possible_output("smelter", stack:get_name()) then
			--place an imaginary item into the target slot
			local inv = minetest.get_inventory({type="node", pos=pos})
			inv:set_stack(listname, index, stack:take_item(1))
			smelter_timer(pos, 0)
		end
		return 0
	elseif listname == "products" or listname == "output" then
		-- not allowed to put items into the products display
		return 0
	end
	return stack:get_count()
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	if listname == "target" then
		--delete the imaginary item from the target slot
		local inv = minetest.get_inventory({type="node", pos=pos})
		inv:set_stack(listname, index, ItemStack(""))
		return 0
	elseif listname == "products" then
		-- not allowed to take products directly from the products display
		return 0		
	end
	return stack:get_count()
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return math.min(allow_metadata_inventory_put(pos, to_list, to_index, stack, player), 
		allow_metadata_inventory_take(pos, from_list, from_index, stack, player))
end

minetest.register_node("workshops:smelter", {
	description = S("Smelter"),
	drawtype = "normal",
	tiles = {
		"default_furnace_top.png", "default_furnace_bottom.png",
		"default_furnace_side.png", "default_furnace_side.png",
		"default_furnace_side.png", "default_furnace_front.png"
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 1, cracky=3},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("input", 2*4) -- materials that can be processed to outputs
		inv:set_size("fuel", 2*4) -- materials that can be burned for fuel
		inv:set_size("target", 1) -- Item to actually make from the inputs
		inv:set_size("products", 2*4) -- potential products from the given inputs
		inv:set_size("output", 2*4) -- holds output product
		meta:set_string("formspec", get_formspec())
	end,
	
	allow_metadata_inventory_put = allow_metadata_inventory_put,	
	allow_metadata_inventory_take = allow_metadata_inventory_take,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	
	on_metadata_inventory_move = function(pos, flist, fi, tlist, ti, no, player)
		local meta = minetest.get_meta(pos)
	end,

	on_metadata_inventory_take = function(pos, lname, i, stack, player)
		local meta = minetest.get_meta(pos)
		if lname == "input" then
			refresh_output(meta:get_inventory())
		end
	end,

	on_metadata_inventory_put = function(pos, lname, i, stack, player)
		local meta = minetest.get_meta(pos)
		if lname == "input" then
			refresh_output(meta:get_inventory())
		end
		smelter_timer(pos, 0)
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("output") and inv:is_empty("fuel") and inv:is_empty("input")
	end,
	
	on_timer = smelter_timer,
})

