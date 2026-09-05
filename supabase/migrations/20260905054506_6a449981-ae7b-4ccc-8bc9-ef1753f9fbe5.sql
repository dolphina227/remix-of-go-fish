REVOKE EXECUTE ON FUNCTION public.level_for_xp(integer) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.level_for_xp(integer) TO service_role;