PGDMP     /    8        	        x            mowo_o    12.3    12.3 `    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    44342    mowo_o    DATABASE     �   CREATE DATABASE mowo_o WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Spain.1252' LC_CTYPE = 'Spanish_Spain.1252';
    DROP DATABASE mowo_o;
                administrador    false                        2615    44343    mowo    SCHEMA        CREATE SCHEMA mowo;
    DROP SCHEMA mowo;
                administrador    false            �            1255    52520 '   f_activar_desacti_course(integer, text)    FUNCTION     �  CREATE FUNCTION mowo.f_activar_desacti_course(id_curso integer DEFAULT 0, opt text DEFAULT ''::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

	--VARIABLES SQL ****************************************************
	sqlActivar TEXT;
	sqlDesactivar TEXT;
	
	cont INTEGER;

BEGIN

	cont := 1;

	IF opt = 'A' THEN
		
		sqlActivar := 'UPDATE mowo.curso SET estado = 1 WHERE id_curso = '||id_curso||' ';
		
		EXECUTE sqlActivar;
	
		cont := cont + 1;
	
	ELSEIF opt = 'B' THEN
		
		sqlDesactivar := 'UPDATE mowo.curso SET estado = 0 WHERE id_curso = '||id_curso||' ';
		
		EXECUTE sqlDesactivar;
	
		cont := cont + 2;
	
	END IF;
	
	RETURN cont;

END
$$;
 I   DROP FUNCTION mowo.f_activar_desacti_course(id_curso integer, opt text);
       mowo          postgres    false    8            �            1255    44344 $   f_activar_desacti_usu(integer, text)    FUNCTION     �  CREATE FUNCTION mowo.f_activar_desacti_usu(id_usuario integer DEFAULT 0, opt text DEFAULT ''::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

	--VARIABLES SQL ****************************************************
	sqlActivar TEXT;
	sqlDesactivar TEXT;
	
	cont INTEGER;

BEGIN

	cont := 1;

	IF opt = 'A' THEN
		
		sqlActivar := 'UPDATE mowo.usuario SET activo = 1 WHERE id_usuario = '||id_usuario||' ';
		
		EXECUTE sqlActivar;
	
		cont := cont + 1;
	
	ELSEIF opt = 'B' THEN
		
		sqlDesactivar := 'UPDATE mowo.usuario SET activo = 0 WHERE id_usuario = '||id_usuario||' ';
		
		EXECUTE sqlDesactivar;
	
		cont := cont + 2;
	
	END IF;
	
	RETURN cont;

END
$$;
 H   DROP FUNCTION mowo.f_activar_desacti_usu(id_usuario integer, opt text);
       mowo          postgres    false    8            �            1255    44345 5   f_asociar_asignatura(integer, integer, integer, text)    FUNCTION     I  CREATE FUNCTION mowo.f_asociar_asignatura(id_profesor integer, id_asignatura integer, id_curso integer, opt text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 

	sqlInsertP TEXT;
	sqlInsertC TEXT;
	cont INTEGER;
	opcion TEXT;
	

BEGIN

	opcion := opt;
	cont := 0;

	--ASIGNAR ASIGNATURA AL PROFESOR *****************************
	
	IF opcion = 'A' THEN
		
		sqlInsertC := 'INSERT INTO mowo.prof_asig(fk_prof_asig, fk_asig_prof)VALUES('||id_asignatura||', '||id_profesor||');';
		EXECUTE sqlInsertC;
		cont := cont + 1;
		
	
	--ASIGNAR ASIGNATURA AL CURSO *********************************
	
	ELSEIF opcion = 'B' THEN
	
		sqlInsertC := 'INSERT INTO mowo.curso_asignatura(fk_curso_asig, fk_asig_curso)VALUES('||id_asignatura||', '||id_curso||');';
		
		EXECUTE sqlInsertC;
	
		cont := cont - 1;
	
	END IF;
	
	
	RETURN cont;
END 
$$;
 q   DROP FUNCTION mowo.f_asociar_asignatura(id_profesor integer, id_asignatura integer, id_curso integer, opt text);
       mowo          postgres    false    8            �            1255    44346 '   f_asociar_curso(integer, integer, text)    FUNCTION     �  CREATE FUNCTION mowo.f_asociar_curso(id_usuario integer DEFAULT 0, id_curso integer DEFAULT 0, opcion text DEFAULT 'A'::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
	
	--VARIABLES PARA ALMACENAR RESULTADOS DE CONSULTAS
	
	val RECORD;
	
	--VARIABLES SQL ESTUDIANTE
	sqlAsociar TEXT;
	sqlAsignaturas TEXT;
	sqlNotasIni TEXT;
	
	--VARIABLES SQL PROFESOR
	
	sqlAsociarProf TEXT;
	
	cont INT;

BEGIN 
cont := 0;
	--ASOCIAR EL ESTUDIANTE A UN CURSO **********************************************
	IF opcion = 'A' THEN 
	
		sqlAsociar := 'UPDATE mowo.usuario SET fk_curso = '||id_curso||' WHERE id_usuario = '||id_usuario||' AND fk_perfil = 3;';
		--RAISE NOTICE 'asociar % ', sqlAsociar;
		EXECUTE sqlAsociar;

		sqlAsignaturas := 	'SELECT A.id_asignatura 
							FROM mowo.asignaturas A 
								INNER JOIN mowo.curso_asignatura CA ON CA.fk_curso_asig = A.id_asignatura
							WHERE CA.fk_asig_curso = '||id_curso||'
							;';

		FOR val IN EXECUTE sqlAsignaturas  LOOP

			FOR i IN 1..4 LOOP

				sqlNotasIni := 'INSERT INTO mowo.notas(nota1, nota2, nota3, nota4, periodo, fk_asignatura, fk_estudiante)
								VALUES(1.0, 1.0, 1.0, 1.0, '||i||', '||val.id_asignatura||', '||id_usuario||');';

				--RAISE NOTICE ' %', sqlNotasIni; 

				EXECUTE sqlNotasIni;

			END LOOP;

		END LOOP;

		cont := cont+1;
	
	--ASOCIAR EL PROFESOR A UN CURSO **********************************************
	
	ELSEIF opcion = 'B' THEN 
		
		sqlAsociarProf := 'INSERT INTO mowo.prof_curso(fk_curso_prof, fk_prof_curso)VALUES('||id_usuario||', '||id_curso||')';
		
		--RAISE NOTICE 'asoProf %', sqlAsociarProf;
		
		EXECUTE sqlAsociarProf;
		
		cont := cont -1;
	
	END IF;
	
	RETURN cont;

END

$$;
 W   DROP FUNCTION mowo.f_asociar_curso(id_usuario integer, id_curso integer, opcion text);
       mowo          administrador    false    8            �            1255    44347     f_credenciales(text, text, text)    FUNCTION     �  CREATE FUNCTION mowo.f_credenciales(usuario text DEFAULT ''::text, passusu text DEFAULT ''::text, opt text DEFAULT ''::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
	
	id_user INTEGER;
	passRandom TEXT;
	sqlPassUser TEXT;
	sqlUserU TEXT;
	sqlInsertCred TEXT;
	cont INTEGER;
	
BEGIN 
	
	cont:=0;
	
	IF opt = 'A' THEN 
	
		--INGRESAR LA CONTRASEÃ‘A SOLICTADA POR EL USUARIO*****************+***
		
		sqlPassUser := 'UPDATE mowo.credenciales SET passusu = '''||passusu||''' WHERE usuario = '''||usuario||'''; ';
	
		EXECUTE sqlPassUser;
		
		cont := cont - 1;
		
	ELSE
	
		--TRAER EL ID DEL ULTIMO USUARIO INGRESADO, PARA CREAR CREDENCIALES POR DEFECTO******
		
		sqlUserU := 'SELECT id_usuario FROM mowo.usuario ORDER BY id_usuario DESC LIMIT 1';
		
		EXECUTE  sqlUserU INTO id_user;
		
		--CREAR UNA CONTRASEÑA ALEATORIA ***********************
		SELECT md5(random()::text) INTO passRandom;
		
		sqlInsertCred := 'INSERT INTO mowo.credenciales(usuario, passusu, fkcred_usu)
							VALUES('''||usuario||''', '''||passRandom||''','||id_user||')';
		
		EXECUTE sqlInsertCred;
		
		cont := cont + 1;
		
	END IF;
	
	RETURN cont;

END 

$$;
 I   DROP FUNCTION mowo.f_credenciales(usuario text, passusu text, opt text);
       mowo          postgres    false    8            �            1255    44348 h   f_insert_notas(double precision, double precision, double precision, double precision, integer, integer)    FUNCTION     �	  CREATE FUNCTION mowo.f_insert_notas(nota1 double precision DEFAULT 1.0, nota2 double precision DEFAULT 1.0, nota3 double precision DEFAULT 1.0, nota4 double precision DEFAULT 1.0, coduser integer DEFAULT 0, codasig integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

	cont INTEGER;
	_periodo INT;
	fechaPeriodo TEXT;
	val RECORD;
	
	--VARIABLES SQL 
	sqlInsert TEXT;

BEGIN

	cont := 1;
	
	
	--SABER LA FECHA DEL AÑO PARA INGRESAR EL PERIODO CORRESPONDIENTE

	SELECT TO_CHAR(CURRENT_DATE,'MM-DD') INTO fechaPeriodo;

	IF fechaPeriodo >= '01-19' AND fechaPeriodo <= '03-19' THEN
		_periodo := 1;
	ELSEIF fechaPeriodo > '03-19' AND fechaPeriodo <= '06-19' THEN
		_periodo := 2;
	ELSEIF fechaPeriodo > '06-19' AND fechaPeriodo <= '09-19' THEN
		_periodo := 3;
	ELSEIF fechaPeriodo > '09-19' AND fechaPeriodo <= '11-19' THEN
		_periodo := 4;
	END IF;

	UPDATE mowo.notas SET nota1=1, nota2=1, nota3=1,nota4=1 WHERE fk_estudiante = coduser AND fk_asignatura = codasig AND periodo = _periodo;

	-- VALIDAR SI EL ESTUDIANTE YA TIENE NOTAS ASIGNADAS 
	SELECT * FROM mowo.notas WHERE fk_estudiante = coduser AND fk_asignatura = codasig AND periodo = _periodo INTO val;

	--INSERTAR LA NOTAS********************************
	
	FOR i IN 1..4 LOOP
		
		IF _periodo = i THEN
			IF val.nota1 = 1 THEN

				sqlInsert := 'UPDATE mowo.notas SET nota1 = '||nota1||' WHERE fk_estudiante = '||coduser||' AND fk_asignatura = '||codasig||' AND periodo = '||_periodo||';';

				RAISE NOTICE ' %', sqlInsert;
				
				EXECUTE sqlInsert;
				
				cont := cont +1;

			END IF;
			IF val.nota2 = 1 THEN

				sqlInsert := 'UPDATE mowo.notas SET nota2 = '||nota2||' WHERE fk_estudiante = '||coduser||' AND fk_asignatura = '||codasig||' AND periodo = '||_periodo||'; ';

				RAISE NOTICE ' %', sqlInsert;
				
				EXECUTE sqlInsert;
				
				cont := cont +1;

			END IF;
			IF val.nota3 = 1 THEN

				sqlInsert := 'UPDATE mowo.notas SET nota3 = '||nota3||' WHERE fk_estudiante = '||coduser||' AND fk_asignatura = '||codasig||' AND periodo = '||_periodo||'; ';

				RAISE NOTICE ' %', sqlInsert;
				
				EXECUTE sqlInsert;
				
				cont := cont +1;

			END IF;
			IF val.nota4 = 1 THEN

				sqlInsert := 'UPDATE mowo.notas SET nota4 = '||nota4||' WHERE fk_estudiante = '||coduser||' AND fk_asignatura = '||codasig||' AND periodo = '||_periodo||'; ';

				RAISE NOTICE ' %', sqlInsert;
				
				EXECUTE sqlInsert;
				
				cont := cont +1;

			END IF;
			
		END IF;
	END LOOP;

	RETURN cont;

END

$$;
 �   DROP FUNCTION mowo.f_insert_notas(nota1 double precision, nota2 double precision, nota3 double precision, nota4 double precision, coduser integer, codasig integer);
       mowo          administrador    false    8            �            1255    44349 �   f_insert_usu(character varying, integer, character varying, character varying, integer, integer, character varying, text, character varying, integer)    FUNCTION     	  CREATE FUNCTION mowo.f_insert_usu(tipoident character varying, numident integer, nomusu character varying, apeusu character varying, fk_perfil integer, telefono integer, direccion character varying, fechnac text, mail character varying, activo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

	--VARIABLES SQL 
	sqlInsert VARCHAR;
	sqlAcudiente VARCHAR;
	cont INT;
	
	--VARIABLES PARA FORMATEAR FECHA ****************************************************
	fecha TEXT;
	fecdate DATE;
	--***********************************************************************************
	
	cred INTEGER;
	id_acud RECORD;
	
		
	
BEGIN
		
	cont := 1;

	fecdate := fechnac;

	--FORMATEAR LA FECHA ENTRANTE A UNA VALIDA POR POSTGRESQL ***************************
	SELECT to_char(fecdate, 'yyyy-mm-dd') INTO fecha ;
	--***********************************************************************************
	
	
	--SI EL NUMERO DE IDENTIFICACION EXISTE NO INSERTA EL USUARIO ***********************
	
	IF NOT EXISTS(SELECT identificacion FROM mowo.usuario WHERE identificacion = numident OR email = mail ) THEN
	
		sqlInsert :='INSERT INTO mowo.usuario(tipo_iden, identificacion, nombre, apellido,telefono
					,direccion,fecha_nacimiento,email, fk_perfil, activo)
					VALUES('''||tipoIdent||''','||numIdent||','''||nomUsu||''','''||apeUsu||'''
					,'||telefono||','''||direccion||''','''||fecha||''', '''||mail||''','||fk_perfil||'
					,'||activo||')';

		--RAISE NOTICE 'sql: %', sqlInsert;

		EXECUTE sqlInsert;

		--INSERTAR CREDENCIALES POR DEFECTO*************************************************

		SELECT mowo.f_credenciales(mail,'1','B') INTO cred;
		
		cont := cont + cred;
		

		--INSERTAR USUARIOS ACUDIENTE ***************************************************************
		IF fk_perfil = 4 THEN

			sqlAcudiente := 'SELECT id_usuario FROM mowo.usuario WHERE fk_perfil = 4 ORDER BY id_usuario DESC LIMIT 1';

			EXECUTE sqlAcudiente INTO id_acud;

			UPDATE mowo.usuario SET id_acudiente = id_acud WHERE id_usuario = id_acud;

		END IF;
		
		
		cont := cont +1;
	
	END IF;
	
--SI RETORNA 1 LA IDENTIFICACION O EL EMAIL YA EXISTE***********************
--SI RETORNA 2 OCURRIO UN ERROR AL INGRESAR CREDENCIALES POR DEFECTO********
--SI RETORNA 3 TODO SE EJECUTO CORRECTAMENTE *******************************
	
RETURN cont;

END
$$;
 �   DROP FUNCTION mowo.f_insert_usu(tipoident character varying, numident integer, nomusu character varying, apeusu character varying, fk_perfil integer, telefono integer, direccion character varying, fechnac text, mail character varying, activo integer);
       mowo          postgres    false    8            �            1255    44351 c   f_modificar_usuario(integer, text, text, bigint, text, text, text, text, integer, integer, integer)    FUNCTION       CREATE FUNCTION mowo.f_modificar_usuario(id_usuario integer DEFAULT 0, nombre text DEFAULT ''::text, apellido text DEFAULT ''::text, telefono bigint DEFAULT 0, direccion text DEFAULT ''::text, fecha_nacimiento text DEFAULT ''::text, email text DEFAULT ''::text, tipo_documento text DEFAULT ''::text, documento integer DEFAULT 0, id_acudiente integer DEFAULT 0, fk_perfil integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	
	fecha_nac TEXT;
	fecha_date DATE;
	
	--VARIABLES SQL ****************************************************
	sqlModiUser TEXT;
	
	cont INTEGER;

BEGIN

	fecha_date := fecha_nacimiento;

	cont := 1;
	
	--FORMATEAR LA FECHA ENTRANTE A UNA VALIDA POR POSTGRESQL ***************************
	SELECT to_char(fecha_date, 'yyyy-mm-dd') INTO fecha_nac;
	
	--***********************************************************************************

	sqlModiUser := 'UPDATE mowo.usuario SET nombre = '''||nombre||''', apellido = '''||apellido||'''
					,telefono = '''||telefono||''', direccion = '''||direccion||'''
					,fecha_nacimiento = '''||fecha_nac||''', email = '''||email||'''
					,tipo_iden = '''||tipo_documento||''', identificacion = '''||documento||'''
					WHERE id_usuario = '||id_usuario||'';

	EXECUTE sqlModiUser;

	cont := cont + 1;

	
	RETURN cont;

END
$$;
 �   DROP FUNCTION mowo.f_modificar_usuario(id_usuario integer, nombre text, apellido text, telefono bigint, direccion text, fecha_nacimiento text, email text, tipo_documento text, documento integer, id_acudiente integer, fk_perfil integer);
       mowo          postgres    false    8            �            1255    44352    f_periodo()    FUNCTION     8  CREATE FUNCTION mowo.f_periodo() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
	
	fechaPeriodo TEXT;
	periodo INTEGER;

BEGIN 
	periodo := 0;
	
	SELECT TO_CHAR(CURRENT_DATE,'MM-DD') INTO fechaPeriodo;
	
	IF fechaPeriodo >= '01-19' AND fechaPeriodo <= '03-19' THEN
		periodo := 1;
	ELSEIF fechaPeriodo > '03-19' AND fechaPeriodo <= '06-19' THEN
		periodo := 2;
	ELSEIF fechaPeriodo > '06-19' AND fechaPeriodo <= '09-19' THEN
		periodo := 3;
	ELSEIF fechaPeriodo > '09-19' AND fechaPeriodo <= '11-19' THEN
		periodo := 4;
	END IF;
	
	RETURN periodo;

END

$$;
     DROP FUNCTION mowo.f_periodo();
       mowo          administrador    false    8            �            1259    44353    asignaturas    TABLE     �   CREATE TABLE mowo.asignaturas (
    id_asignatura integer NOT NULL,
    nombre character varying(50) NOT NULL,
    salon character varying(50)
);
    DROP TABLE mowo.asignaturas;
       mowo         heap    postgres    false    8            �            1259    44356    asignaturas_id_asignatura_seq    SEQUENCE     �   CREATE SEQUENCE mowo.asignaturas_id_asignatura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE mowo.asignaturas_id_asignatura_seq;
       mowo          postgres    false    8    203            �           0    0    asignaturas_id_asignatura_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE mowo.asignaturas_id_asignatura_seq OWNED BY mowo.asignaturas.id_asignatura;
          mowo          postgres    false    204            �            1259    44358    credenciales    TABLE     �   CREATE TABLE mowo.credenciales (
    id_credenciales integer NOT NULL,
    usuario character varying(50) NOT NULL,
    passusu character varying(50) NOT NULL,
    fkcred_usu integer
);
    DROP TABLE mowo.credenciales;
       mowo         heap    postgres    false    8            �            1259    44361     credenciales_id_credenciales_seq    SEQUENCE     �   CREATE SEQUENCE mowo.credenciales_id_credenciales_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE mowo.credenciales_id_credenciales_seq;
       mowo          postgres    false    8    205            �           0    0     credenciales_id_credenciales_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE mowo.credenciales_id_credenciales_seq OWNED BY mowo.credenciales.id_credenciales;
          mowo          postgres    false    206            �            1259    44363    curso    TABLE     �   CREATE TABLE mowo.curso (
    id_curso integer NOT NULL,
    nombre_curso character varying(50),
    codigo integer,
    estado integer
);
    DROP TABLE mowo.curso;
       mowo         heap    postgres    false    8            �            1259    44366    curso_asignatura    TABLE     �   CREATE TABLE mowo.curso_asignatura (
    id_curso_asignatura integer NOT NULL,
    fk_curso_asig integer,
    fk_asig_curso integer
);
 "   DROP TABLE mowo.curso_asignatura;
       mowo         heap    postgres    false    8            �            1259    44369 (   curso_asignatura_id_curso_asignatura_seq    SEQUENCE     �   CREATE SEQUENCE mowo.curso_asignatura_id_curso_asignatura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE mowo.curso_asignatura_id_curso_asignatura_seq;
       mowo          postgres    false    8    208            �           0    0 (   curso_asignatura_id_curso_asignatura_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE mowo.curso_asignatura_id_curso_asignatura_seq OWNED BY mowo.curso_asignatura.id_curso_asignatura;
          mowo          postgres    false    209            �            1259    44371    curso_id_curso_seq    SEQUENCE     �   CREATE SEQUENCE mowo.curso_id_curso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE mowo.curso_id_curso_seq;
       mowo          postgres    false    207    8            �           0    0    curso_id_curso_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE mowo.curso_id_curso_seq OWNED BY mowo.curso.id_curso;
          mowo          postgres    false    210            �            1259    44373    notas    TABLE     S  CREATE TABLE mowo.notas (
    id_notas integer NOT NULL,
    nota1 double precision DEFAULT 1.0 NOT NULL,
    nota2 double precision DEFAULT 1.0 NOT NULL,
    nota3 double precision DEFAULT 1.0 NOT NULL,
    nota4 double precision DEFAULT 1.0 NOT NULL,
    periodo integer NOT NULL,
    fk_asignatura integer,
    fk_estudiante integer
);
    DROP TABLE mowo.notas;
       mowo         heap    postgres    false    8            �            1259    44380    notas_id_notas_seq    SEQUENCE     �   CREATE SEQUENCE mowo.notas_id_notas_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE mowo.notas_id_notas_seq;
       mowo          postgres    false    211    8            �           0    0    notas_id_notas_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE mowo.notas_id_notas_seq OWNED BY mowo.notas.id_notas;
          mowo          postgres    false    212            �            1259    44382    perfil    TABLE     �   CREATE TABLE mowo.perfil (
    id_perfil integer NOT NULL,
    nombre_perfil character varying(50) NOT NULL,
    descripcion character varying(100)
);
    DROP TABLE mowo.perfil;
       mowo         heap    postgres    false    8            �            1259    44385    perfil_id_perfil_seq    SEQUENCE     �   CREATE SEQUENCE mowo.perfil_id_perfil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE mowo.perfil_id_perfil_seq;
       mowo          postgres    false    213    8            �           0    0    perfil_id_perfil_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE mowo.perfil_id_perfil_seq OWNED BY mowo.perfil.id_perfil;
          mowo          postgres    false    214            �            1259    44387 	   prof_asig    TABLE     w   CREATE TABLE mowo.prof_asig (
    id_prof_asig integer NOT NULL,
    fk_prof_asig integer,
    fk_asig_prof integer
);
    DROP TABLE mowo.prof_asig;
       mowo         heap    postgres    false    8            �            1259    44390    prof_asig_id_prof_asig_seq    SEQUENCE     �   CREATE SEQUENCE mowo.prof_asig_id_prof_asig_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE mowo.prof_asig_id_prof_asig_seq;
       mowo          postgres    false    215    8            �           0    0    prof_asig_id_prof_asig_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE mowo.prof_asig_id_prof_asig_seq OWNED BY mowo.prof_asig.id_prof_asig;
          mowo          postgres    false    216            �            1259    44392 
   prof_curso    TABLE     {   CREATE TABLE mowo.prof_curso (
    id_prof_curso integer NOT NULL,
    fk_prof_curso integer,
    fk_curso_prof integer
);
    DROP TABLE mowo.prof_curso;
       mowo         heap    postgres    false    8            �            1259    44395    prof_curso_id_prof_curso_seq    SEQUENCE     �   CREATE SEQUENCE mowo.prof_curso_id_prof_curso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE mowo.prof_curso_id_prof_curso_seq;
       mowo          postgres    false    8    217            �           0    0    prof_curso_id_prof_curso_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE mowo.prof_curso_id_prof_curso_seq OWNED BY mowo.prof_curso.id_prof_curso;
          mowo          postgres    false    218            �            1259    52515    reg_usuario    TABLE     �   CREATE TABLE mowo.reg_usuario (
    identificacion integer,
    nombre character varying(30),
    apellido character varying(30),
    email character varying(100),
    usuario character varying(30),
    insertado date
);
    DROP TABLE mowo.reg_usuario;
       mowo         heap    postgres    false    8            �            1259    44397    usuario    TABLE     �  CREATE TABLE mowo.usuario (
    id_usuario integer NOT NULL,
    tipo_iden character varying(20) NOT NULL,
    identificacion integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    telefono bigint,
    direccion character varying(30),
    fecha_nacimiento date,
    email character varying(40),
    fk_curso integer,
    id_acudiente integer,
    fk_perfil integer,
    activo integer NOT NULL
);
    DROP TABLE mowo.usuario;
       mowo         heap    postgres    false    8            �            1259    44400    usuario_id_usuario_seq    SEQUENCE     �   CREATE SEQUENCE mowo.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE mowo.usuario_id_usuario_seq;
       mowo          postgres    false    8    219            �           0    0    usuario_id_usuario_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE mowo.usuario_id_usuario_seq OWNED BY mowo.usuario.id_usuario;
          mowo          postgres    false    220            �
           2604    44402    asignaturas id_asignatura    DEFAULT     �   ALTER TABLE ONLY mowo.asignaturas ALTER COLUMN id_asignatura SET DEFAULT nextval('mowo.asignaturas_id_asignatura_seq'::regclass);
 F   ALTER TABLE mowo.asignaturas ALTER COLUMN id_asignatura DROP DEFAULT;
       mowo          postgres    false    204    203            �
           2604    44403    credenciales id_credenciales    DEFAULT     �   ALTER TABLE ONLY mowo.credenciales ALTER COLUMN id_credenciales SET DEFAULT nextval('mowo.credenciales_id_credenciales_seq'::regclass);
 I   ALTER TABLE mowo.credenciales ALTER COLUMN id_credenciales DROP DEFAULT;
       mowo          postgres    false    206    205            �
           2604    44404    curso id_curso    DEFAULT     l   ALTER TABLE ONLY mowo.curso ALTER COLUMN id_curso SET DEFAULT nextval('mowo.curso_id_curso_seq'::regclass);
 ;   ALTER TABLE mowo.curso ALTER COLUMN id_curso DROP DEFAULT;
       mowo          postgres    false    210    207            �
           2604    44405 $   curso_asignatura id_curso_asignatura    DEFAULT     �   ALTER TABLE ONLY mowo.curso_asignatura ALTER COLUMN id_curso_asignatura SET DEFAULT nextval('mowo.curso_asignatura_id_curso_asignatura_seq'::regclass);
 Q   ALTER TABLE mowo.curso_asignatura ALTER COLUMN id_curso_asignatura DROP DEFAULT;
       mowo          postgres    false    209    208            �
           2604    44406    notas id_notas    DEFAULT     l   ALTER TABLE ONLY mowo.notas ALTER COLUMN id_notas SET DEFAULT nextval('mowo.notas_id_notas_seq'::regclass);
 ;   ALTER TABLE mowo.notas ALTER COLUMN id_notas DROP DEFAULT;
       mowo          postgres    false    212    211            �
           2604    44407    perfil id_perfil    DEFAULT     p   ALTER TABLE ONLY mowo.perfil ALTER COLUMN id_perfil SET DEFAULT nextval('mowo.perfil_id_perfil_seq'::regclass);
 =   ALTER TABLE mowo.perfil ALTER COLUMN id_perfil DROP DEFAULT;
       mowo          postgres    false    214    213            �
           2604    44408    prof_asig id_prof_asig    DEFAULT     |   ALTER TABLE ONLY mowo.prof_asig ALTER COLUMN id_prof_asig SET DEFAULT nextval('mowo.prof_asig_id_prof_asig_seq'::regclass);
 C   ALTER TABLE mowo.prof_asig ALTER COLUMN id_prof_asig DROP DEFAULT;
       mowo          postgres    false    216    215            �
           2604    44409    prof_curso id_prof_curso    DEFAULT     �   ALTER TABLE ONLY mowo.prof_curso ALTER COLUMN id_prof_curso SET DEFAULT nextval('mowo.prof_curso_id_prof_curso_seq'::regclass);
 E   ALTER TABLE mowo.prof_curso ALTER COLUMN id_prof_curso DROP DEFAULT;
       mowo          postgres    false    218    217            �
           2604    44410    usuario id_usuario    DEFAULT     t   ALTER TABLE ONLY mowo.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('mowo.usuario_id_usuario_seq'::regclass);
 ?   ALTER TABLE mowo.usuario ALTER COLUMN id_usuario DROP DEFAULT;
       mowo          postgres    false    220    219            p          0    44353    asignaturas 
   TABLE DATA           A   COPY mowo.asignaturas (id_asignatura, nombre, salon) FROM stdin;
    mowo          postgres    false    203   ԡ       r          0    44358    credenciales 
   TABLE DATA           S   COPY mowo.credenciales (id_credenciales, usuario, passusu, fkcred_usu) FROM stdin;
    mowo          postgres    false    205   ��       t          0    44363    curso 
   TABLE DATA           E   COPY mowo.curso (id_curso, nombre_curso, codigo, estado) FROM stdin;
    mowo          postgres    false    207   ̣       u          0    44366    curso_asignatura 
   TABLE DATA           [   COPY mowo.curso_asignatura (id_curso_asignatura, fk_curso_asig, fk_asig_curso) FROM stdin;
    mowo          postgres    false    208   $�       x          0    44373    notas 
   TABLE DATA           j   COPY mowo.notas (id_notas, nota1, nota2, nota3, nota4, periodo, fk_asignatura, fk_estudiante) FROM stdin;
    mowo          postgres    false    211   j�       z          0    44382    perfil 
   TABLE DATA           E   COPY mowo.perfil (id_perfil, nombre_perfil, descripcion) FROM stdin;
    mowo          postgres    false    213   �       |          0    44387 	   prof_asig 
   TABLE DATA           K   COPY mowo.prof_asig (id_prof_asig, fk_prof_asig, fk_asig_prof) FROM stdin;
    mowo          postgres    false    215   Q�       ~          0    44392 
   prof_curso 
   TABLE DATA           O   COPY mowo.prof_curso (id_prof_curso, fk_prof_curso, fk_curso_prof) FROM stdin;
    mowo          postgres    false    217   ��       �          0    52515    reg_usuario 
   TABLE DATA           `   COPY mowo.reg_usuario (identificacion, nombre, apellido, email, usuario, insertado) FROM stdin;
    mowo          postgres    false    221   ��       �          0    44397    usuario 
   TABLE DATA           �   COPY mowo.usuario (id_usuario, tipo_iden, identificacion, nombre, apellido, telefono, direccion, fecha_nacimiento, email, fk_curso, id_acudiente, fk_perfil, activo) FROM stdin;
    mowo          postgres    false    219   ޥ       �           0    0    asignaturas_id_asignatura_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('mowo.asignaturas_id_asignatura_seq', 1, false);
          mowo          postgres    false    204            �           0    0     credenciales_id_credenciales_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('mowo.credenciales_id_credenciales_seq', 50, true);
          mowo          postgres    false    206            �           0    0 (   curso_asignatura_id_curso_asignatura_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('mowo.curso_asignatura_id_curso_asignatura_seq', 1, false);
          mowo          postgres    false    209            �           0    0    curso_id_curso_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('mowo.curso_id_curso_seq', 22, true);
          mowo          postgres    false    210            �           0    0    notas_id_notas_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('mowo.notas_id_notas_seq', 32, true);
          mowo          postgres    false    212            �           0    0    perfil_id_perfil_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('mowo.perfil_id_perfil_seq', 1, false);
          mowo          postgres    false    214            �           0    0    prof_asig_id_prof_asig_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('mowo.prof_asig_id_prof_asig_seq', 7, true);
          mowo          postgres    false    216            �           0    0    prof_curso_id_prof_curso_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('mowo.prof_curso_id_prof_curso_seq', 6, true);
          mowo          postgres    false    218            �           0    0    usuario_id_usuario_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('mowo.usuario_id_usuario_seq', 51, true);
          mowo          postgres    false    220            �
           2606    44412    asignaturas asignaturas_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY mowo.asignaturas
    ADD CONSTRAINT asignaturas_pkey PRIMARY KEY (id_asignatura);
 D   ALTER TABLE ONLY mowo.asignaturas DROP CONSTRAINT asignaturas_pkey;
       mowo            postgres    false    203            �
           2606    44414 (   credenciales credenciales_fkcred_usu_key 
   CONSTRAINT     g   ALTER TABLE ONLY mowo.credenciales
    ADD CONSTRAINT credenciales_fkcred_usu_key UNIQUE (fkcred_usu);
 P   ALTER TABLE ONLY mowo.credenciales DROP CONSTRAINT credenciales_fkcred_usu_key;
       mowo            postgres    false    205            �
           2606    44416 %   credenciales credenciales_passusu_key 
   CONSTRAINT     a   ALTER TABLE ONLY mowo.credenciales
    ADD CONSTRAINT credenciales_passusu_key UNIQUE (passusu);
 M   ALTER TABLE ONLY mowo.credenciales DROP CONSTRAINT credenciales_passusu_key;
       mowo            postgres    false    205            �
           2606    44418    credenciales credenciales_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY mowo.credenciales
    ADD CONSTRAINT credenciales_pkey PRIMARY KEY (id_credenciales);
 F   ALTER TABLE ONLY mowo.credenciales DROP CONSTRAINT credenciales_pkey;
       mowo            postgres    false    205            �
           2606    44420 %   credenciales credenciales_usuario_key 
   CONSTRAINT     a   ALTER TABLE ONLY mowo.credenciales
    ADD CONSTRAINT credenciales_usuario_key UNIQUE (usuario);
 M   ALTER TABLE ONLY mowo.credenciales DROP CONSTRAINT credenciales_usuario_key;
       mowo            postgres    false    205            �
           2606    44422 &   curso_asignatura curso_asignatura_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY mowo.curso_asignatura
    ADD CONSTRAINT curso_asignatura_pkey PRIMARY KEY (id_curso_asignatura);
 N   ALTER TABLE ONLY mowo.curso_asignatura DROP CONSTRAINT curso_asignatura_pkey;
       mowo            postgres    false    208            �
           2606    52519    curso curso_nombre_curso_key 
   CONSTRAINT     ]   ALTER TABLE ONLY mowo.curso
    ADD CONSTRAINT curso_nombre_curso_key UNIQUE (nombre_curso);
 D   ALTER TABLE ONLY mowo.curso DROP CONSTRAINT curso_nombre_curso_key;
       mowo            postgres    false    207            �
           2606    44424    curso curso_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY mowo.curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (id_curso);
 8   ALTER TABLE ONLY mowo.curso DROP CONSTRAINT curso_pkey;
       mowo            postgres    false    207            �
           2606    44426    notas notas_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY mowo.notas
    ADD CONSTRAINT notas_pkey PRIMARY KEY (id_notas);
 8   ALTER TABLE ONLY mowo.notas DROP CONSTRAINT notas_pkey;
       mowo            postgres    false    211            �
           2606    44428    perfil perfil_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY mowo.perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (id_perfil);
 :   ALTER TABLE ONLY mowo.perfil DROP CONSTRAINT perfil_pkey;
       mowo            postgres    false    213            �
           2606    44430    prof_asig prof_asig_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY mowo.prof_asig
    ADD CONSTRAINT prof_asig_pkey PRIMARY KEY (id_prof_asig);
 @   ALTER TABLE ONLY mowo.prof_asig DROP CONSTRAINT prof_asig_pkey;
       mowo            postgres    false    215            �
           2606    44432    prof_curso prof_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY mowo.prof_curso
    ADD CONSTRAINT prof_curso_pkey PRIMARY KEY (id_prof_curso);
 B   ALTER TABLE ONLY mowo.prof_curso DROP CONSTRAINT prof_curso_pkey;
       mowo            postgres    false    217            �
           2606    44434 "   usuario usuario_identificacion_key 
   CONSTRAINT     e   ALTER TABLE ONLY mowo.usuario
    ADD CONSTRAINT usuario_identificacion_key UNIQUE (identificacion);
 J   ALTER TABLE ONLY mowo.usuario DROP CONSTRAINT usuario_identificacion_key;
       mowo            postgres    false    219            �
           2606    44436    usuario usuario_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY mowo.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);
 <   ALTER TABLE ONLY mowo.usuario DROP CONSTRAINT usuario_pkey;
       mowo            postgres    false    219            �
           2606    44437    usuario fkacudiente    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.usuario
    ADD CONSTRAINT fkacudiente FOREIGN KEY (id_acudiente) REFERENCES mowo.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY mowo.usuario DROP CONSTRAINT fkacudiente;
       mowo          postgres    false    219    2789    219            �
           2606    44442    curso_asignatura fkasigcurso    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.curso_asignatura
    ADD CONSTRAINT fkasigcurso FOREIGN KEY (fk_asig_curso) REFERENCES mowo.curso(id_curso) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY mowo.curso_asignatura DROP CONSTRAINT fkasigcurso;
       mowo          postgres    false    208    207    2775            �
           2606    44447    notas fkasignatura    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.notas
    ADD CONSTRAINT fkasignatura FOREIGN KEY (fk_asignatura) REFERENCES mowo.asignaturas(id_asignatura) ON UPDATE CASCADE ON DELETE CASCADE;
 :   ALTER TABLE ONLY mowo.notas DROP CONSTRAINT fkasignatura;
       mowo          postgres    false    203    2763    211            �
           2606    44452    prof_asig fkasigprof    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.prof_asig
    ADD CONSTRAINT fkasigprof FOREIGN KEY (fk_asig_prof) REFERENCES mowo.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
 <   ALTER TABLE ONLY mowo.prof_asig DROP CONSTRAINT fkasigprof;
       mowo          postgres    false    219    215    2789            �
           2606    44457    credenciales fkcredusu    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.credenciales
    ADD CONSTRAINT fkcredusu FOREIGN KEY (fkcred_usu) REFERENCES mowo.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
 >   ALTER TABLE ONLY mowo.credenciales DROP CONSTRAINT fkcredusu;
       mowo          postgres    false    219    2789    205            �
           2606    44462    curso_asignatura fkcursoasig    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.curso_asignatura
    ADD CONSTRAINT fkcursoasig FOREIGN KEY (fk_curso_asig) REFERENCES mowo.asignaturas(id_asignatura) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY mowo.curso_asignatura DROP CONSTRAINT fkcursoasig;
       mowo          postgres    false    208    203    2763            �
           2606    44467    prof_curso fkcursoprof    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.prof_curso
    ADD CONSTRAINT fkcursoprof FOREIGN KEY (fk_curso_prof) REFERENCES mowo.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
 >   ALTER TABLE ONLY mowo.prof_curso DROP CONSTRAINT fkcursoprof;
       mowo          postgres    false    2789    217    219            �
           2606    44472    usuario fkcursousu    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.usuario
    ADD CONSTRAINT fkcursousu FOREIGN KEY (fk_curso) REFERENCES mowo.curso(id_curso) ON UPDATE CASCADE ON DELETE CASCADE;
 :   ALTER TABLE ONLY mowo.usuario DROP CONSTRAINT fkcursousu;
       mowo          postgres    false    207    219    2775            �
           2606    44477    notas fkestudiante    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.notas
    ADD CONSTRAINT fkestudiante FOREIGN KEY (fk_estudiante) REFERENCES mowo.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
 :   ALTER TABLE ONLY mowo.notas DROP CONSTRAINT fkestudiante;
       mowo          postgres    false    219    211    2789            �
           2606    44482    usuario fkperfilusu    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.usuario
    ADD CONSTRAINT fkperfilusu FOREIGN KEY (fk_perfil) REFERENCES mowo.perfil(id_perfil) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY mowo.usuario DROP CONSTRAINT fkperfilusu;
       mowo          postgres    false    219    2781    213            �
           2606    44487    prof_asig fkprofasig    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.prof_asig
    ADD CONSTRAINT fkprofasig FOREIGN KEY (fk_prof_asig) REFERENCES mowo.asignaturas(id_asignatura) ON UPDATE CASCADE ON DELETE CASCADE;
 <   ALTER TABLE ONLY mowo.prof_asig DROP CONSTRAINT fkprofasig;
       mowo          postgres    false    2763    203    215            �
           2606    44492    prof_curso fkprofcurso    FK CONSTRAINT     �   ALTER TABLE ONLY mowo.prof_curso
    ADD CONSTRAINT fkprofcurso FOREIGN KEY (fk_prof_curso) REFERENCES mowo.curso(id_curso) ON UPDATE CASCADE ON DELETE CASCADE;
 >   ALTER TABLE ONLY mowo.prof_curso DROP CONSTRAINT fkprofcurso;
       mowo          postgres    false    2775    207    217            p   �   x�-�K�0D��)8j>�	�.�-����QWMz0���p���GA�\�֥�O�o��@W
