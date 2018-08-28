
set search_path = tab_impo, tab_impo_temp, public;


create or replace function detect_types(
  texto text,
  punto_decimal text,
  separador_miles text default null,
  texto_null text default '',
  detectar_fechas boolean default true,
  detectar_fechahora boolean default true,
  detectar_bool boolean default false, 
  texto_true text default 'true',
  texto_false text default 'false'
) returns integer 
  language sql
as
$SQL$
  select case when                        texto ~ '^\d+$'                          then 1 else 0 end
       | case when                        texto ~ ('^\d*'||punto_decimal||'?\d*$') and texto<>punto_decimal then 2 else 0 end
       | case when detectar_fechas    and texto ~ '^\d+/\d+/\d+$'                  then 4  else 0 end
       | case when detectar_fechahora and texto ~ '^\d+/\d+/\d+( \d+:\d+:\d+)?$'   then 8  else 0 end
       | case when detectar_fechahora and texto ~ '^\d+h\w* \d+m\w* \d+s\w*$'      then 16 else 0 end
       | case when detectar_bool      and texto in (texto_true, texto_false)       then 32 else 0 end
       | case when texto = texto_null                                              then 65535 else 0 end
$SQL$;

select dato, detect_types(dato, '.', null, '', true, true, true)
  from (select '1' dato
    union select ''
    union select '456.554'
    union select '2018/3/5'
    union select '2018/3/5 10:13:12'
    union select '10h 4min 6seg'
    union select 'true'
  ) x;