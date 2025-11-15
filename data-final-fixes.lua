local data_util = require("__Krastorio2__/data-util")

-- Update fuel values

if not settings.startup['enable-plutonium-fuel'].value then
  data.raw.item["plutonium-fuel"].hidden = true
  data.raw.recipe["plutonium-fuel"].hidden = true
  data_util.remove_recipe_unlock("nuclear-breeding", "plutonium-fuel")
end

data.raw.item["plutonium-fuel"].fuel_value = "2.4GJ" -- 3GJ
data.raw.item["plutonium-fuel"].fuel_acceleration_multiplier = 1 -- 3.0
data.raw.item["plutonium-fuel"].fuel_top_speed_multiplier = 1 -- 1.25

-- MOX fuel cell holds 2.5 times more energy than a uranium fuel cell but generates energy 2 times slower
data.raw.item["plutonium-fuel-cell"].fuel_value = "125GJ"
data.raw.item["MOX-fuel-cell"].fuel_value = "18.75GJ"
data.raw.item["breeder-fuel-cell"].fuel_value = "62.5GJ"

-- Add MOX to burnable fuels

table.insert(data.raw["generator-equipment"]["fission-reactor-equipment"].burner.fuel_categories, "MOX")
data_util.add_fuel_category(data.raw.locomotive["kr-nuclear-locomotive"].energy_source, "MOX")

-- Update reactor stats

data.raw.reactor["MOX-reactor"].consumption = "125MW"
data.raw.reactor["MOX-reactor"].heat_buffer.max_transfer = "50GW"
data.raw.reactor["MOX-reactor"].heat_buffer.specific_heat = "50MJ"
data.raw.reactor["MOX-reactor"].max_health = data.raw.reactor["MOX-reactor"].max_health * 2
data.raw.reactor["MOX-reactor"].meltdown_action = data.raw.reactor['nuclear-reactor'].meltdown_action
data.raw.reactor["MOX-reactor"].minable = { hardness = 1, mining_time = 1, result = "MOX-reactor" }
-- K2 changes the nuclear reactor neighbour bonus from 100% to 25%
data.raw.reactor["MOX-reactor"].neighbour_bonus = data.raw.reactor["MOX-reactor"].neighbour_bonus / 4

if not mods["RealisticReactors"] then
  data.raw.reactor["breeder-reactor"].consumption = "125MW"
  data.raw.reactor["breeder-reactor"].heat_buffer.max_transfer = "50GW"
  data.raw.reactor["breeder-reactor"].heat_buffer.specific_heat = "100MJ"
  data.raw.reactor["breeder-reactor"].max_health = data.raw.reactor["breeder-reactor"].max_health * 2
  data.raw.reactor["breeder-reactor"].meltdown_action = data.raw.reactor['nuclear-reactor'].meltdown_action
  data.raw.reactor["breeder-reactor"].minable = { hardness = 1, mining_time = 1, result = "breeder-reactor" }
  -- K2 changes the nuclear reactor neighbour bonus from 100% to 25%
  data.raw.reactor["breeder-reactor"].neighbour_bonus = data.raw.reactor["breeder-reactor"].neighbour_bonus / 4
end

-- Update recipes
--
-- Fuel cells are more energy-rich in K2, and reprocessing uses 1 cell instead of 5 for the same amount of resources.
-- So we can keep the recipes balanced by dividing the number of fuel cells produced or consumed by 5.

-- If enabled, the BZ mods also use lead plates instead of steel, and replace half of it with zircaloy
-- Also 1 fuel cell = 1 steel/lead/zircaloy plate
local fuel_cell_plate_from = mods["bzlead"] and "lead-plate" or "iron-plate"
local fuel_cell_plate_to = mods["bzlead"] and "lead-plate" or "steel-plate"
local zircaloy = data.raw.item["zircaloy-4"] and "zircaloy-4" or "zirconium-plate"