5)p⎜h�)���Ǡ�=q���X�e����+8I�'*R�����^���c���8�R?���X�U���
�����
�4\}��8���4s*Uua-�,�Z��?7�@�      r   %  x�e��n1�3~�0�ϐs.��մ;��&mVy�L�K�r�C��};��YWFV[FWsr��N��
\���{�@QXCV��=���]�g��
�c���P$��Z��	�Ii��*��
%'f�����#^�W�1�<��_�L�Ua7\}��(�`ILЯ~���v���U�<�:�4Uwg�Y�7gu`N���o?��}���#���?78�Vc�4�H;�r���[b����E/q���[���5���+�W�KH���%�`��v��R�<}YN�ΰ�^Ƥ*TG>k��^�RJ��Tx�      t   H   x�%���@Cѳ�"D��YZ)��:�r�z`��~��
SZ"aŤ&#ɉ����׫�f�~G@�n�D�9      u   6   x����0���0')-���X'�3fTT�t>$-<X�q��^|����       x   p   x�M���0C��a��J�]���H� �a��l��q[���Tp���#�G$� q�!	�I�[f�jo������p�Y-�)x#����H
�#�Xgꜿ��� ����0%�      z   W   x�3�LL����,H-J��QHI�Q d&�%��qq姥�Š���rs����d&敤"+@�r�p&&٩h*��\1z\\\ ��0�      |   1   x�3�4�4�2�B.cN i�i�L9����!H�9�������� �Z      ~      x�3�4�4�2�4�f�FF���\1z\\\ )A)      �      x������ � �      �   [  x�u��n� ���S���0I�e�.��J�ڰ�-	I��O?(ɾ����� )�V�x��RP���ne��z�za�� �,'	+�{m�*dUw��/����:N,cW6��?=��u��SBY�i�J�)��X��)TyN�֝5<���.��l��0NhIx	�6�J��~48��t>���Mmֵ$TDxt�����SÈ#Uv���r�J����PI��N�x?
��@DL���zX{�'�3jq��v�g]"�U��]mN�U�t><�iL��I������1�=�Q%1��(�틷{�����o���p
oG�m6���\X�I1�_�v�e�sG�     