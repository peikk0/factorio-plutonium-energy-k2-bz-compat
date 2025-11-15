local data_util = require("__Krastorio2__/data-util")
local sounds = require("__base__/prototypes/entity/sounds")

-- Update plutonium atomic artillery shell icon

-- TODO: add new icon for plutonium atomic artillery shell
--[[
data_util.set_icon("plutonium-atomic-artillery-shell", "__Krastorio2Assets__/icons/ammo/plutonium-atomic-artillery-shell.png", 64)
if data.raw.ammo["plutonium-atomic-artillery-shell"] then
  data.raw.ammo["plutonium-atomic-artillery-shell"].pictures = {
    layers = {
      {
        size = 64,
        filename = "__Krastorio2Assets__/icons/ammo/plutonium-atomic-artillery-shell.png",
        scale = 0.25,
        mipmap_count = 4,
      },
      {
        draw_as_light = true,
        flags = { "light" },
        size = 64,
        filename = "__Krastorio2Assets__/icons/ammo/plutonium-atomic-artillery-shell-light.png",
        scale = 0.25,
        mipmap_count = 4,
      },
    },
  }
end
]]

-- Update plutonium atomic artillery shell ammo
data.raw.ammo["plutonium-atomic-artillery-shell"].order = "d[explosive-cannon-shell]-d[artillery]-a3[plutonium-atomic-artillery]"
data.raw.ammo["plutonium-atomic-artillery-shell"].stack_size = 25

-- Update plutonium atomic artillery shell recipe
data_util.remove_ingredient("plutonium-atomic-artillery-shell", "explosives")
data_util.remove_ingredient("plutonium-atomic-artillery-shell", "radar")
data_util.overwrite_or_add_ingredient("plutonium-atomic-artillery-shell", { type = "item", name = "steel-plate", amount = 10 })
data_util.overwrite_or_add_ingredient("plutonium-atomic-artillery-shell", { type = "item", name = "artillery-shell", amount = 1 })
data.raw.recipe["plutonium-atomic-artillery-shell"].energy_required = 15

-- Update plutonium atomic artillery shell technology
data.raw.technology["plutonium-atomic-bomb"].unit.count = 1800

