-- Update but disable plutonium fuel
-- K2 disables the nuclear-fuel tech, so plutonium-fuel is never unlocked either

data.raw.item["plutonium-fuel"].fuel_category = "nuclear-fuel"
data.raw.item["plutonium-fuel"].fuel_value = "2GJ" --2.24
data.raw.item["plutonium-fuel"].fuel_acceleration_multiplier = 1 --1.75
data.raw.item["plutonium-fuel"].fuel_top_speed_multiplier = 1 --1.075

-- Update fuel values
-- MOX fuel cell holds 2.5 times more energy than a uranium fuel cell but generates energy 2 times slower

data.raw.item["MOX-fuel"].fuel_value = "125GJ"
data.raw.item["breeder-fuel-cell"].fuel_value = "31.25GJ"

-- Add MOX to burnable fuels

data.raw["generator-equipment"]["nuclear-reactor-equipment"].burner.fuel_category = nil
data.raw["generator-equipment"]["nuclear-reactor-equipment"].burner.fuel_categories = {"nuclear","MOX"}
data.raw.locomotive["kr-nuclear-locomotive"].burner.fuel_category = nil
data.raw.locomotive["kr-nuclear-locomotive"].burner.fuel_categories = { "nuclear", "MOX" }

-- Update reactor stats

data.raw.reactor["MOX-reactor"].consumption = "125MW"
data.raw.reactor["MOX-reactor"].heat_buffer.max_transfer = "25GW"
data.raw.reactor["MOX-reactor"].heat_buffer.specific_heat = "25MJ"
data.raw.reactor["MOX-reactor"].max_health = 800
data.raw.reactor["MOX-reactor"].meltdown_action = data.raw.reactor['nuclear-reactor'].meltdown_action
data.raw.reactor["MOX-reactor"].minable = { hardness = 1, mining_time = 1, result = "MOX-reactor" }
data.raw.reactor["MOX-reactor"].neighbour_bonus = 0.25

if not mods["RealisticReactors"] then
  data.raw.reactor["breeder-reactor"].consumption = "31.25MW"
  data.raw.reactor["breeder-reactor"].heat_buffer.max_transfer = "6.25GW"
  data.raw.reactor["breeder-reactor"].heat_buffer.specific_heat = "6.25MJ"
  data.raw.reactor["breeder-reactor"].max_health = 1500
  data.raw.reactor["breeder-reactor"].meltdown_action = data.raw.reactor['nuclear-reactor'].meltdown_action
  data.raw.reactor["breeder-reactor"].minable = { hardness = 1, mining_time = 1, result = "breeder-reactor" }
  data.raw.reactor["breeder-reactor"].neighbour_bonus = 0.25
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

if mods["bzzirconium"] then
  krastorio.recipes.replaceIngredient("MOX-fuel", fuel_cell_plate_from, { fuel_cell_plate_to, 1 })
  krastorio.recipes.replaceIngredient("MOX-fuel", zircaloy, { zircaloy, 1 })
else
  krastorio.recipes.replaceIngredient("MOX-fuel", fuel_cell_plate_from, { fuel_cell_plate_to, 2 })
end
krastorio.recipes.replaceProduct("MOX-fuel", "MOX-fuel", { "MOX-fuel", 2 })

krastorio.recipes.replaceIngredient("MOX-fuel-reprocessing", "used-up-MOX-fuel", { "used-up-MOX-fuel", 2 })
if mods["bzchlorine"] then
  -- Uranium cell processing uses salt, so we use some here too
  krastorio.recipes.addIngredient("MOX-fuel-reprocessing", { "salt", 1 })
end
krastorio.recipes.addProduct("MOX-fuel-reprocessing", { "stone", 4 })
krastorio.recipes.addProduct("MOX-fuel-reprocessing", { type = "item", name = "tritium", probability = 0.15, amount = 1 })

if mods["bzzirconium"] then
  krastorio.recipes.replaceIngredient("breeder-fuel-cell", fuel_cell_plate_from, { fuel_cell_plate_to, 1 })
  krastorio.recipes.replaceIngredient("breeder-fuel-cell", zircaloy, { zircaloy, 1 })
