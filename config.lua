Config = Config or {}

-- Gameplay toggles
Config.Features = {
    speedLimiter = true,       -- Hard cap based on engine level settings
    horsepower = true,         -- Apply horsepower curves + torque multipliers
    offroadLimiter = true,     -- Override caps + smooth braking on loose surfaces
    turboPressure = true,      -- Adjust turbo boost pressure when upgrades/turbo are installed
    turboSpool = true,         -- Reduce torque until the turbo reaches target pressure
}


-- General behaviour
Config.AllowDebugVehicleNames = true
Config.UseMph = false
Config.DefaultEngineLevels = Config.DefaultEngineLevels or 5
Config.UpdateIntervalMs = 0        -- 0 for every frame, >0 to trade accuracy for performance
Config.OffroadDeceleration = 0.075 -- Applied per tick when braking to the offroad limit

-- Default numbers used when a vehicle entry omits a field
Config.Defaults = {
    stockSpeedLimit = 200.0,
    stockHorsepower = 150.0,
    horsepowerCap = 1.5,            -- Max multiplier to avoid crazy torque values
    turboPressureBase = 0.9,
    turboPressurePerLevel = 0.05,   -- Added per engine upgrade level
    turboPressureTurboBonus = 2.0,  -- Added when a turbo is installed
    turboPressureMin = 2.0,
    turboPressureMax = 5.0,
    turboSpoolMinPressure = 0.05,    -- Pressure at/below which torque is heavily reduced
    turboSpoolMaxPressure = 1.5,     -- Pressure needed for full torque
    turboSpoolBaseMultiplier = 0.6,  -- Minimum torque fraction while off boost
    turboSpoolCurve = 1.15,          -- >1.0 slows initial spool, <1.0 makes it sharper
}