data.raw["artillery-projectile"]["plutonium-atomic-artillery-projectile"].acceleration = 0.005
data.raw["artillery-projectile"]["plutonium-atomic-artillery-projectile"].light = { intensity = 0.8, size = 15 }
data.raw["artillery-projectile"]["plutonium-atomic-artillery-projectile"].smoke = {
  {
    name = "smoke-fast",
    deviation = { 0.15, 0.15 },
    frequency = 1,
    position = { 0, 1 },
    slow_down_factor = 1,
    starting_frame = 3,
    starting_frame_deviation = 5,
    starting_frame_speed = 0,
    starting_frame_speed_deviation = 5,
  }
}
data.raw["artillery-projectile"]["plutonium-atomic-artillery-projectile"].action.action_delivery.target_effects = {
  {
    type = "set-tile",
    tile_name = "nuclear-ground",
    radius = 12,
    apply_projection = true,
    tile_collision_mask = { layers = { water_tile = true } },
  },
  {
    type = "destroy-cliffs",
    radius = 10,
    explosion = "explosion",
  },
  {
    type = "create-entity",
    entity_name = "nuke-explosion",
  },
  {
    type = "camera-effect",
    effect = "screen-burn",
    duration = 70,
    ease_in_duration = 5,
    ease_out_duration = 60,
    delay = 0,
    strength = 6,
    full_strength_max_distance = 150,
    max_distance = 725,
  },
  {
    type = "play-sound",
    sound = sounds.nuclear_explosion(0.9),
    play_on_target_position = false,
    -- min_distance = 200,
    max_distance = 1000,
  },
  {
    type = "play-sound",
    sound = sounds.nuclear_explosion_aftershock(0.4),
    play_on_target_position = false,
    -- min_distance = 200,
    max_distance = 1000,
  },
  {
    type = "damage",
    damage = { amount = 3500, type = "explosion" },
  },
  {
    type = "damage",
    damage = { amount = 3500, type = "kr-radioactive" },
  },
  {
    type = "show-explosion-on-chart",
    scale = 3.5,
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
    include_soft_decoratives = true,
    include_decals = true,
    invoke_decorative_trigger = true,
    decoratives_with_trigger_only = false,
    radius = 20,
  },
  {
    type = "create-decorative",
    decorative = "nuclear-ground-patch",
    spawn_min_radius = 12,
    spawn_max_radius = 13,
    spawn_min = 42,
    spawn_max = 56,
    apply_projection = true,
    spread_evenly = true,
  },
  {
    type = "nested-result",
    action = {
      type = "area",
      target_entities = false,
      trigger_from_target = true,
      repeat_count = 1200,
      radius = 10,
      action_delivery = {
        type = "projectile",
        projectile = "atomic-bomb-ground-zero-projectile",
        starting_speed = 0.6 * 0.8 * 1.4,
        starting_speed_deviation = 0.075,
      },
    },
  },
  {
    type = "nested-result",
    action = {
      type = "area",
      target_entities = false,
      trigger_from_target = true,
      repeat_count = 1400,
      radius = 32,
      action_delivery = {
        type = "projectile",
        projectile = "plutonium-atomic-bomb-wave",
        starting_speed = 0.5 * 0.7 * 1.4,
        starting_speed_deviation = 0.075,
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
      repeat_count = 1400,
      radius = 35,
      action_delivery = {
        type = "projectile",
        projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
        starting_speed = 0.5 * 0.7 * 1.4,
        starting_speed_deviation = 0.075,
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
      repeat_count = 800,
      radius = 5,
      action_delivery = {
        type = "projectile",
        projectile = "atomic-bomb-wave-spawns-fire-smoke-explosion",
        starting_speed = 0.5 * 0.65 * 1.4,
        starting_speed_deviation = 0.075,
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
      repeat_count = 1000,
      radius = 8,
      action_delivery = {
        type = "projectile",
        projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
        starting_speed = 0.5 * 0.65 * 1.4,
        starting_speed_deviation = 0.075,
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
      repeat_count = 420,
      radius = 32,
      action_delivery = {
        type = "projectile",
        projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
        starting_speed = 0.55 * 0.65 * 1.4,
        starting_speed_deviation = 0.075,
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
      repeat_count = 11,
      radius = 10,
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "create-entity",
            entity_name = "nuclear-smouldering-smoke-source",
            tile_collision_mask = { layers = { water_tile = true } },
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
    radius = 3,
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
        damage = { amount = 140, type = "kr-radioactive" },
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

if settings.startup['enable-plutonium-ammo'].value then
  -- TODO: add plutonium rifle magazine
  -- TODO: add plutonium anti-material rifle magazine
  -- TODO: add plutonium turret rocket
  -- ...or not, depleted plutonium ammo is not a thing after all

  -- Update ammo technologies

  -- data_util.add_recipe_unlock("kr-turret-rocket", "plutonium-turret-rocket")

  -- K2 damage rebalancing

  data.raw.ammo["plutonium-rounds-magazine"].ammo_type.action.action_delivery.target_effects = {
    {
      type = "create-entity",
      entity_name = "explosion-hit",
      offsets = { { 0, 1 } },
      offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    },
    { type = "damage", damage = { amount = 14, type = "physical" } },
    { type = "damage", damage = { amount = 14, type = "kr-radioactive" } },
  }

  data.raw.ammo["plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50
  data.raw.projectile["plutonium-cannon-projectile"].acceleration = 0.1
  data.raw.projectile["plutonium-cannon-projectile"].light = { intensity = 0.45, size = 8, color = { r = 0.1, g = 0.9, b = 0.7 } }

  data.raw.ammo["explosive-plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50
  data.raw.projectile["explosive-plutonium-cannon-projectile"].acceleration = 0.1
  data.raw.projectile["explosive-plutonium-cannon-projectile"].light = { intensity = 0.45, size = 8, color = { r = 0.1, g = 0.9, b = 0.7 } }

  -- K2 realistic weapons

  if settings.startup['kr-realistic-weapons'].value then
    data.raw.ammo["plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50
    data.raw.ammo["explosive-plutonium-cannon-shell"].ammo_type.action.action_delivery.max_range = 50

    data.raw.ammo["plutonium-rounds-magazine"].hidden = true
    data.raw.recipe["plutonium-rounds-magazine"].hidden = true
    data_util.remove_recipe_unlock("plutonium-ammo", "plutonium-rounds-magazine")
    -- data_util.remove_recipe_unlock("plutonium-ammo", "plutonium-rifle-magazine")
    -- data_util.remove_recipe_unlock("plutonium-ammo", "plutonium-anti-material-rifle-magazine")
  end
end
