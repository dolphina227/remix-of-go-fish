INSERT INTO public.fish_species (id, name, color, rarity, min_weight_kg, max_weight_kg, is_monster, base_price_per_kg) VALUES
 ('clownfish','Clownfish','#f5a623','common',5,40,false,4),
 ('mackerel','Mackerel','#8fd0e8','rare',35,120,false,6),
 ('scad','Scad','#a7e0b0','epic',100,300,false,9),
 ('red_snapper','Red Snapper','#e8734a','legendary',280,650,false,14),
 ('baby_tuna','Baby Tuna','#5b7fa6','mythic',600,1300,false,22),
 ('ancient_leviathan','Ancient Leviathan','#1e46b4','mythic',1200,3000,true,40)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.rarity_base_weights (rarity, base_weight) VALUES
 ('common',100),('rare',45),('epic',18),('legendary',6),('mythic',2)
ON CONFLICT (rarity) DO NOTHING;

INSERT INTO public.rod_tiers (id, name, max_catch_weight_kg, luck_percent, speed_percent, price_coins, sort_order) VALUES
 ('starter','Starter Rod',10,0,0,0,1),
 ('uncommon','Uncommon Rod',40,10,5,1000,2),
 ('rare','Rare Rod',100,25,12,10000,3),
 ('epic','Epic Rod',250,50,22,60000,4),
 ('legendary','Legendary Rod',600,80,35,250000,5),
 ('mythic','Mythic Rod',1500,130,50,1000000,6)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.bait_tiers (id, name, rarity_multiplier, luck_percent, price_coins, sort_order) VALUES
 ('basic_bait','Basic Bait','{}'::jsonb,0,0,1),
 ('uncommon_bait','Uncommon Bait','{}'::jsonb,20,1000,2),
 ('rare_bait','Rare Bait','{}'::jsonb,50,15000,3),
 ('epic_bait','Epic Bait','{}'::jsonb,95,120000,4),
 ('legendary_bait','Legendary Bait','{}'::jsonb,160,600000,5),
 ('mythic_bait','Mythic Bait','{}'::jsonb,250,2000000,6)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.weather_effects (weather_kind, bite_window_seconds, rarity_multiplier) VALUES
 ('cerah',1.6,'{}'::jsonb),
 ('berawan',1.6,'{}'::jsonb),
 ('berkabut',1.3,'{"epic":1.3,"legendary":1.3,"mythic":1.3}'::jsonb),
 ('hujan',1.1,'{"epic":1.3,"legendary":1.5,"mythic":1.5}'::jsonb),
 ('badai',0.9,'{"legendary":1.8,"mythic":2.5}'::jsonb)
ON CONFLICT (weather_kind) DO NOTHING;

INSERT INTO public.weather_cycle_config (id, change_interval_seconds, weights) VALUES
 ('default',240,'{"cerah":40,"berawan":25,"berkabut":15,"hujan":12,"badai":8}'::jsonb)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.mutations (key, label, multiplier, drop_weight) VALUES
 ('none','Normal',1,55),
 ('big','Big',1.2,15),
 ('dark','Dark',1.3,10),
 ('albino','Albino',1.4,7),
 ('sparkling','Sparkling',1.5,5)
ON CONFLICT (key) DO NOTHING;

INSERT INTO public.game_config (key, value) VALUES
 ('monster_catch_chance',0.02),
 ('day_length_seconds',720)
ON CONFLICT (key) DO NOTHING;