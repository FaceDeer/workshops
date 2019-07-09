local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

simplecrafting_lib.set_description("smelter", S("Smelter"))
simplecrafting_lib.set_description("carpentry", S("Carpentry"))
simplecrafting_lib.set_description("mechanic", S("Mechanisms"))
simplecrafting_lib.set_description("forge", S("Forge"))
simplecrafting_lib.set_description("masonry", S("Masonry"))
simplecrafting_lib.set_description("dyer", S("Dying"))
simplecrafting_lib.set_description("loom", S("Fabrics"))
simplecrafting_lib.set_description("cooking", S("Cooking"))

simplecrafting_lib.set_disintermediation_cycles("mechanic", 1)
simplecrafting_lib.set_disintermediation_cycles("masonry", 1)
simplecrafting_lib.set_disintermediation_cycles("dyer", 1)
simplecrafting_lib.set_disintermediation_cycles("carpentry", 1)

local has_prefix = function(str, prefix)
	return str:sub(1, string.len(prefix)) == prefix
end
local has_suffix = function(str, suffix)
	return str:sub(-string.len(suffix)) == suffix
end
local function is_group(item_name, group)
	if minetest.get_item_group(item_name, group) > 0 then return true end
	if has_prefix(item_name, "group:") then
		local groupname = string.sub(item_name, string.len("group:")+1)
		for v in string.gmatch(groupname, "[^, ]+") do -- need to account for commas due to dye-type recipes
			if v == group then return true end
		end	
	end
	return false
end

-- Doesn't include entries that already belong to group "stone" in default.
local raw_stone = 
{
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
	["default:brick"] = true,
	["default:clay_brick"] = true,
}

-- doesn't include entries already in wood-related groups
local raw_wood = 
{
	["default:cactus"] = true,
	["default:dry_shrub"] = true,
	["default:bush_stem"] = true,
	["default:acacia_bush_stem"] = true,
}

local carpentry_output_whitelist =
{
	["default:chest_locked"] = true,
}

local metal_ingots =
{
	['default:steel_ingot'] = true,
	['default:copper_ingot'] = true,
	['default:bronze_ingot'] = true,
	["default:gold_ingot"] = true,
	["default:tin_ingot"] = true,
	['moreores:mithril_ingot'] = true,
	['moreores:tin_ingot'] = true,
	['moreores:silver_ingot'] = true,
	["technic:cast_iron_ingot"] = true,
	["technic:stainless_steel_ingot"] = true,
	["metals:pig_iron_ingot"] = true,
	["metals:wrought_iron_ingot"] = true,
	["metals:steel_ingot"] = true,
	["mesecons_materials:silicon"] = true, -- not exactly an ingot, but should be a smelter product
}

local metal_blocks = 
{
	['default:steelblock'] = true,
	['default:copperblock'] = true,
	['default:goldblock'] = true,
	['default:bronzeblock'] = true,
}

local cooked_food_items =
{
	["farming:bread"] = true,
	["hemp:cooked_seed_hemp"] = true,
	["farming:cake"] = true,
}

local function is_stone(item_name)
	if is_group(item_name, "stone") or raw_stone[item_name] then
		return true
	end
	if has_prefix(item_name, "castle_masonry:") then
		return true
	end
	if has_prefix(item_name, "castle_gates:") and item_name:find("gate_slot") then
		return true
	end
	if has_prefix(item_name, "moreblocks:") and item_name:find("cobble") then
		return true
	end
	if has_prefix(item_name, "hemp:hempcrete") then
		return true
	end
	return false
end

local function is_wood(item_name)
	if is_group(item_name, "wood") or is_group(item_name, "tree") or is_group(item_name, "stick") or is_group(item_name, "sapling") or raw_wood[item_name] then
		return true
	end
	if has_prefix(item_name, "moreblocks:") and (item_name:find("wood") or item_name:find("cactus")) then
		return true
	end
	return false
end

local function is_metal_ingot(item_name)
	if is_group(item_name, "metal_ingot") or metal_ingots[item_name] then
		return true
	end
	return false
end

local function is_cooked_food(item_name)
	if is_group(item_name, "food") or cooked_food_items[item_name] then
		return true
	end
	if has_suffix(item_name, "_pie_cooked") then
		return true
	end
end

local mechanical_mod_prefixes = {"technic:", "mesecons", "digtron:", "hopper:", "elevator:", "pipeworks:", "tnt:",}

local function is_mechanical(item_name)
	for _, mod in pairs(mechanical_mod_prefixes) do
		if has_prefix(item_name, mod) then
			return true
		end
	end
end

local function is_dye(item_name)
	if is_group(item_name, "dye") then
		return true
	end
end

local function is_fabric(item_name)
	if is_group(item_name, "thread") or is_group(item_name, "wool") or item_name == "farming:cotton" or has_prefix(item_name, "hemp:") then
		return true
	end
end

---------------------------------------------------------------------i-----------------------

local metal_melt_time = 5.0

-- The order these items are checked in allows for more "complicated" workshops to override "simpler" ones.