-- Single vehicle list (edit this table directly)
Config.VehicleProfiles = {
    -- Format: [Vehicle Model] = { stockSpeedLimit, stockHorsepower, engineLevels, speedLimits, horsepower, turboBoost, turboHorsepower }

    ["kanjo"] = {
        stockSpeedLimit = 140,         -- Stock engine speed limit
        stockHorsepower = 125,         -- Stock horsepower
        engineLevels = 4,              -- Total engine levels including stock
        speedLimits = {160, 180, 200, 215}, -- Speed limits for each engine level
        horsepower = {140, 170, 190, 210},  -- Horsepower for each engine level
        turboBoost = 25,               -- Extra speed added on top of speedlimiter when turbo is installed 
        turboHorsepower = 20           -- Extra horsepower when turbo is installed
    },
    ["panto"] = {
        stockSpeedLimit = 149,
        stockHorsepower = 130,
        engineLevels = 4,
        speedLimits = {166, 192, 201, 232},
        horsepower = {144, 167, 175, 202},
        turboBoost = 29,
        turboHorsepower = 23
    },
    ["club"] = {
        stockSpeedLimit = 146,
        stockHorsepower = 127,
        engineLevels = 4,
        speedLimits = {164, 189, 209, 230},
        horsepower = {143, 164, 182, 200},
        turboBoost = 28,
        turboHorsepower = 22
    },
    ["dominator3"] = {
        stockSpeedLimit = 239,
        stockHorsepower = 208,
        engineLevels = 4,
        speedLimits = {258, 279, 298, 308},
        horsepower = {224, 243, 259, 268},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["everon"] = {
        stockSpeedLimit = 180,
        stockHorsepower = 157,
        engineLevels = 4,
        speedLimits = {198, 209, 215, 229},
        horsepower = {172, 182, 187, 199},
        turboBoost = 8,
        turboHorsepower = 6
    },
    ["brawler"] = {
        stockSpeedLimit = 175,
        stockHorsepower = 152,
        engineLevels = 4,
        speedLimits = {190, 206, 218, 225},
        horsepower = {165, 179, 190, 196},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["dubsta3"] = {
        stockSpeedLimit = 188,
        stockHorsepower = 163,
        engineLevels = 4,
        speedLimits = {198, 209, 215, 229},
        horsepower = {172, 182, 187, 199},
        turboBoost = 10,
        turboHorsepower = 8
    },
    ["baller3"] = {
        stockSpeedLimit = 201,
        stockHorsepower = 175,
        engineLevels = 4,
        speedLimits = {210, 215, 224, 235},
        horsepower = {183, 187, 195, 204},
        turboBoost = 11,
        turboHorsepower = 9
    },
    ["dubsta2"] = {
        stockSpeedLimit = 224,
        stockHorsepower = 195,
        engineLevels = 4,
        speedLimits = {235, 250, 263, 279},
        horsepower = {204, 217, 229, 243},
        turboBoost = 11,
        turboHorsepower = 9
    },
    ["rebla"] = {
        stockSpeedLimit = 190,
        stockHorsepower = 165,
        engineLevels = 4,
        speedLimits = {210, 225, 240, 255},
        horsepower = {183, 196, 209, 222},
        turboBoost = 15,
        turboHorsepower = 12
    },
    ["novak"] = {
        stockSpeedLimit = 182,
        stockHorsepower = 158,
        engineLevels = 4,
        speedLimits = {198, 213, 228, 240},
        horsepower = {172, 185, 198, 209},
        turboBoost = 13,
        turboHorsepower = 10
    },
    ["tailgater2"] = {
        stockSpeedLimit = 165,
        stockHorsepower = 143,
        engineLevels = 4,
        speedLimits = {180, 195, 205, 220},
        horsepower = {157, 170, 178, 191},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["drafter"] = {
        stockSpeedLimit = 210,
        stockHorsepower = 183,
        engineLevels = 4,
        speedLimits = {225, 240, 255, 270},
        horsepower = {196, 209, 222, 235},
        turboBoost = 18,
        turboHorsepower = 14
    },
    ["komoda"] = {
        stockSpeedLimit = 230,
        stockHorsepower = 200,
        engineLevels = 4,
        speedLimits = {245, 260, 275, 290},
        horsepower = {213, 226, 239, 252},
        turboBoost = 20,
        turboHorsepower = 16
    },
    ["elegy2"] = {
        stockSpeedLimit = 225,
        stockHorsepower = 196,
        engineLevels = 4,
        speedLimits = {240, 255, 270, 285},
        horsepower = {209, 222, 235, 248},
        turboBoost = 17,
        turboHorsepower = 14
    },
    ["jugular"] = {
        stockSpeedLimit = 240,
        stockHorsepower = 209,
        engineLevels = 4,
        speedLimits = {260, 280, 295, 310},
        horsepower = {226, 243, 257, 270},
        turboBoost = 22,
        turboHorsepower = 18
    },
    ["kuruma"] = {
        stockSpeedLimit = 180,
        stockHorsepower = 157,
        engineLevels = 4,
        speedLimits = {195, 210, 225, 240},
        horsepower = {170, 183, 196, 209},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["neon"] = {
        stockSpeedLimit = 220,
        stockHorsepower = 191,
        engineLevels = 4,
        speedLimits = {235, 250, 265, 280},
        horsepower = {204, 217, 230, 243},
        turboBoost = 18,
        turboHorsepower = 14
    },
    ["paragon"] = {
        stockSpeedLimit = 235,
        stockHorsepower = 204,
        engineLevels = 4,
        speedLimits = {250, 265, 280, 295},
        horsepower = {217, 230, 243, 256},
        turboBoost = 20,
        turboHorsepower = 16
    },
    ["raiden"] = {
        stockSpeedLimit = 215,
        stockHorsepower = 187,
        engineLevels = 4,
        speedLimits = {230, 245, 260, 275},
        horsepower = {200, 213, 226, 239},
        turboBoost = 16,
        turboHorsepower = 13
    },
    ["schlagen"] = {
        stockSpeedLimit = 230,
        stockHorsepower = 200,
        engineLevels = 4,
        speedLimits = {245, 260, 275, 290},
        horsepower = {213, 226, 239, 252},
        turboBoost = 19,
        turboHorsepower = 15
    },
    ["sugoi"] = {
        stockSpeedLimit = 170,
        stockHorsepower = 148,
        engineLevels = 4,
        speedLimits = {185, 200, 215, 230},
        horsepower = {161, 174, 187, 200},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["sultan2"] = {
        stockSpeedLimit = 100,
        stockHorsepower = 152,
        engineLevels = 4,
        speedLimits = {190, 205, 220, 235},
        horsepower = {165, 178, 191, 204},
        turboBoost = 49,
        turboHorsepower = 25
    },
    ["vstr"] = {
        stockSpeedLimit = 220,
        stockHorsepower = 191,
        engineLevels = 4,
        speedLimits = {235, 250, 265, 280},
        horsepower = {204, 217, 230, 243},
        turboBoost = 18,
        turboHorsepower = 14
    },
    ["cypher"] = {
        stockSpeedLimit = 210,
        stockHorsepower = 183,
        engineLevels = 4,
        speedLimits = {225, 240, 255, 270},
        horsepower = {196, 209, 222, 235},
        turboBoost = 17,
        turboHorsepower = 14
    },
    ["vectre"] = {
        stockSpeedLimit = 195,
        stockHorsepower = 170,
        engineLevels = 4,
        speedLimits = {210, 225, 240, 255},
        horsepower = {183, 196, 209, 222},
        turboBoost = 15,
        turboHorsepower = 12
    },
    ["growler"] = {
        stockSpeedLimit = 235,
        stockHorsepower = 204,
        engineLevels = 4,
        speedLimits = {250, 265, 280, 295},
        horsepower = {217, 230, 243, 256},
        turboBoost = 20,
        turboHorsepower = 16
    },
    ["comet6"] = {
        stockSpeedLimit = 230,
        stockHorsepower = 200,
        engineLevels = 4,
        speedLimits = {245, 260, 275, 290},
        horsepower = {213, 226, 239, 252},
        turboBoost = 19,
        turboHorsepower = 15
    },
    ["cheburek"] = {
        stockSpeedLimit = 175,
        stockHorsepower = 152,
        engineLevels = 4,
        speedLimits = {190, 205, 220, 235},
        horsepower = {165, 178, 191, 204},
        turboBoost = 13,
        turboHorsepower = 10
    },
    ["zion3"] = {
        stockSpeedLimit = 180,
        stockHorsepower = 157,
        engineLevels = 4,
        speedLimits = {195, 210, 225, 240},
        horsepower = {170, 183, 196, 209},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["rapidgt3"] = {
        stockSpeedLimit = 225,
        stockHorsepower = 196,
        engineLevels = 4,
        speedLimits = {240, 255, 270, 285},
        horsepower = {209, 222, 235, 248},
        turboBoost = 17,
        turboHorsepower = 14
    },
    ["peyote"] = {
        stockSpeedLimit = 160,
        stockHorsepower = 139,
        engineLevels = 4,
        speedLimits = {175, 190, 205, 220},
        horsepower = {152, 165, 178, 191},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["manana"] = {
        stockSpeedLimit = 150,
        stockHorsepower = 130,
        engineLevels = 4,
        speedLimits = {165, 180, 195, 210},
        horsepower = {143, 156, 170, 183},
        turboBoost = 10,
        turboHorsepower = 8
    },
    ["tailgater"] = {
        stockSpeedLimit = 170,
        stockHorsepower = 148,
        engineLevels = 4,
        speedLimits = {185, 200, 215, 230},
        horsepower = {161, 174, 187, 200},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["trophytruck"] = {
        stockSpeedLimit = 160,
        stockHorsepower = 139,
        engineLevels = 4,
        speedLimits = {175, 190, 205, 220},
        horsepower = {152, 165, 178, 191},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["vamos"] = {
        stockSpeedLimit = 200,
        stockHorsepower = 174,
        engineLevels = 4,
        speedLimits = {215, 230, 245, 260},
        horsepower = {187, 200, 213, 226},
        turboBoost = 15,
        turboHorsepower = 12
    },
    ["windsor"] = {
        stockSpeedLimit = 180,
        stockHorsepower = 157,
        engineLevels = 4,
        speedLimits = {195, 210, 225, 240},
        horsepower = {170, 183, 196, 209},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["oracle2"] = {
        stockSpeedLimit = 175,
        stockHorsepower = 152,
        engineLevels = 4,
        speedLimits = {190, 205, 220, 235},
        horsepower = {165, 178, 191, 204},
        turboBoost = 13,
        turboHorsepower = 10
    },
    ["jackal"] = {
        stockSpeedLimit = 165,
        stockHorsepower = 143,
        engineLevels = 4,
        speedLimits = {180, 195, 210, 225},
        horsepower = {156, 170, 183, 196},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["mule2"] = {
        stockSpeedLimit = 140,
        stockHorsepower = 122,
        engineLevels = 4,
        speedLimits = {155, 170, 185, 200},
        horsepower = {135, 148, 161, 174},
        turboBoost = 10,
        turboHorsepower = 8
    },
    ["toros"] = {
        stockSpeedLimit = 245,
        stockHorsepower = 213,
        engineLevels = 4,
        speedLimits = {260, 275, 290, 305},
        horsepower = {226, 239, 252, 265},
        turboBoost = 21,
        turboHorsepower = 17
    },
    ["omnisegt"] = {
        stockSpeedLimit = 215,
        stockHorsepower = 187,
        engineLevels = 4,
        speedLimits = {230, 245, 260, 275},
        horsepower = {200, 213, 226, 239},
        turboBoost = 17,
        turboHorsepower = 14
    },
    ["rhinehart"] = {
        stockSpeedLimit = 230,
        stockHorsepower = 180,
        engineLevels = 4,
        speedLimits = {245, 260, 275, 290},
        horsepower = {213, 226, 239, 252},
        turboBoost = 18,
        turboHorsepower = 14
    },
    ["astron"] = {
        stockSpeedLimit = 225,
        stockHorsepower = 196,
        engineLevels = 4,
        speedLimits = {240, 255, 270, 285},
        horsepower = {209, 222, 235, 248},
        turboBoost = 17,
        turboHorsepower = 14
    },
    ["iwagen"] = {
        stockSpeedLimit = 190,
        stockHorsepower = 165,
        engineLevels = 4,
        speedLimits = {205, 220, 235, 250},
        horsepower = {178, 191, 204, 217},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["cinquemila"] = {
        stockSpeedLimit = 200,
        stockHorsepower = 174,
        engineLevels = 4,
        speedLimits = {215, 230, 245, 260},
        horsepower = {187, 200, 213, 226},
        turboBoost = 15,
        turboHorsepower = 12
    },
    ["stingertt"] = {
        stockSpeedLimit = 235,
        stockHorsepower = 204,
        engineLevels = 4,
        speedLimits = {250, 265, 280, 295},
        horsepower = {217, 230, 243, 256},
        turboBoost = 20,
        turboHorsepower = 16
    },
    ["tempesta"] = {
        stockSpeedLimit = 240,
        stockHorsepower = 209,
        engineLevels = 4,
        speedLimits = {255, 270, 285, 300},
        horsepower = {222, 235, 248, 261},
        turboBoost = 22,
        turboHorsepower = 18
    },
    ["terminus"] = {
        stockSpeedLimit = 160,
        stockHorsepower = 139,
        engineLevels = 4,
        speedLimits = {175, 190, 205, 220},
        horsepower = {152, 165, 178, 191},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["kamacho"] = {
        stockSpeedLimit = 180,
        stockHorsepower = 157,
        engineLevels = 4,
        speedLimits = {195, 210, 225, 240},
        horsepower = {170, 183, 196, 209},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["buffalo4"] = {
        stockSpeedLimit = 195,
        stockHorsepower = 170,
        engineLevels = 4,
        speedLimits = {210, 225, 240, 255},
        horsepower = {183, 196, 209, 222},
        turboBoost = 16,
        turboHorsepower = 13
    },
    ["tenf"] = {
        stockSpeedLimit = 225,
        stockHorsepower = 196,
        engineLevels = 4,
        speedLimits = {240, 255, 270, 285},
        horsepower = {209, 222, 235, 248},
        turboBoost = 18,
        turboHorsepower = 14
    },
    ["nightshade"] = {
        stockSpeedLimit = 165,
        stockHorsepower = 143,
        engineLevels = 4,
        speedLimits = {180, 195, 210, 225},
        horsepower = {156, 170, 183, 196},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["rocoto"] = {
        stockSpeedLimit = 185,
        stockHorsepower = 161,
        engineLevels = 4,
        speedLimits = {200, 215, 230, 245},
        horsepower = {174, 187, 200, 213},
        turboBoost = 13,
        turboHorsepower = 10
    },
    ["xls"] = {
        stockSpeedLimit = 180,
        stockHorsepower = 157,
        engineLevels = 4,
        speedLimits = {195, 210, 225, 240},
        horsepower = {170, 183, 196, 209},
        turboBoost = 14,
        turboHorsepower = 11
    },
    ["surge"] = {
        stockSpeedLimit = 160,
        stockHorsepower = 139,
        engineLevels = 4,
        speedLimits = {175, 190, 205, 220},
        horsepower = {152, 165, 178, 191},
        turboBoost = 10,
        turboHorsepower = 8
    },
    ["youga"] = {
        stockSpeedLimit = 140,
        stockHorsepower = 122,
        engineLevels = 4,
        speedLimits = {155, 170, 185, 200},
        horsepower = {135, 148, 161, 174},
        turboBoost = 8,
        turboHorsepower = 6
    },
    ["issi8"] = {
        stockSpeedLimit = 165,
        stockHorsepower = 143,
        engineLevels = 4,
        speedLimits = {180, 195, 210, 225},
        horsepower = {156, 170, 183, 196},
        turboBoost = 12,
        turboHorsepower = 10
    },
    ["issi"] = {
        stockSpeedLimit = 150,
        stockHorsepower = 130,
        engineLevels = 4,
        speedLimits = {165, 180, 195, 210},
        horsepower = {143, 156, 170, 183},
        turboBoost = 10,
        turboHorsepower = 8
    },
    ["zion2"] = {
        stockSpeedLimit = 170,
        stockHorsepower = 148,
        engineLevels = 4,
        speedLimits = {185, 200, 215, 230},
        horsepower = {161, 174, 187, 200},
        turboBoost = 13,
        turboHorsepower = 10
    },
    ["turismo3"] = {
        stockSpeedLimit = 255,
        stockHorsepower = 222,
        engineLevels = 4,
        speedLimits = {270, 285, 300, 315},
        horsepower = {235, 248, 261, 274},
        turboBoost = 23,
        turboHorsepower = 18
    },
    ["furia"] = {
        stockSpeedLimit = 260,
        stockHorsepower = 226,
        engineLevels = 4,
        speedLimits = {275, 290, 305, 320},
        horsepower = {239, 252, 265, 278},
        turboBoost = 25,
        turboHorsepower = 20
    },
    ["niobe"] = {
        stockSpeedLimit = 220,
        stockHorsepower = 191,
        engineLevels = 4,
        speedLimits = {235, 250, 265, 280},
        horsepower = {204, 217, 230, 243},
        turboBoost = 18,
        turboHorsepower = 14
    }
}

Config.GroundHashes = Config.GroundHashes or {
    [-1885547121] = { name = "Dirt", isOffroad = true },
    [282940568]   = { name = "Road", isOffroad = false },
    [510490462]   = { name = "Sand", isOffroad = true },
    [951832588]   = { name = "Sand 2", isOffroad = true },
    [2128369009]  = { name = "Grass and Dirt Combined", isOffroad = true },
    [-840216541]  = { name = "Rock Surface", isOffroad = true },
    [-1286696947] = { name = "Grass and Dirt Combined 2", isOffroad = true },
    [1333033863]  = { name = "Grass", isOffroad = true },
    [1187676648]  = { name = "Concrete", isOffroad = false },
    [1144315879]  = { name = "Grass 2", isOffroad = true },
    [-1942898710] = { name = "Gravel, Dirt, and Cobblestone", isOffroad = true },
    [560985072]   = { name = "Sand Grass", isOffroad = true },
    [-1775485061] = { name = "Cement", isOffroad = false },
    [581794674]   = { name = "Grass 3", isOffroad = true },
    [1993976879]  = { name = "Cement 2", isOffroad = false },
    [-1084640111] = { name = "Cement 3", isOffroad = false },
    [-700658213]  = { name = "Dirt with Grass", isOffroad = true },
    [0]           = { name = "Air", isOffroad = false },
    [-124769592]  = { name = "Dirt with Grass 4", isOffroad = true },
    [-461750719]  = { name = "Dirt with Grass 5", isOffroad = true },
    [-1595148316] = { name = "Concrete 4", isOffroad = false },
    [1288448767]  = { name = "Water", isOffroad = false },
    [765206029]   = { name = "Marble Tiles", isOffroad = false },
    [-1186320715] = { name = "Pool Water", isOffroad = false },
    [1639053622]  = { name = "Concrete 3", isOffroad = false }
}

Config.VehicleClassSpeedLimitsOffroad = Config.VehicleClassSpeedLimitsOffroad or {
    [0]  = 50,   -- Compacts
    [1]  = 10,   -- Sedans
    [2]  = 180,  -- SUVs
    [3]  = 10,   -- Coupes
    [4]  = 80,   -- Muscle
    [5]  = 210,  -- Sports Classics
    [6]  = 10,   -- Sports
    [7]  = 10,   -- Super
    [8]  = 80,   -- Motorcycles
    [9]  = 150,  -- Off-road vehicles
    [10] = 160,  -- Industrial
    [11] = 160,  -- Utility
    [12] = 170,  -- Vans
    [13] = 80,   -- Cycles
    [14] = 80,   -- Boats
    [15] = 80,   -- Helicopters
    [16] = 250,  -- Planes
    [17] = 160,  -- Service
    [18] = 160,  -- Emergency
    [19] = 160,  -- Military
    [20] = 160,  -- Commercial
    [21] = 160   -- Trains
}
