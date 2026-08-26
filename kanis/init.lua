-- kanis_materials: init.lua

local modpath = minetest.get_modpath("kanis_materials")

-- データのロード順序
dofile(modpath .. "/Materials.lua")
dofile(modpath .. "/Ore.lua")

minetest.log("action", "[kanis_materials] Loaded successfully with namespace kanis:")