-- plutonium-fuel-cell
data_util.remove_ingredient("plutonium-fuel-cell", "iron-plate")
if mods["bzzirconium"] then
  data_util.replace_and_overwrite_or_add_ingredient("plutonium-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 1 })
  data_util.overwrite_or_add_ingredient("plutonium-fuel-cell", { type = "item", name = zircaloy, amount = 1 })
else
  data_util.replace_and_overwrite_or_add_ingredient("plutonium-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 2 })
end
data_util.overwrite_or_add_product("plutonium-fuel-cell", { type = "item", name = "plutonium-fuel-cell", amount = 2 })

data_util.overwrite_or_add_ingredient("plutonium-fuel-cell-reprocessing", { type = "item", name = "depleted-plutonium-fuel-cell", amount = 2 })
if mods["bzchlorine"] then
  -- Uranium cell processing uses salt, so we use some here too
  data_util.overwrite_or_add_ingredient("plutonium-fuel-cell-reprocessing", { type = "item", name = "salt", amount = 1 })
end
data_util.overwrite_or_add_product("plutonium-fuel-cell-reprocessing", { type = "item", name = "stone", amount = 4 })
data_util.overwrite_or_add_product("plutonium-fuel-cell-reprocessing", { type = "item", name = "kr-tritium", probability = 0.15, amount = 1 })

-- MOX-fuel-cell
if mods["bzzirconium"] then
  data_util.replace_and_overwrite_or_add_ingredient("MOX-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 1 })
  data_util.overwrite_or_add_ingredient("MOX-fuel-cell", { type = "item", name = zircaloy, amount = 1 })
else
  data_util.replace_and_overwrite_or_add_ingredient("MOX-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 2 })
end
data_util.overwrite_or_add_product("MOX-fuel-cell", { type = "item", name = "MOX-fuel-cell", amount = 4 })

data_util.overwrite_or_add_ingredient("MOX-fuel-cell-reprocessing", { type = "item", name = "depleted-MOX-fuel-cell", amount = 4 })
if mods["bzchlorine"] then
  -- Uranium cell processing uses salt, so we use some here too
  data_util.overwrite_or_add_ingredient("MOX-fuel-cell-reprocessing", { type = "item", name = "salt", amount = 1 })
end
data_util.overwrite_or_add_product("MOX-fuel-cell-reprocessing", { type = "item", name = "stone", amount = 4 })
data_util.overwrite_or_add_product("MOX-fuel-cell-reprocessing", { type = "item", name = "kr-tritium", probability = 0.15, amount = 1 })

-- breeder-fuel-cell
if mods["bzzirconium"] then
  data_util.replace_and_overwrite_or_add_ingredient("breeder-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 2 })
  data_util.overwrite_or_add_ingredient("breeder-fuel-cell", { type = "item", name = zircaloy, amount = 1 })
else
  data_util.replace_and_overwrite_or_add_ingredient("breeder-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 4 })
end
-- Original result count is 2 which can't be divided by 5 so we multiply the ingredients by 5 instead
for _, ingredient in pairs(data.raw.recipe["breeder-fuel-cell"].ingredients) do
  ingredient.amount = ingredient.amount * 5
end

data_util.replace_and_overwrite_or_add_ingredient("breeder-fuel-cell-from-uranium-cell", "iron-plate", { type = "item", name = fuel_cell_plate_to, amount = 4 })
data_util.overwrite_or_add_ingredient("breeder-fuel-cell-from-uranium-cell", { type = "item", name = "depleted-uranium-fuel-cell", amount = 2 })
-- Original result count is 4 which can't be divided by 5 so we multiply the ingredients by 5 instead
for _, ingredient in pairs(data.raw.recipe["breeder-fuel-cell-from-uranium-cell"].ingredients) do
  ingredient.amount = ingredient.amount * 5
end

data_util.replace_and_overwrite_or_add_ingredient("breeder-fuel-cell-from-MOX-fuel-cell", "iron-plate", { type = "item", name = fuel_cell_plate_to, amount = 2 })
data_util.overwrite_or_add_ingredient("breeder-fuel-cell-from-MOX-fuel-cell", { type = "item", name = "depleted-MOX-fuel-cell", amount = 1 })
-- Original result count is 2 which can't be divided by 5 so we multiply the ingredients by 5 instead
for _, ingredient in pairs(data.raw.recipe["breeder-fuel-cell-from-MOX-fuel-cell"].ingredients) do
  ingredient.amount = ingredient.amount * 5
end

data_util.overwrite_or_add_ingredient(
  "uranium-fuel-cell-waste-solution-centrifuging",
  { type = "item", name = "uranium-fuel-cell-waste-solution-barrel", amount = 2 }
)
data_util.overwrite_or_add_product("uranium-fuel-cell-waste-solution-centrifuging", { type = "item", name = "barrel", amount = 2, ignored_by_productivity = 2 })

data_util.overwrite_or_add_ingredient(
  "breeder-fuel-cell-waste-solution-centrifuging",
  { type = "item", name = "breeder-fuel-cell-waste-solution-barrel", amount = 2 }
)
data_util.overwrite_or_add_product("breeder-fuel-cell-waste-solution-centrifuging", { type = "item", name = "barrel", amount = 2, ignored_by_productivity = 2 })

-- Copy the nuclear reactor recipe for the MOX and breeder reactors, with respectively 40% and 200% of the ingredient amount

-- The BZ mods from BrassTacks, IfNickel, bzcarbon, bztungsten and bzzirconium also add ingredients to the recipe if enabled,
-- so we can easily make sure they are added here too by having them as optional dependencies and copying the recipe only after they are all processed

data.raw.recipe["MOX-reactor"].energy_required = 120
data.raw.recipe["MOX-reactor"].category = "crafting-with-fluid"
data.raw.recipe["MOX-reactor"].ingredients = table.deepcopy(data.raw.recipe["nuclear-reactor"].ingredients)
for _, ingredient in pairs(data.raw.recipe["MOX-reactor"].ingredients) do
  ingredient.amount = ingredient.amount * 0.4
end

if not mods["RealisticReactors"] then
  data.raw.recipe["breeder-reactor"].energy_required = 120
  data.raw.recipe["breeder-reactor"].category = "crafting-with-fluid"
  data.raw.recipe["breeder-reactor"].ingredients = table.deepcopy(data.raw.recipe["nuclear-reactor"].ingredients)
  for _, ingredient in pairs(data.raw.recipe["breeder-reactor"].ingredients) do
    ingredient.amount = ingredient.amount * 2
  end
end

-- Update stack sizes

data.raw.item["plutonium-238"].stack_size = 200
data.raw.item["plutonium-239"].stack_size = 200

data.raw.item["MOX-fuel-cell"].stack_size = 20
data.raw.item["breeder-fuel-cell"].stack_size = 1
data.raw.item["plutonium-fuel-cell"].stack_size = 10
data.raw.item["depleted-MOX-fuel-cell"].stack_size = 20
data.raw.item["depleted-breeder-fuel-cell"].stack_size = 1
data.raw.item["depleted-plutonium-fuel-cell"].stack_size = 10

data.raw.item["MOX-reactor"].stack_size = 1
if not mods["RealisticReactors"] then
  data.raw.item["breeder-reactor"].stack_size = 1
end

-- Update technologies, trying to follow the nuclear tech rebalancing by K2

data.raw.technology["plutonium-processing"].unit.count = 3750
data.raw.technology["plutonium-nuclear-power"].unit.count = 500
data.raw.technology["MOX-nuclear-power"].unit.count = 300
data.raw.technology["plutonium-reprocessing"].unit.count = 2500
data.raw.technology["nuclear-breeding"].unit.count = 5000
data.raw.technology["breeder-fuel-cell-from-uranium-cell"].unit.count = 2500
data.raw.technology["breeder-fuel-cell-from-MOX-fuel-cell"].unit.count = 2500

-- Ammo fixes

require "data-final-fixes-ammo"
