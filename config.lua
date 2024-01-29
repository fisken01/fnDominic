Config = {}

Config.Cooldown = 1800 -- i sekunder
Config.Price = 175000

Config.JobLocation = vector4(714.7225, 4178.1387, 40.7092, 94.9193)
Config.JobDeliver = vector3(954.3460, -1511.8755, 31.0932)

Config.Rewards = { -- Picks a random (4 needed)
    [1] = 'meth_pooch',
    [2] = 'coke_pooch',
    [3] = 'hash_pooch',
    [4] = 'weed_pooch',
}

Config.PedModel = 'ig_g'
Config.Peds = {
    [1] = {
        type = 'a_m_y_mexthug_01',
        location = vector3(733.3098, 4191.3833, 40.7122),
        heading = 252.1528,
        weapon = 'WEAPON_KNIFE',
        scenario = "WORLD_HUMAN_GUARD_STAND",
    },
    [2] = {
        type = 'a_m_y_mexthug_01',
        location = vector3(745.0515, 4185.1162, 40.7341),
        heading = 342.9340,
        weapon = 'WEAPON_KNIFE',
        scenario = "WORLD_HUMAN_GUARD_STAND",
    },
    [3] = {
        type = 'a_m_y_mexthug_01',
        location = vector3(742.3711, 4195.7134, 40.7126),
        heading = 255.6125,
        weapon = 'WEAPON_KNIFE',
        scenario = "WORLD_HUMAN_GUARD_STAND",
    },
    [4] = {
        type = 'g_m_m_mexboss_02',
        location = vector3(749.3811, 4184.9614, 41.0878),
        heading = 351.8138,
        weapon = 'WEAPON_KNIFE',
        scenario = "WORLD_HUMAN_STAND_IMPATIENT",
    },
    [5] = {
        type = 'g_m_y_mexgoon_01',
        location = vector3(726.7728, 4168.9814, 40.7092),
        heading = 1.0349,
        weapon = 'WEAPON_KNIFE',
        scenario = "WORLD_HUMAN_GUARD_STAND",
    },
    [6] = {
        type = 'g_m_y_mexgoon_01',
        location = vector3(708.2172, 4168.7783, 40.8159),
        heading = 275.5,
        weapon = 'WEAPON_KNIFE',
        scenario = "WORLD_HUMAN_GUARD_STAND",
    },
    [7] = {
        type = 'g_m_y_mexgoon_01',
        location = vector3(723.2789, 4176.8403, 40.7092),
        heading = 288.3977,
        weapon = 'WEAPON_KNIFE',
        scenario = "WORLD_HUMAN_GUARD_STAND",
    },
}