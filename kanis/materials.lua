-- kanis_materials: Materials.lua

local materials_def = {
    {
        id = "kanilite",
        name = "カニライト (Kanilite)",
        color = "#55eeff", -- 水色
        -- 剣基準値からパーツ性能へ配分・逆算
        sword_stats = { damage = 6.5, speed = 1.72, durability = 892 },
        is_nether = false,
        temp = 800,
    },
    {
        id = "hachilite",
        name = "ハチライト (Hachilite)",
        color = "#ff66aa", -- ピンク
        sword_stats = { damage = 7.5, speed = 1.6, durability = 1432 },
        is_nether = false,
        temp = 950,
    },
    {
        id = "momongaite",
        name = "モモンガイト (Momongaite)",
        color = "#9933ff", -- 紫（ネザー）
        sword_stats = { damage = 12.5, speed = 1.6, durability = 2444 },
        is_nether = true,
        temp = 1250,
    },
    {
        id = "ignitz",
        name = "イグニッツ (Ignitz)",
        color = "#ff2222", -- 紅色（ネザー）
        sword_stats = { damage = 15.0, speed = 1.6, durability = 342 },
        is_nether = true,
        temp = 1400,
    },
}

for _, mat in ipairs(materials_def) do
    -- 1. 液体テクスチャおよびインゴット・パーツ画像の自動生成（ダイナミックテクスチャ生成文字列の利用）
    -- Minetestのグラフィック合成機能（^ [colorize）を利用して、ファイル実体なしで自動着色・生成する
    local base_item_img = "default_silver_ingot.png^[colorize:" .. mat.color .. ":180"
    local fluid_img = "default_lava.png^[colorize:" .. mat.color .. ":200"

    -- 2. Melterns用流体の登録（液体金属）
    if melterns and melterns.register_fluid then
        melterns.register_fluid("kanis:molten_" .. mat.id, {
            description = "溶融 " .. mat.name,
            inventory_image = fluid_img,
            temperature = mat.temp,
            color = mat.color,
        })
    end

    -- 3. ツールパーツおよびマテリアルの登録
    -- 完成品の剣のステータスから逆算したヘッド・ハンドルの係数を設定
    local head_durability = math.floor(mat.sword_stats.durability * 1.1)
    local head_damage = mat.sword_stats.damage
    local tool_speed = mat.sword_stats.speed

    if melterns and melterns.register_material then
        melterns.register_material("kanis:" .. mat.id, {
            description = mat.name,
            inventory_image = base_item_img,
            -- パーツごとの性能割り当て
            parts = {
                head = {
                    durability = head_durability,
                    mining_speed = tool_speed * 3.0,
                    harvest_level = mat.is_nether and 4 or 3,
                    damage = head_damage,
                },
                handle = {
                    durability_modifier = mat.is_nether and 1.3 or 1.1,
                    speed_modifier = tool_speed / 1.5,
                },
            },
            smelting = {
                temperature = mat.temp,
                output_fluid = "kanis:molten_" .. mat.id,
                result_ingot = "kanis:" .. mat.id .. "_ingot",
            },
        })
    end

    -- インゴットアイテム自体の登録
    minetest.register_craftitem("kanis:" .. mat.id .. "_ingot", {
        description = mat.name .. "のインゴット",
        inventory_image = base_item_img,
        groups = { ingot = 1, [mat.id .. "_ingot"] = 1 },
    })
end
