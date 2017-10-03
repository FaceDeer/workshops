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

simplecrafting_lib.set_disintermediation_cycles("mechanic", 2)
simplecrafting_lib.set_disintermediation_cycles("masonry", 2)

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
	return false
end

local function is_wood(item_name)
	if is_group(item_name, "wood") or is_group(item_name, "tree") or is_group(item_name, "stick") or is_group(item_name, "sapling") or raw_wood[item_name] then
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

local mechanical_mod_prefixes = {"technic:", "mesecons", "digtron:", "hopper:", "elevator:", "pipeworks:",}

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
	if is_group(item_name, "thread") or is_group(item_name, "wool") or item_name == "farming:cotton" then
		return true
	end
end

---------------------------------------------------------------------i-----------------------

local metal_melt_time = 5.0

-- The order these items are checked in allows for more "complicated" workshops to override "simpler" ones.

simplecrafting_lib.register_recipe_import_filter(function(legacy_method, recipe)
	if legacy_method == "normal" then 
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
			recycle_recipe.cooktime = metal_count * metal_melt_time
			recycle_recipe.input = {}
			for item, count in pairs(recipe.output) do
				recycle_recipe.input[item] = count
			end
			recycle_recipe.output = {[max_item] = max_count}
			recycle_recipe.returns = metal_inputs
			
			simplecrafting_lib.register("smelter", recycle_recipe)
		end
	
		-- Carpentry overrides first
		for item, count in pairs(recipe.output) do
			if carpentry_output_whitelist[item] then
				return "carpentry", true
			end
		end

		-- special handling for Digtron recycling recipes to prevent disintermediation loops
		if recipe.output["digtron:digtron_core"] and not recipe.input["default:mese_crystal_fragment"] then
			recipe.do_not_use_for_disintermediation = true
		end
		
		-- Have to do this before the mechanic test, otherwise it doesn't make it to the smelter test.
		if recipe.output["mesecons_materials:silicon"] then
			return "smelter", true
		end
		
		-- Mechanical items
		for item, count in pairs(recipe.input) do
			if is_mechanical(item) then
				return "mechanic", true
			end
		end
		for item, count in pairs(recipe.output) do
			if is_mechanical(item) then
				return "mechanic", true
			end	
		end
		
		-- Forge items
		if metal_count > 0 then
			recipe.cooktime = metal_melt_time * metal_count
			return "forge", true
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
		
		for item, count in pairs(recipe.input) do
			if is_dye(item) then
				return "dyer", true
			end
		end
		for item, count in pairs(recipe.output) do
			if is_dye(item) then
				return "dyer", true
			end
		end
		
		for item, count in pairs(recipe.input) do
			if is_fabric(item) then
				return "loom", true
			end
		end
		
		minetest.debug("Leftover normal recipe: " .. dump(recipe))
		
	end
	
	if legacy_method == "cooking" then
		-- smelter recipes
		for item, count in pairs(recipe.output) do
			if is_metal_ingot(item) then
				return "smelter", true
			end
		end
		
		-- kitchen recipes
		for item, count in pairs(recipe.output) do
			if is_cooked_food(item) then
				return "cooking", true
			end
		end
	end
	
	-- All fuel can be used for cooking.
	if legacy_method == "fuel" then
		if recipe.input["default:coal_lump"] == 1 then
			recipe.returns={["workshops:coal_ash"] = 1}
		elseif recipe.input["default:coalblock"] == 1 then
			recipe.returns={["workshops:coal_ash"] = 9}
		end
		return "cooking_fuel", false
	end
end)

-- Only coal is hot enough for smelter fuel.
simplecrafting_lib.register("smelter_fuel", {
	input={["default:coal_lump"]=1},
	burntime = 30,
	returns={["workshops:coal_ash"]=1}
})
simplecrafting_lib.register("smelter_fuel", {
	input={["default:coalblock"]=1},
	burntime = 270,
	returns={["workshops:coal_ash"]=9}
})

simplecrafting_lib.import_legacy_recipes()
