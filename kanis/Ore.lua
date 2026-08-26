-- kanis_materials: Ore.lua

local ores = {
    {
        id = "kanilite",
        name = "カニライト鉱石",
        color = "#55eeff",
        is_nether = false,
        y_min = -64,
        y_max = 16,
        chunk_size = 5,
        chunks_per_gp = 4,
    },
    {
        id = "hachilite",
        name = "ハチライト鉱石",
        color = "#ff66aa",
        is_nether = false,
        y_min = -310,
        y_max = -48,
        chunk_size = 4,
        chunks_per_gp = 3,
    },
    {
        id = "momongaite",
        name = "モモンガイト鉱石（ネザー）",
        color = "#9933ff",
        is_nether = true,
        y_min = 0,
        y_max = 120, -- ネザー内の高度
        chunk_size = 4,
        chunks_per_gp = 4,
    },
    {
        id = "ignitz",
        name = "イグニッツ鉱石（ネザー）",
        color = "#ff2222",
        is_nether = true,
        y_min = 10,
        y_max = 60,
        chunk_size = 3,
        chunks_per_gp = 2,
    },
}

for _, ore in ipairs(ores) do
    local node_name = "kanis:" .. ore.id .. "_ore"
    local base_texture = ore.is_nether and "default_netherrack.png" or "default_stone.png"
    local ore_texture = base_texture .. "^[colorize:" .. ore.color .. ":150"

    -- 鉱石ブロックの登録
    minetest.register_node(node_name, {
        description = ore.name,
        tiles = { ore_texture },
        groups = { cracky = 3, choppy = 2, [ore.id .. "_ore"] = 1, mineclonia_ore = 1 },
        is_ground_content = true,
        sounds = default.node_sound_stone_defaults(),
        drop = "kanis:" .. ore.id .. "_ingot", -- 簡易的にインゴット等に（必要に応じて粉や原石に調整可能）
    })

    -- チャンク（鉱脈）状の生成定義
    minetest.register_ore({
        ore_type = "scatter",
        ore = node_name,
        -- ネザー前提の場合のターゲットブロック（Minecloniaのネザーラックや通常石）
        wherein = ore.is_nether and {"mcl_nether:netherrack", "default:netherrack"} or {"default:stone", "mcl_core:stone"},
        clust_scarcity = 12 * 12 * 12, -- チャンクの散らばり具合
        clust_num_ores = ore.chunk_size, -- 1塊あたりの個数
        clust_size = 3,
        y_min = ore.y_min,
        y_max = ore.y_max,
    })
end