simplecrafting_lib.register_recipe_import_filter(function(recipe)
	local output_name = ItemStack(recipe.output):get_name()
	
	if recipe.input["simplecrafting_lib:heat"] then
		-- smelter recipes
		if is_metal_ingot(output_name) or output_name == "default:glass" or output_name == "default:obsidian_glass" then
			return "smelter", true
		end
		
		-- kitchen recipes
		if is_cooked_food(output_name) then
			return "cooking", true
		end
		
		-- There's some mesecons recipes in the furnace
		if is_mechanical(output_name) then
			return "forge", true
		end		
	elseif output_name == "simplecrafting_lib:heat" then
		if recipe.input["default:coal_lump"] == 1 then
			recipe.returns={["workshops:coal_ash"] = 1}
		elseif recipe.input["default:coalblock"] == 1 then
			recipe.returns={["workshops:coal_ash"] = 9}
		end
		return "cooking_fuel", false
	else
		-- Create "recycling" recipes that allow smelters to melt down items that
		-- were made from metal ingots, recovering the metal ingots
		local metal_inputs = {}
		local metal_count = 0
		
		for item, count in pairs(recipe.input) do
			if is_metal_ingot(item) then
				metal_count = metal_count + 1
				metal_inputs[item] = count
			end
		end
		if metal_count > 0 then
			local max_item
			local max_count = 0
			for item, count in pairs(metal_inputs) do
				if count > max_count then
					max_count = count
					max_item = item
				end
			end
			metal_inputs[max_item] = nil
			local recycle_recipe = {}
			recycle_recipe.input = {}
			recycle_recipe.input["simplecrafting_lib:heat"] = metal_count * metal_melt_time
			recycle_recipe.input[output_name] = recipe.output:get_count()
			recycle_recipe.output = ItemStack(max_item .. " " .. tostring(max_count))
			recycle_recipe.returns = metal_inputs
			
			simplecrafting_lib.register("smelter", recycle_recipe)
		end
		
		-- There are a few non-cooking recycling recipes already, such as breaking down metal blocks.
		-- Eliminate these.
		for in_item, in_count in pairs(recipe.input) do
			if metal_blocks[in_item] then
				if is_metal_ingot(output_name) then
					return nil, true
				end
			end
		end
	
		-- Carpentry overrides first
		if carpentry_output_whitelist[output_name] then
			return "carpentry", true
		end

		-- special handling for Digtron recycling recipes to prevent disintermediation loops
		if output_name == "digtron:digtron_core" and not recipe.input["default:mese_crystal_fragment"] then
			recipe.do_not_use_for_disintermediation = true
		end
		
		-- Have to do this before the mechanic test, otherwise it doesn't make it to the smelter test.
		if output_name == "mesecons_materials:silicon" then
			return "smelter", true
		end
		
		if output_name == "default:obsidian" then
			return "smelter", true
		end
		
		-- not ideal, but will do for now.
		if has_prefix(output_name, "ropes:") then
			return "loom", true
		end
		
		-- Mechanical items
		for item, count in pairs(recipe.input) do
			if is_mechanical(item) then
				return "mechanic", true
			end
		end
		if is_mechanical(output_name) then
			return "mechanic", true
		end
		
		-- Forge items
		if metal_count > 0 then
			minetest.debug(dump(recipe))
			recipe.input["simplecrafting_lib:heat"] = metal_melt_time * metal_count
			return "forge", true
		end
		for item, count in pairs(recipe.input) do
			if metal_blocks[item] then
				return "forge", true
			end
		end
		
		-- Masonry items
		for item, count in pairs(recipe.input) do
			if is_stone(item) then
				return "masonry", true
			end
		end
		
		-- Carpentry items
		for item, count in pairs(recipe.input) do
			if is_wood(item) then
				return "carpentry", true
			end
		end
		
		--Dying
		for item, count in pairs(recipe.input) do
			if is_dye(item) then
				return "dyer", true
			end
		end
		if is_dye(output_name) then
			return "dyer", true
		end
		
		--Loom
		for item, count in pairs(recipe.input) do
			if is_fabric(item) then
				return "loom", true
			end			
		end

		-- also put glass recipes in the smelter for now.
		for item, count in pairs(recipe.input) do
			if item == "default:glass" or item == "default:obsidian_glass" then
				return "smelter", true
			end
		end
		
		-- Any remaining oddballs
		if output_name == "homedecor:oil_extract" then
			return "cooking", true
		end
		
		--minetest.debug("Leftover normal recipe: " .. dump(recipe))
		
	end
end)

-- Only coal is hot enough for smelter fuel.
simplecrafting_lib.register("smelter_fuel", {
	input={["default:coal_lump"]=1},
	output= "simplecrafting_lib:heat 30",
	returns={["workshops:coal_ash"]=1}
})
simplecrafting_lib.register("smelter_fuel", {
	input={["default:coalblock"]=1},
	output= "simplecrafting_lib:heat 270",
	returns={["workshops:coal_ash"]=9}
})