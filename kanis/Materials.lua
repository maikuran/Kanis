-- kanis_materials: Materials.lua

local materials_def = {
    {
        id = "kanilite",
        name = "カニライト (Kanilite)",
        color = "#ff66aa", -- ピンク
        sword_stats = { damage = 6.5, speed = 1.72, durability = 892 },
        is_nether = false,
        temp = 800,
    },
    {
        id = "hachilite",
        name = "ハチライト (Hachilite)",
        color = "#55eeff", -- 水色
        sword_stats = { damage = 7.5, speed = 1.6, durability = 1432 },
        is_nether = false,
        temp = 950,
    },
    {
        id = "momongaite",
        name = "モモンガイト (Momongaite)",
        color = "#9933ff", -- 紫
        sword_stats = { damage = 12.5, speed = 1.6, durability = 2444 },
        is_nether = true,
        temp = 1250,
    },
    {
        id = "ignitz",
        name = "イグニッツ (Ignitz)",
        color = "#ff2222", -- 紅色
        sword_stats = { damage = 15.0, speed = 1.6, durability = 342 },
        is_nether = true,
        temp = 1400,
    },
}

for _, mat in ipairs(materials_def) do
    -- Mineclonia / mcl_core のテクスチャをベースに使用
    local base_item_img = "mcl_core_iron_ingot.png^[colorize:" .. mat.color .. ":160"
    local fluid_img = "mcl_core_lava_source.png^[colorize:" .. mat.color .. ":200"
    
    -- パーツ用テクスチャ（Minecloniaの鉄ピッケルと木の棒のテクスチャをベースに流用）
    local head_texture = "mcl_tools_iron_pickaxe.png^[colorize:" .. mat.color .. ":180"
    local handle_texture = "mcl_core_stick.png^[colorize:" .. mat.color .. ":100"

    -- 1. Melternsの流体（液体金属）登録
    if melterns and melterns.register_fluid then
        melterns.register_fluid("kanis:molten_" .. mat.id, {
            description = "溶融 " .. mat.name,
            inventory_image = fluid_img,
            temperature = mat.temp,
            color = mat.color,
        })
    end

    -- 2. ツールマテリアルおよびパーツの登録
    local head_durability = math.floor(mat.sword_stats.durability * 1.1)
    local head_damage = mat.sword_stats.damage
    local tool_speed = mat.sword_stats.speed

    if melterns and melterns.register_material then
        melterns.register_material("kanis:" .. mat.id, {
            description = mat.name,
            inventory_image = base_item_img,
            parts = {
                head = {
                    durability = head_durability,
                    mining_speed = tool_speed * 3.0,
                    harvest_level = mat.is_nether and 4 or 3,
                    damage = head_damage,
                    texture = head_texture,
                },
                handle = {
                    durability_modifier = mat.is_nether and 1.3 or 1.1,
                    speed_modifier = tool_speed / 1.5,
                    texture = handle_texture,
                },
            },
            smelting = {
                temperature = mat.temp,
                output_fluid = "kanis:molten_" .. mat.id,
                result_ingot = "kanis:" .. mat.id .. "_ingot",
            },
        })
    end

    -- 3. インゴットアイテムの登録
    minetest.register_craftitem("kanis:" .. mat.id .. "_ingot", {
        description = mat.name .. "のインゴット",
        inventory_image = base_item_img,
        groups = { ingot = 1, [mat.id .. "_ingot"] = 1 },
    })
end
