drop schema if exists sb cascade;
create schema sb;

set search_path = sb;

CREATE DOMAIN decimal_coma AS TEXT CHECK (VALUE ~ '^-?\d+,?\d*$');

CREATE TABLE sb11_20101
(
  estu_exam_nombreexamen text,
  estu_estudiante integer,
  periodo integer,
  estu_consecutivo text,
  estu_edad text,
  estu_tipo_documento text,
  estu_pais_reside text,
  estu_genero text,
  estu_nacimiento_dia text,
  estu_nacimiento_mes text,
  estu_nacimiento_anno text,
  estu_cod_reside_mcpio text,
  estu_reside_mcpio text,
  estu_reside_depto text,
  estu_zona_reside text,
  estu_area_reside text,
  cole_valor_pension text,
  estu_trabaja text,
  fami_estrato_vivienda text,
  estu_mpio_presentacion text,
  estu_dept_presentacion text,
  estu_exam_cod_mpio_presentacio integer,
  estu_veces_estado text,
  estu_ano_termino_bachill integer,
  estu_mes_termino_bachill integer,
  fami_educa_padre text,
  fami_educa_madre text,
  fami_ocup_padre text,
  fami_ocup_madre text,
  fami_nivel_sisben text,
  fami_pisos_hogar text,
  fami_personas_hogar text,
  fami_telefono_fijo text,
  fami_celular text,
  fami_internet text,
  fami_servicio_television text,
  fami_computador text,
  fami_lavadora text,
  fami_nevera text,
  fami_horno text,
  fami_dvd text,
  fami_microondas text,
  fami_automovil text,
  fami_ing_fmiliar_mensual text,
  cole_cod_icfes text,
  cole_cod_dane_institucion text,
  cole_nombre_sede text,
  cole_cod_mcpio_ubicacion text,
  cole_calendario text,
  cole_genero text,
  cole_naturaleza text,
  cole_bilingue text,
  cole_jornada text,
  cole_caracter text,
  punt_lenguaje decimal_coma,
  punt_matematicas decimal_coma,
  punt_c_sociales decimal_coma,
  punt_filosofia decimal_coma,
  punt_biologia decimal_coma,
  punt_quimica decimal_coma,
  punt_fisica decimal_coma,
  punt_ingles decimal_coma,
  desemp_ingles text,
  nombre_profundizacion text,
  punt_profundizacion decimal_coma,
  desemp_profundizacion text,
  nombre_interdisciplinar text,
  punt_interdisciplinar text,
  estu_puesto text
);

COPY sb11_20101 FROM 'c:\temp\SB11_20101\SB11_20101.txt' 
  CSV DELIMITER '|' HEADER;

ALTER TABLE sb11_20101 ALTER COLUMN punt_lenguaje TYPE decimal USING replace(punt_lenguaje,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_matematicas    TYPE decimal USING replace(punt_matematicas   ,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_c_sociales     TYPE decimal USING replace(punt_c_sociales    ,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_filosofia      TYPE decimal USING replace(punt_filosofia     ,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_biologia       TYPE decimal USING replace(punt_biologia      ,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_quimica        TYPE decimal USING replace(punt_quimica       ,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_fisica         TYPE decimal USING replace(punt_fisica        ,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_ingles         TYPE decimal USING replace(punt_ingles        ,',','.')::decimal;
ALTER TABLE sb11_20101 ALTER COLUMN   punt_profundizacion TYPE decimal USING replace(punt_profundizacion,',','.')::decimal;