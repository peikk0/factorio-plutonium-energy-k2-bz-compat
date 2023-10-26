local sounds = require("__base__/prototypes/entity/sounds")

-- Update plutonium atomic bomb icon

-- TODO: add new icon for plutonium atomic bomb
--[[
krastorio.icons.setItemIcon("plutonium-atomic-bomb", kr_ammo_icons_path .. "plutonium-atomic-bomb.png", 64, 4)
if data.raw.ammo["plutonium-atomic-bomb"] then
  data.raw.ammo["plutonium-atomic-bomb"].pictures = {
    layers = {
      {
        size = 64,
        filename = kr_ammo_icons_path .. "plutonium-atomic-bomb.png",
        scale = 0.25,
        mipmap_count = 4,
      },
      {
        draw_as_light = true,
        flags = { "light" },
        size = 64,
        filename = kr_ammo_icons_path .. "plutonium-atomic-bomb-light.png",
        scale = 0.25,
        mipmap_count = 4,
      },
    },
  }
end
]]

-- Update plutonium atomic bomb recipe

krastorio.recipes.addIngredient("plutonium-atomic-bomb", { "heavy-rocket", 1 })
krastorio.recipes.replaceIngredient("plutonium-atomic-bomb", "plutonium-239", { "plutonium-239", 23 })
krastorio.recipes.setEnergyCost("plutonium-atomic-bomb", 10)

-- Update plutonium atomic bomb technology

krastorio.technologies.setResearchUnitCount("plutonium-atomic-bomb", 1800)
-- krastorio.technologies.addUnlockRecipe("plutonium-atomic-bomb", "plutonium-artillery-shell")

-- Update plutonium atomic bomb damage and effects

if krastorio.general.getSafeSettingValue("kr-damage-and-ammo") then
  data.raw.ammo["plutonium-atomic-bomb"].ammo_type.category = "heavy-rocket"
  data.raw.ammo["plutonium-atomic-bomb"].ammo_type.range_modifier = 1.4
  data.raw.ammo["plutonium-atomic-bomb"].ammo_type.cooldown_modifier = 3
  data.raw.projectile["plutonium-atomic-rocket"].acceleration = 0.01
  data.raw.projectile["plutonium-atomic-rocket"].light = { intensity = 0.8, size = 15, color = { r = 0.1, g = 0.9, b = 0.7 } }
  data.raw.projectile["plutonium-atomic-rocket"].action.action_delivery.target_effects = {
    {
      type = "set-tile",
      tile_name = "nuclear-ground",
      radius = 17, -- This
      apply_projection = true,
      tile_collision_mask = { "water-tile" },
    },
    {
      type = "destroy-cliffs",
      radius = 13, -- This
      explosion = "explosion",
    },
    {
      type = "create-entity",
      entity_name = "nuke-explosion",
    },
    {
      type = "camera-effect",
      effect = "screen-burn",
      duration = 60,
      ease_in_duration = 5,
      ease_out_duration = 60,
      delay = 0,
      strength = 6,
      full_strength_max_distance = 200,
      max_distance = 800,
    },
    {
      type = "play-sound",
      sound = sounds.nuclear_explosion(0.9),
      play_on_target_position = false,
      -- min_distance = 200,
      max_distance = 1000,
      -- volume_modifier = 1,
      audible_distance_modifier = 3,
    },
    {
      type = "play-sound",
      sound = sounds.nuclear_explosion_aftershock(0.4),
      play_on_target_position = false,
      -- min_distance = 200,
      max_distance = 1000,
      -- volume_modifier = 1,
      audible_distance_modifier = 3,
    },
    {
      type = "damage",
      damage = { amount = 2100, type = "explosion" }, -- This
    },
    {
      type = "damage",
      damage = { amount = 2100, type = "radioactive" }, -- This
    },
    {
      type = "show-explosion-on-chart",
      scale = 3,
    },
    {
      type = "create-entity",
      entity_name = "huge-scorchmark",
      check_buildability = true,
    },
    {
      type = "invoke-tile-trigger",
      repeat_count = 1,
    },
    {
      type = "destroy-decoratives",
      include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
      include_decals = true,
      invoke_decorative_trigger = true,
      decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
      radius = 21                            -- large radius for demostrative purposes -- This
    },
    {
      type = "create-decorative",
      decorative = "nuclear-ground-patch",
      spawn_min_radius = 16.5, -- This
      spawn_max_radius = 17.5, -- This
      spawn_min = 45,          -- This
      spawn_max = 60,          -- This
      apply_projection = true,
      spread_evenly = true,
    },
    {
      type = "nested-result",
      action = {
        type = "area",
        target_entities = false,
        trigger_from_target = true,
        repeat_count = 1400, -- This
        radius = 11,         -- This
        action_delivery = {
          type = "projectile",
          projectile = "atomic-bomb-ground-zero-projectile",
          starting_speed = 0.6 * 0.8 * 1.4, -- This
          starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
        },
      },
    },
    {
      type = "nested-result",
      action = {
        type = "area",
        target_entities = false,
        trigger_from_target = true,
        repeat_count = 1400, -- This
        radius = 50,         -- This
        action_delivery = {
          type = "projectile",
          projectile = "plutonium-atomic-bomb-wave",
          starting_speed = 0.5 * 0.7 * 1.4, -- This
          starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
        },
      },
    },
    {
      type = "nested-result",
      action = {
        type = "area",
        show_in_tooltip = false,
        target_entities = false,
        trigger_from_target = true,
        repeat_count = 1400, -- This
        radius = 43,         -- This
        action_delivery = {
          type = "projectile",
          projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
          starting_speed = 0.5 * 0.7 * 1.4, -- This
          starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
        },
      },
    },
    {
      type = "nested-result",
      action = {
        type = "area",
        show_in_tooltip = false,
        target_entities = false,
        trigger_from_target = true,
        repeat_count = 980, -- This
        radius = 6,         -- This
        action_delivery = {
          type = "projectile",
          projectile = "atomic-bomb-wave-spawns-fire-smoke-explosion",
          starting_speed = 0.5 * 0.65 * 1.4, -- This
          starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
        },
      },
    },
    {
      type = "nested-result",
      action = {
        type = "area",
        show_in_tooltip = false,
        target_entities = false,
        trigger_from_target = true,
        repeat_count = 1400, -- This
        radius = 11,         -- This
        action_delivery = {
          type = "projectile",
          projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
          starting_speed = 0.5 * 0.65 * 1.4, -- This
          starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
        },
      },
    },
    {
      type = "nested-result",
      action = {
        type = "area",
        show_in_tooltip = false,
        target_entities = false,
        trigger_from_target = true,
        repeat_count = 1050, -- This
        radius = 50,         -- This
        action_delivery = {
          type = "projectile",
          projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
          starting_speed = 0.55 * 0.65 * 1.4, -- This
          starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
        },
      },
    },
    {
      type = "nested-result",
      action = {
        type = "area",
        show_in_tooltip = false,
        target_entities = false,
        trigger_from_target = true,
        repeat_count = 14, -- This
        radius = 11,       -- This
        action_delivery = {
          type = "instant",
          target_effects = {
            {
              type = "create-entity",
              entity_name = "nuclear-smouldering-smoke-source",
              tile_collision_mask = { "water-tile" },
            },
          },
        },
      },
    },
  }

  local plutonium_atomic_bomb_wave = util.table.deepcopy(data.raw.projectile["atomic-bomb-wave"])
  plutonium_atomic_bomb_wave.name = "plutonium-atomic-bomb-wave"
  plutonium_atomic_bomb_wave.action = {
    {
      type = "area",
      radius = 4,
      ignore_collision_condition = true,
      action_delivery = {
        type = "instant",
        target_effects = {
          type = "damage",
          vaporize = false,
          lower_distance_threshold = 0,
          upper_distance_threshold = 35,
          lower_damage_modifier = 1,
          upper_damage_modifier = 0.1,
          damage = { amount = 140, type = "explosion" },
        },
        {
          type = "damage",
          vaporize = false,
          lower_distance_threshold = 0,
          upper_distance_threshold = 35,
          lower_damage_modifier = 1,
          upper_damage_modifier = 0.25,
          damage = { amount = 140, type = "radioactive" },
        },
        {
          type = "damage",
          vaporize = false,
          lower_distance_threshold = 0,
          upper_distance_threshold = 35,
          lower_damage_modifier = 1,
          upper_damage_modifier = 0.1,
          damage = { amount = 140, type = "kr-explosion" },
        },
      },
    },
  }
  data:extend({plutonium_atomic_bomb_wave})
