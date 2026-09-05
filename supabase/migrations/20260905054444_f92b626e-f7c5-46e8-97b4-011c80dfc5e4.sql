CREATE OR REPLACE FUNCTION public.level_for_xp(_xp integer)
 RETURNS integer
 LANGUAGE sql
 IMMUTABLE
 SET search_path TO 'public'
AS $function$
  SELECT greatest(1, floor(greatest(_xp, 0) / 500.0)::int + 1);
$function$;

UPDATE public.profiles SET level = public.level_for_xp(xp), updated_at = now();