else
  krastorio.recipes.replaceIngredient("breeder-fuel-cell", fuel_cell_plate_from, { fuel_cell_plate_to, 2 })
end
krastorio.recipes.replaceProduct("breeder-fuel-cell", "breeder-fuel-cell", { "breeder-fuel-cell", 1 })

krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-uranium-cell", "iron-plate", { fuel_cell_plate_to, 2 })
krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-uranium-cell", "used-up-uranium-fuel-cell", { "used-up-uranium-fuel-cell", 2 })
krastorio.recipes.replaceProduct("breeder-fuel-cell-from-uranium-cell", "breeder-fuel-cell", { "breeder-fuel-cell", 2 })

krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-MOX-fuel", "iron-plate", { fuel_cell_plate_to, 1 })
krastorio.recipes.replaceIngredient("breeder-fuel-cell-from-MOX-fuel", "used-up-MOX-fuel", { "used-up-MOX-fuel", 1 })
krastorio.recipes.replaceProduct("breeder-fuel-cell-from-MOX-fuel", "breeder-fuel-cell", { "breeder-fuel-cell", 1 })

krastorio.recipes.replaceIngredient(
  "used-up-uranium-fuel-cell-solution-centrifuging",
  "used-up-uranium-fuel-cell-solution-barrel",
  { "used-up-uranium-fuel-cell-solution-barrel", 2 }
)
krastorio.recipes.replaceProduct("used-up-uranium-fuel-cell-solution-centrifuging", "empty-barrel", { type = "item", name = "empty-barrel", amount = 2, catalyst_amount = 2 })

krastorio.recipes.replaceIngredient(
  "used-up-breeder-fuel-cell-solution-centrifuging",
  "used-up-breeder-fuel-cell-solution-barrel",
  { "used-up-breeder-fuel-cell-solution-barrel", 2 }
)
krastorio.recipes.replaceProduct("used-up-breeder-fuel-cell-solution-centrifuging", "empty-barrel", { type = "item", name = "empty-barrel", amount = 2, catalyst_amount = 2 })

-- Copy the nuclear reactor recipe for the MOX and breeder reactors, with respectively 80% and 200% of the ingredient amount

-- The BZ mods from BrassTacks, IfNickel, bzcarbon, bztungsten and bzzirconium also add ingredients to the recipe if enabled,
-- so we can easily make sure they are added here too by having them as optional dependencies and copying the recipe only after they are all processed

local nuclear_reactor_ingredients = krastorio.recipes.getIngredients("nuclear-reactor")

data.raw.recipe["MOX-reactor"].energy_required = 120
data.raw.recipe["MOX-reactor"].category = "crafting-with-fluid"
krastorio.recipes.overrideIngredients("MOX-reactor", nuclear_reactor_ingredients)
for _, ingredient in pairs(nuclear_reactor_ingredients) do
  krastorio.recipes.multiplyIngredient("MOX-reactor", krastorio.recipes.getIngredientName(ingredient), 0.8)
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

  data.raw.item["MOX-fuel"].stack_size = 10
  data.raw.item["breeder-fuel-cell"].stack_size = 5
  data.raw.item["used-up-MOX-fuel"].stack_size = 10
  data.raw.item["used-up-breeder-fuel-cell"].stack_size = 5

  data.raw.item["MOX-reactor"].stack_size = 1
  if not mods["RealisticReactors"] then
    data.raw.item["breeder-reactor"].stack_size = 1
  end
end

-- Update technologies, trying to follow the nuclear tech rebalancing by K2

krastorio.technologies.setResearchUnitCount("plutonium-processing", 1500)
krastorio.technologies.setResearchUnitCount("plutonium-nuclear-power", 600)
krastorio.technologies.setResearchUnitCount("MOX-fuel-reprocessing", 1000)
krastorio.technologies.setResearchUnitCount("nuclear-breeding", 5000)
krastorio.technologies.setResearchUnitCount("breeder-fuel-cell-from-uranium-cell", 2500)
krastorio.technologies.setResearchUnitCount("breeder-fuel-cell-from-MOX-fuel", 2500)

-- Ammo fixes

require "data-final-fixes-ammo"
