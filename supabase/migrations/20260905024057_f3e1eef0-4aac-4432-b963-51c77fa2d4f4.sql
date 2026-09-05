-- Gear catalog columns
ALTER TABLE public.rod_tiers
  ADD COLUMN IF NOT EXISTS luck_percent numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS speed_percent numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS price_coins numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sort_order integer NOT NULL DEFAULT 0;

ALTER TABLE public.bait_tiers
  ADD COLUMN IF NOT EXISTS luck_percent numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS price_coins numeric NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sort_order integer NOT NULL DEFAULT 0;

DELETE FROM public.rod_tiers WHERE id NOT IN ('starter','uncommon','rare','epic','legendary','mythic');

INSERT INTO public.rod_tiers (id, name, max_catch_weight_kg, luck_percent, speed_percent, price_coins, sort_order) VALUES
  ('starter','Starter Rod',10,0,0,0,1),
  ('uncommon','Uncommon Rod',40,10,5,1000,2),
  ('rare','Rare Rod',100,25,12,10000,3),
  ('epic','Epic Rod',250,50,22,60000,4),
  ('legendary','Legendary Rod',600,80,35,250000,5),
  ('mythic','Mythic Rod',1500,130,50,1000000,6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name, max_catch_weight_kg = EXCLUDED.max_catch_weight_kg,
  luck_percent = EXCLUDED.luck_percent, speed_percent = EXCLUDED.speed_percent,
  price_coins = EXCLUDED.price_coins, sort_order = EXCLUDED.sort_order;

INSERT INTO public.bait_tiers (id, name, rarity_multiplier, luck_percent, price_coins, sort_order) VALUES
  ('basic_bait','Basic Bait','{}'::jsonb,0,0,1),
  ('uncommon_bait','Uncommon Bait','{}'::jsonb,20,1000,2),
  ('rare_bait','Rare Bait','{}'::jsonb,50,15000,3),
  ('epic_bait','Epic Bait','{}'::jsonb,95,120000,4),
  ('legendary_bait','Legendary Bait','{}'::jsonb,160,600000,5),
  ('mythic_bait','Mythic Bait','{}'::jsonb,250,2000000,6)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name, luck_percent = EXCLUDED.luck_percent,
  price_coins = EXCLUDED.price_coins, sort_order = EXCLUDED.sort_order;

-- Player-owned gear (server-only access)
CREATE TABLE IF NOT EXISTS public.player_rods (
  wallet_address text NOT NULL REFERENCES public.profiles(wallet_address) ON DELETE CASCADE,
  rod_id text NOT NULL REFERENCES public.rod_tiers(id) ON DELETE CASCADE,
  equipped boolean NOT NULL DEFAULT false,
  purchased_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (wallet_address, rod_id)
);
CREATE TABLE IF NOT EXISTS public.player_baits (
  wallet_address text NOT NULL REFERENCES public.profiles(wallet_address) ON DELETE CASCADE,
  bait_id text NOT NULL REFERENCES public.bait_tiers(id) ON DELETE CASCADE,
  equipped boolean NOT NULL DEFAULT false,
  purchased_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (wallet_address, bait_id)
);

GRANT ALL ON public.player_rods, public.player_baits TO service_role;
ALTER TABLE public.player_rods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.player_baits ENABLE ROW LEVEL SECURITY;
-- No anon/authenticated policies: all access goes through verified server code.

-- Gives a new player the free starter rod and basic bait, equipped.
CREATE OR REPLACE FUNCTION public.ensure_starter_gear(_wallet text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  INSERT INTO public.player_rods (wallet_address, rod_id, equipped)
  VALUES (_wallet, 'starter', true)
  ON CONFLICT (wallet_address, rod_id) DO NOTHING;

  INSERT INTO public.player_baits (wallet_address, bait_id, equipped)
  VALUES (_wallet, 'basic_bait', true)
  ON CONFLICT (wallet_address, bait_id) DO NOTHING;

  IF NOT EXISTS (SELECT 1 FROM public.player_rods WHERE wallet_address = _wallet AND equipped) THEN
    UPDATE public.player_rods SET equipped = true WHERE wallet_address = _wallet AND rod_id = 'starter';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.player_baits WHERE wallet_address = _wallet AND equipped) THEN
    UPDATE public.player_baits SET equipped = true WHERE wallet_address = _wallet AND bait_id = 'basic_bait';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_player_rods(_wallet text)
RETURNS TABLE (
  rod_id text, name text, max_catch_weight_kg numeric, luck_percent numeric,
  speed_percent numeric, price_coins numeric, equipped boolean, purchased_at timestamptz
) LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  PERFORM public.ensure_starter_gear(_wallet);
  RETURN QUERY
  SELECT t.id, t.name, t.max_catch_weight_kg, t.luck_percent, t.speed_percent, t.price_coins,
         coalesce(p.equipped, false), p.purchased_at
  FROM public.rod_tiers t
  LEFT JOIN public.player_rods p ON p.rod_id = t.id AND p.wallet_address = _wallet
  ORDER BY t.sort_order, t.price_coins;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_player_baits(_wallet text)
RETURNS TABLE (
  bait_id text, name text, luck_percent numeric, price_coins numeric,
  equipped boolean, purchased_at timestamptz
) LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  PERFORM public.ensure_starter_gear(_wallet);
  RETURN QUERY
  SELECT t.id, t.name, t.luck_percent, t.price_coins,
         coalesce(p.equipped, false), p.purchased_at
  FROM public.bait_tiers t
  LEFT JOIN public.player_baits p ON p.bait_id = t.id AND p.wallet_address = _wallet
  ORDER BY t.sort_order, t.price_coins;
END;
$$;

CREATE OR REPLACE FUNCTION public.buy_rod(_wallet text, _rod_id text)
RETURNS public.profiles LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  cost numeric;
  result public.profiles;
BEGIN
  PERFORM public.ensure_starter_gear(_wallet);
  SELECT price_coins INTO cost FROM public.rod_tiers WHERE id = _rod_id;
  IF cost IS NULL THEN RAISE EXCEPTION 'Unknown rod'; END IF;
  IF EXISTS (SELECT 1 FROM public.player_rods WHERE wallet_address = _wallet AND rod_id = _rod_id) THEN
    RAISE EXCEPTION 'You already own this rod';
  END IF;
  UPDATE public.profiles SET coins = coins - cost, updated_at = now()
   WHERE wallet_address = _wallet AND coins >= cost
  RETURNING * INTO result;
  IF result IS NULL THEN RAISE EXCEPTION 'Not enough coins'; END IF;

  INSERT INTO public.player_rods (wallet_address, rod_id, equipped) VALUES (_wallet, _rod_id, true);
  UPDATE public.player_rods SET equipped = (rod_id = _rod_id) WHERE wallet_address = _wallet;
  RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION public.buy_bait(_wallet text, _bait_id text)
RETURNS public.profiles LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  cost numeric;
  result public.profiles;
BEGIN
  PERFORM public.ensure_starter_gear(_wallet);
  SELECT price_coins INTO cost FROM public.bait_tiers WHERE id = _bait_id;
  IF cost IS NULL THEN RAISE EXCEPTION 'Unknown bait'; END IF;
  IF EXISTS (SELECT 1 FROM public.player_baits WHERE wallet_address = _wallet AND bait_id = _bait_id) THEN
    RAISE EXCEPTION 'You already own this bait';
  END IF;
  UPDATE public.profiles SET coins = coins - cost, updated_at = now()
   WHERE wallet_address = _wallet AND coins >= cost
  RETURNING * INTO result;
  IF result IS NULL THEN RAISE EXCEPTION 'Not enough coins'; END IF;

  INSERT INTO public.player_baits (wallet_address, bait_id, equipped) VALUES (_wallet, _bait_id, true);
  UPDATE public.player_baits SET equipped = (bait_id = _bait_id) WHERE wallet_address = _wallet;
  RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION public.equip_rod(_wallet text, _rod_id text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  PERFORM public.ensure_starter_gear(_wallet);
  IF NOT EXISTS (SELECT 1 FROM public.player_rods WHERE wallet_address = _wallet AND rod_id = _rod_id) THEN
    RAISE EXCEPTION 'You do not own this rod';
  END IF;
  UPDATE public.player_rods SET equipped = (rod_id = _rod_id) WHERE wallet_address = _wallet;
END;
$$;

CREATE OR REPLACE FUNCTION public.equip_bait(_wallet text, _bait_id text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  PERFORM public.ensure_starter_gear(_wallet);
  IF NOT EXISTS (SELECT 1 FROM public.player_baits WHERE wallet_address = _wallet AND bait_id = _bait_id) THEN
    RAISE EXCEPTION 'You do not own this bait';
  END IF;
  UPDATE public.player_baits SET equipped = (bait_id = _bait_id) WHERE wallet_address = _wallet;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.ensure_starter_gear(text) FROM anon, authenticated, public;
REVOKE EXECUTE ON FUNCTION public.get_player_rods(text) FROM anon, authenticated, public;
REVOKE EXECUTE ON FUNCTION public.get_player_baits(text) FROM anon, authenticated, public;
REVOKE EXECUTE ON FUNCTION public.buy_rod(text, text) FROM anon, authenticated, public;
REVOKE EXECUTE ON FUNCTION public.buy_bait(text, text) FROM anon, authenticated, public;
REVOKE EXECUTE ON FUNCTION public.equip_rod(text, text) FROM anon, authenticated, public;
REVOKE EXECUTE ON FUNCTION public.equip_bait(text, text) FROM anon, authenticated, public;

GRANT EXECUTE ON FUNCTION public.get_player_rods(text) TO service_role;
GRANT EXECUTE ON FUNCTION public.get_player_baits(text) TO service_role;
GRANT EXECUTE ON FUNCTION public.buy_rod(text, text) TO service_role;
GRANT EXECUTE ON FUNCTION public.buy_bait(text, text) TO service_role;
GRANT EXECUTE ON FUNCTION public.equip_rod(text, text) TO service_role;
GRANT EXECUTE ON FUNCTION public.equip_bait(text, text) TO service_role;
GRANT EXECUTE ON FUNCTION public.ensure_starter_gear(text) TO service_role;