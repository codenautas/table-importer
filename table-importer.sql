drop schema if exists tab_impo cascade;
drop schema if exists tab_impo_temp cascade;

create schema tab_impo; 
create schema tab_impo_temp; 

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
  select case when                        texto ~ '^\d+$'                           then 1 else 0 end
       | case when                        texto ~ ('^\d*\'||punto_decimal||'?\d*$') and texto<>punto_decimal then 2 else 0 end
       | case when detectar_fechas    and texto ~ '^\d+/\d+/\d+$'                   then 4  else 0 end
       | case when detectar_fechahora and texto ~ '^\d+/\d+/\d+( \d+:\d+:\d+)?$'    then 8  else 0 end
       | case when detectar_fechahora and texto ~ '^\d+h\w* -?\d+m\w* -?\d+s\w*$'   then 16 else 0 end
       | case when detectar_bool      and texto in (texto_true, texto_false)        then 32 else 0 end
       | case when texto = texto_null                                               then 65535 else 0 end
$SQL$;

-- ejemplo:
select dato, detect_types(dato, '.', null, '', true, true, true)
  from (select '1' dato
    union select ''
    union select '456.554'
    union select '2018/3/5'
    union select '2018/3/5 10:13:12'
    union select '10h 4min 6seg'
    union select 'true'
  ) x;

create or replace function importar_tabla(
  ruta_archivo text,
  nombre_tabla text,
  separador_campos text,
  delimitador_texto text,
  punto_decimal text,
  separador_miles text default null,
  texto_null text default null,
  detectar_fechas boolean default true,
  detectar_fechahora boolean default true,
  detectar_bool boolean default false, 
  texto_true text default 'true',
  texto_false text default 'false'
) returns text
  language plpgsql
as
$BODY$
declare
  v_nombre_tabla_temp text := nombre_tabla||'-cruda';
  v_create_tabla_texto text;
  v_select_tipos_detectados text;
  v_campos text[];
  v_tipos integer[];
begin
  raise notice 'levantando la tabla';
  drop table if exists tab_impo_temp.tabla_texto;
  drop table if exists tab_impo_temp.una_columna;
  create table tab_impo_temp.una_columna (linea text, orden serial);
  execute format($$COPY tab_impo_temp.una_columna (linea) FROM %1$L DELIMITER E'\1' $$, ruta_archivo);
  select 'create table tab_impo_temp.tabla_texto ('||string_agg(quote_ident(campo)||' text',',')||')',
         'select array['||string_agg(format('bit_and(detect_types(%1$I,%2$L,%3$L,%4$L,%5$L,%6$L,%7$L,%8$L,%9$L))',campo,
                                      punto_decimal,separador_miles,texto_null,detectar_fechas,
                                      detectar_fechahora,detectar_bool,texto_true,texto_false),',')||'] as tipos_detectados from tab_impo_temp.tabla_texto',
         array_agg(campo)                                      
    into v_create_tabla_texto,
         v_select_tipos_detectados,
         v_campos
    from (select linea from tab_impo_temp.una_columna where orden = 1) x,
         lateral regexp_split_to_table(linea, '\'||separador_campos) campo;
  execute v_create_tabla_texto;
  raise notice 'levantando las columnas';
  execute format($$COPY tab_impo_temp.tabla_texto FROM %1$L CSV DELIMITER %2$L HEADER $$, ruta_archivo, separador_campos);
  raise notice 'calculando los tipos';
  execute v_select_tipos_detectados into v_tipos;
  return to_jsonb(v_tipos)::text;
end;
$BODY$;

-- select importar_tabla('c:\temp\recorridos-realizados-2017.csv', 'recorridos_2017', ',', '"', '.');
select importar_tabla('c:\temp\SB11_20101\SB11_20101.txt', 'sb11_201001', '|', '"', '.');