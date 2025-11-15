-- Update fuel values

if krastorio.general.getSafeSettingValue("kr-rebalance-fuels") then
  data.raw.item["plutonium-fuel"].fuel_category = "nuclear-fuel"
  data.raw.item["plutonium-fuel"].fuel_value = "2.4GJ" -- 3GJ
  data.raw.item["plutonium-fuel"].fuel_acceleration_multiplier = 1 -- 3.0
  data.raw.item["plutonium-fuel"].fuel_top_speed_multiplier = 1 -- 1.25
end

-- MOX fuel cell holds 2.5 times more energy than a uranium fuel cell but generates energy 2 times slower
data.raw.item["plutonium-fuel-cell"].fuel_value = "125GJ"
data.raw.item["MOX-fuel-cell"].fuel_value = "18.75GJ"
data.raw.item["breeder-fuel-cell"].fuel_value = "62.5GJ"

-- Add MOX to burnable fuels

data.raw["generator-equipment"]["nuclear-reactor-equipment"].burner.fuel_category = nil
data.raw["generator-equipment"]["nuclear-reactor-equipment"].burner.fuel_categories = {"nuclear","MOX"}
data.raw.locomotive["kr-nuclear-locomotive"].burner.fuel_category = nil
data.raw.locomotive["kr-nuclear-locomotive"].burner.fuel_categories = {"nuclear", "MOX"}

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
-- As of 2024-10-24 the BZ mods haven't been updated for PE v1.7, so we'll apply their changes here too
krastorio.recipes.removeIngredient("plutonium-fuel-cell", "iron-plate")
if mods["bzzirconium"] then
  krastorio.recipes.addOrReplaceIngredient("plutonium-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 1 })
  krastorio.recipes.addOrReplaceIngredient("plutonium-fuel-cell", zircaloy, { type = "item", name = zircaloy, amount = 1 })
else
  krastorio.recipes.addOrReplaceIngredient("plutonium-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 2 })
end
krastorio.recipes.replaceProduct("plutonium-fuel-cell", "plutonium-fuel-cell", { type = "item", name = "plutonium-fuel-cell", amount = 2 })

krastorio.recipes.replaceIngredient("plutonium-fuel-cell-reprocessing", "depleted-plutonium-fuel-cell", { type = "item", name = "depleted-plutonium-fuel-cell", amount = 2 })
if mods["bzchlorine"] then
  -- Uranium cell processing uses salt, so we use some here too
  krastorio.recipes.addOrReplaceIngredient("plutonium-fuel-cell-reprocessing", { type = "item", name = "salt", amount = 1 })
end
krastorio.recipes.addProduct("plutonium-fuel-cell-reprocessing", { type = "item", name = "stone", amount = 4 })
krastorio.recipes.addProduct("plutonium-fuel-cell-reprocessing", { type = "item", name = "tritium", probability = 0.15, amount = 1 })

-- MOX-fuel-cell
krastorio.recipes.removeIngredient("MOX-fuel-cell", "iron-plate")
if mods["bzzirconium"] then
  krastorio.recipes.addOrReplaceIngredient("MOX-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 1 })
  krastorio.recipes.addOrReplaceIngredient("MOX-fuel-cell", zircaloy, { type = "item", name = zircaloy, amount = 1 })
else
  krastorio.recipes.addOrReplaceIngredient("MOX-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 2 })
end
krastorio.recipes.replaceProduct("MOX-fuel-cell", "MOX-fuel-cell", { type = "item", name = "MOX-fuel-cell", amount = 4 })

krastorio.recipes.replaceIngredient("MOX-fuel-cell-reprocessing", "depleted-MOX-fuel-cell", { type = "item", name = "depleted-MOX-fuel-cell", amount = 4 })
if mods["bzchlorine"] then
  -- Uranium cell processing uses salt, so we use some here too
  krastorio.recipes.addOrReplaceIngredient("MOX-fuel-cell-reprocessing", { type = "item", name = "salt", amount = 1 })
end
krastorio.recipes.addProduct("MOX-fuel-cell-reprocessing", { type = "item", name = "stone", amount = 4 })
krastorio.recipes.addProduct("MOX-fuel-cell-reprocessing", { type = "item", name = "tritium", probability = 0.15, amount = 1 })

-- breeder-fuel-cell
if mods["bzzirconium"] then
  krastorio.recipes.addOrReplaceIngredient("breeder-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 2 })
  krastorio.recipes.addOrReplaceIngredient("breeder-fuel-cell", zircaloy, { type = "item", name = zircaloy, amount = 1 })
else
  krastorio.recipes.addOrReplaceIngredient("breeder-fuel-cell", fuel_cell_plate_from, { type = "item", name = fuel_cell_plate_to, amount = 4 })
end
-- Original result count is 2 which can't be divided by 5 so we multiply the ingredients by 5 instead
for _, ingredient in pairs(krastorio.recipes.getIngredients("breeder-fuel-cell")) do
  krastorio.recipes.multiplyIngredient("breeder-fuel-cell", krastorio.recipes.getIngredientName(ingredient), 5)
end

krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-uranium-cell", "iron-plate", { type = "item", name = fuel_cell_plate_to, amount = 4 })
krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-uranium-cell", "used-up-uranium-fuel-cell", { type = "item", name = "used-up-uranium-fuel-cell", amount = 2 })
-- Original result count is 4 which can't be divided by 5 so we multiply the ingredients by 5 instead
for _, ingredient in pairs(krastorio.recipes.getIngredients("breeder-fuel-cell-from-uranium-cell")) do
  krastorio.recipes.multiplyIngredient("breeder-fuel-cell-from-uranium-cell", krastorio.recipes.getIngredientName(ingredient), 5)
end

krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-MOX-fuel-cell", "iron-plate", { type = "item", name = fuel_cell_plate_to, amount = 2 })
krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-MOX-fuel-cell", "depleted-MOX-fuel-cell", { type = "item", name = "depleted-MOX-fuel-cell", amount = 1 })
-- Original result count is 2 which can't be divided by 5 so we multiply the ingredients by 5 instead
for _, ingredient in pairs(krastorio.recipes.getIngredients("breeder-fuel-cell-from-MOX-fuel-cell")) do
  krastorio.recipes.multiplyIngredient("breeder-fuel-cell-from-MOX-fuel-cell", krastorio.recipes.getIngredientName(ingredient), 5)
end

krastorio.recipes.replaceIngredient(
  "uranium-fuel-cell-waste-solution-centrifuging",
  "uranium-fuel-cell-waste-solution-barrel",
  { "uranium-fuel-cell-waste-solution-barrel", 2 }
)
krastorio.recipes.replaceProduct("uranium-fuel-cell-waste-solution-centrifuging", "empty-barrel", { type = "item", name = "empty-barrel", amount = 2, catalyst_amount = 2 })

krastorio.recipes.replaceIngredient(
  "breeder-fuel-cell-waste-solution-centrifuging",
  "breeder-fuel-cell-waste-solution-barrel",
  { "breeder-fuel-cell-waste-solution-barrel", 2 }
)
krastorio.recipes.replaceProduct("breeder-fuel-cell-waste-solution-centrifuging", "empty-barrel", { type = "item", name = "empty-barrel", amount = 2, catalyst_amount = 2 })

-- Copy the nuclear reactor recipe for the MOX and breeder reactors, with respectively 40% and 200% of the ingredient amount

-- The BZ mods from BrassTacks, IfNickel, bzcarbon, bztungsten and bzzirconium also add ingredients to the recipe if enabled,
-- so we can easily make sure they are added here too by having them as optional dependencies and copying the recipe only after they are all processed

local nuclear_reactor_ingredients = krastorio.recipes.getIngredients("nuclear-reactor")

data.raw.recipe["MOX-reactor"].energy_required = 120
data.raw.recipe["MOX-reactor"].category = "crafting-with-fluid"
krastorio.recipes.overrideIngredients("MOX-reactor", nuclear_reactor_ingredients)
for _, ingredient in pairs(nuclear_reactor_ingredients) do
  krastorio.recipes.multiplyIngredient("MOX-reactor", krastorio.recipes.getIngredientName(ingredient), 0.4)
end

if not mods["RealisticReactors"] then
  data.raw.recipe["breeder-reactor"].energy_required = 120
  data.raw.recipe["breeder-reactor"].category = "crafting-with-fluid"
  krastorio.recipes.overrideIngredients("breeder-reactor", nuclear_reactor_ingredients)
  for _, ingredient in pairs(nuclear_reactor_ingredients) do
    krastorio.recipes.multiplyIngredient("breeder-reactor", krastorio.recipes.getIngredientName(ingredient), 2)
  end
end

-- Update stack sizes

local kr_stack_size_value = krastorio.general.getSafeSettingValue("kr-stack-size")
if kr_stack_size_value and kr_stack_size_value ~= "No changes" then
  kr_stack_size_value = tonumber(kr_stack_size_value)

  data.raw.item["plutonium-238"].stack_size = kr_stack_size_value
  data.raw.item["plutonium-239"].stack_size = kr_stack_size_value

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
end

-- Update technologies, trying to follow the nuclear tech rebalancing by K2

krastorio.technologies.setResearchUnitCount("plutonium-processing", 3750)
krastorio.technologies.setResearchUnitCount("plutonium-nuclear-power", 500)
krastorio.technologies.setResearchUnitCount("MOX-nuclear-power", 300)
krastorio.technologies.setResearchUnitCount("plutonium-reprocessing", 2500)
krastorio.technologies.setResearchUnitCount("nuclear-breeding", 5000)
krastorio.technologies.setResearchUnitCount("breeder-fuel-cell-from-uranium-cell", 2500)
krastorio.technologies.setResearchUnitCount("breeder-fuel-cell-from-MOX-fuel-cell", 2500)

-- Ammo fixes

require "data-final-fixes-ammo"