end

if settings.startup['enable-plutonium-ammo'].value then
  -- TODO: add plutonium rifle magazine
  -- TODO: add plutonium anti-material rifle magazine
  -- TODO: add plutonium artillery shell
  -- TODO: add plutonium turret rocket
  -- ...or not, depleted plutonium ammo is not a thing after all

  -- Update ammo technologies

  -- krastorio.technologies.addUnlockRecipe("kr-turret-rocket", "plutonium-turret-rocket")

  -- K2 damage rebalancing

  if krastorio.general.getSafeSettingValue("kr-damage-and-ammo") then
    data.raw.ammo["plutonium-rounds-magazine"].ammo_type.action.action_delivery.target_effects = {
      {
        type = "create-entity",
        entity_name = "explosion-hit",
        offsets = { { 0, 1 } },
        offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
      },
      { type = "damage", damage = { amount = 14, type = "physical" } },
      { type = "damage", damage = { amount = 14, type = "radioactive" } },
    }

    data.raw.ammo["plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50
    data.raw.projectile["plutonium-cannon-projectile"].acceleration = 0.1
    data.raw.projectile["plutonium-cannon-projectile"].light = { intensity = 0.45, size = 8, color = { r = 0.1, g = 0.9, b = 0.7 } }

    data.raw.ammo["explosive-plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50
    data.raw.projectile["explosive-plutonium-cannon-projectile"].acceleration = 0.1
    data.raw.projectile["explosive-plutonium-cannon-projectile"].light = { intensity = 0.45, size = 8, color = { r = 0.1, g = 0.9, b = 0.7 } }
  end

  -- K2 more realistic weapons

  if krastorio.general.getSafeSettingValue("kr-more-realistic-weapon") then
    data.raw.ammo["plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50
    data.raw.ammo["explosive-plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50

    data.raw.ammo["plutonium-rounds-magazine"].flags = { "hidden" }
    krastorio.technologies.removeUnlockRecipe("plutonium-ammo", "plutonium-rounds-magazine")
    -- krastorio.technologies.addUnlockRecipe("plutonium-ammo", "plutonium-rifle-magazine")
    -- krastorio.technologies.addUnlockRecipe("plutonium-ammo", "plutonium-anti-material-rifle-magazine")
  end
end
