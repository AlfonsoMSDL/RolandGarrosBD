--1.   ¿Qué árbitros han dirigido partidos en los que jugó el campeón del torneo en 2020?

CREATE OR REPLACE VIEW arbitrosEnPartidosDeCampeones2020 AS

	SELECT DISTINCT p.nombre, p.apellidos
	FROM Personas p
	JOIN Arbitros a ON p.idPersona = a.idPersona
	WHERE EXISTS (
		SELECT 1
		FROM ArbitrosEnPartidos aep
		JOIN Partidos pa ON aep.idPartido = pa.idPartido
		JOIN EdicionesDelTorneo ed ON pa.idEdicionTorneo = ed.idEdicion_torneo
		JOIN Campeones c ON ed.idEdicion_torneo = c.idEdicionTorneo
		WHERE ed.año = 2020
		  AND aep.idArbitro = a.idPersona
		  AND (
			  pa.idJugador1 = c.idJugadorMasculino OR 
			  pa.idJugador2 = c.idJugadorMasculino OR 
			  pa.idJugador1 = c.idJugadorFemenino OR 
			  pa.idJugador2 = c.idJugadorFemenino
		  )
	);

SELECT * FROM arbitrosEnPartidosDeCampeones2020;

--2.	¿En qué estadios se jugaron los partidos de la edición del torneo de 2024?
CREATE OR REPLACE VIEW estadios_partidos_edicion2024 AS
    
	SELECT DISTINCT e.nombre AS estadio
	FROM Partidos p
		JOIN Estadios e ON p.idEstadio = e.idEstadio
		WHERE p.idediciontorneo = (SELECT idedicion_torneo FROM EdicionesDelTorneo
								  WHERE año = 2024);

SELECT * from estadios_partidos_edicion2024;

--3.	¿Cuántos estadios diferentes se utilizaron durante todas las ediciones del torneo?

CREATE OR REPLACE VIEW estadiosDelTorneo As
	SELECT COUNT(DISTINCT idEstadio) AS cantidad_estadios_utilizados
	FROM Partidos;
	
SELECT * from estadiosDelTorneo;
	
--4.	¿Qué jugadores son entrenados por un entrenador dado?

CREATE OR REPLACE FUNCTION jugadores_entrenador(nombreBuscar varchar(45),apellidoBuscar varchar(45))
RETURNS SETOF text AS
$$
	BEGIN
		RETURN QUERY
			SELECT CONCAT(p.nombre,' ',p.apellidos) as Jugador from entrenadoresdejugadores AS ej
				JOIN Jugadores as j ON j.idPersona = ej.idJugador
				JOIN Personas as p ON p.idPersona = j.idPersona
				WHERE ej.idEntrenador = (SELECT idPersona FROM Personas
										WHERE nombre = nombreBuscar  and apellidos = apellidoBuscar );
	END
$$
LANGUAGE 'plpgsql';


SELECT * FROM jugadores_entrenador('Andrés', 'Petrov');


--5.	¿Cuál es la nacionalidad de los jugadores entrenados por cierto entrenador? – función

CREATE OR REPLACE FUNCTION nacionalidadJuagdoresPorEntrenador(nombreBuscar varchar(45),apellidoBuscar varchar(45))
RETURNS SETOF varchar(45) AS
$$
	BEGIN
		RETURN QUERY
			SELECT DISTINCT pa.nombre FROM paises AS pa
				JOIN Personas p ON p.pais_nacimiento = pa.idPais
				JOIN Jugadores j ON j.idPersona = p.idPersona
				JOIN entrenadoresdejugadores AS ej ON p.idPersona = ej.idJugador
			WHERE ej.idEntrenador = (SELECT idPersona FROM Personas
									WHERE nombre = nombreBuscar and apellidos = apellidoBuscar);
									 
	END
$$
LANGUAGE 'plpgsql';

SELECT * from nacionalidadJuagdoresPorEntrenador('Andrés', 'Petrov') as "Nacionalidades";



--6.	¿Cuáles son los partidos que ha dirigido un árbitro específico (por ejemplo, "Juan Pérez")? - función
CREATE OR REPLACE FUNCTION partidos_arbitro(nombreBuscar varchar(45),apellidoBuscar varchar(45))
RETURNS TABLE (
    idPartido INT,
    fecha TIMESTAMP,
    idEtapa INT,
    idJugador1 INT,
    idJugador2 INT,
    idEstadio INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.idPartido,
        p.fecha,
        p.idEtapa,
        p.idJugador1,
        p.idJugador2,
        p.idEstadio FROM Arbitros a
		JOIN Personas per ON a.idPersona = per.idPersona
		JOIN ArbitrosEnPartidos ap ON a.idPersona = ap.idArbitro
		JOIN Partidos p ON ap.idPartido = p.idPartido
    WHERE per.nombre = nombreBuscar and per.apellidos = apellidoBuscar;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM partidos_arbitro('Isabella', 'Torres Ramírez');

--7.	¿Cuáles son los patrocinadores del torneo de 2022?- vista

CREATE OR REPLACE VIEW patrocinadores2022 AS
	SELECT p.idPatrocinador, p.nombre AS nombrePatrocinador, tp.tipo AS tipoPatrocinador FROM Patrocinadores p
		JOIN PatrocinadoresDelTorneo pdt ON p.idPatrocinador = pdt.idPatrocinador
		JOIN EdicionesDelTorneo edt ON pdt.idEdicionTorneo = edt.idEdicion_torneo
		JOIN TipoPatrocinadores tp ON p.idTipo = tp.idTipoPatrocinador
    WHERE edt.año = 2022;

SELECT * from patrocinadores2022;

-- 8.	¿Qué jugadores se lesionaron durante la "Fase de clasificación ronda 1" del torneo del año 2024? - vista
CREATE OR REPLACE VIEW lesionados2024 AS
	SELECT 
		j.idPersona AS idJugador,
		p.nombre AS nombreJugador,
		p.apellidos AS apellidosJugador,
		l.idPartido,
		l.idLesión,
		l.idClasificacion
	FROM Lesiones l
		JOIN Partidos pt ON l.idPartido = pt.idPartido
		JOIN Etapas e ON pt.idEtapa = e.idEtapa
		JOIN Jugadores j ON l.idJugador = j.idPersona
		JOIN Personas p ON j.idPersona = p.idPersona
	WHERE e.tipo = 'Fase de clasificación ronda 1'
		AND EXTRACT(YEAR FROM pt.fecha) = 2024;

SELECT * from lesionados2024;


--9.	¿Cuáles guardias estuvieron asignados a la "Zona de juego" durante la final del torneo del 2020? - vista

CREATE OR REPLACE VIEW guardiasEnCanchaDeFinal2020 AS

		SELECT g.idPersona, p.nombre, p.apellidos
	FROM Guardias g
		JOIN Personas p ON g.idPersona = p.idPersona
		JOIN ZonasDelEstadio ze ON g.idZonaEstadio = ze.idZonaEstadio
		JOIN Zonas z ON ze.idZona = z.idZona
		JOIN Partidos pt ON ze.idEstadio = pt.idEstadio
		JOIN Etapas e ON pt.idEtapa = e.idEtapa
		JOIN EdicionesDelTorneo et ON pt.idEdicionTorneo = et.idEdicion_torneo
	WHERE z.descripcion = 'Zona de juego'
	  AND e.tipo = 'Finalista'
	  AND et.año = 2020;
		
SELECT * FROM guardiasEnCanchaDeFinal2020;

--10.	¿En qué estadio se jugó la final del torneo de una edicion dada?

CREATE OR REPLACE FUNCTION estadioFinalTorneo(ano int)
RETURNS TABLE (nombre varchar(50), direccion varchar(100)) AS
$$
	BEGIN
		RETURN QUERY
		SELECT 
			e.nombre AS nombreEstadio,
			e.direccion AS direccionEstadio
		FROM Partidos p
			JOIN Etapas et ON p.idEtapa = et.idEtapa
			JOIN Estadios e ON p.idEstadio = e.idEstadio
			JOIN EdicionesDelTorneo edt ON edt.idEdicion_torneo = p.idEdicionTorneo
		WHERE et.tipo = 'Finalista' AND edt.año = ano;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM estadioFinalTorneo(2020);

--11.	¿Qué jugadores ambidiestros han llegado a las semifinales en cualquier edición del torneo? 

CREATE OR REPLACE VIEW JugadoresAmbidiestrosEnSemifinales AS
	SELECT DISTINCT j.idPersona, p.nombre, p.apellidos
	FROM Jugadores j
		JOIN Personas p ON j.idPersona = p.idPersona
		JOIN ManoDominante md ON j.id_mano_dominante = md.idMano
		JOIN Partidos pt ON j.idPersona = pt.idJugador1 OR j.idPersona = pt.idJugador2
		JOIN Etapas e ON pt.idEtapa = e.idEtapa
	WHERE md.tipo = 'Ambidiestro'   AND e.tipo = 'Semifinalista';


SELECT * FROM JugadoresAmbidiestrosEnSemifinales;

--12.	¿Cuántos campeonatos ha ganado un jugador dado?

CREATE OR REPLACE FUNCTION contar_campeonatos(nombre_jugador VARCHAR(45), apellidos_jugador VARCHAR(45))
RETURNS INT AS $$
DECLARE
    campeonatos_ganados INT;
BEGIN
    SELECT COUNT(*) campeonatos_ganados INTO campeonatos_ganados
	FROM Campeones c
    	JOIN Jugadores j ON c.idJugadorMasculino = j.idPersona OR c.idJugadorFemenino = j.idPersona
		JOIN Personas p ON p.idPersona = j.idPersona
    WHERE p.nombre = nombre_jugador AND p.apellidos = apellidos_jugador;

    RETURN campeonatos_ganados;
END;
$$ LANGUAGE plpgsql;

SELECT CONCAT(nombre,' ', apellidos) as Jugador, contar_campeonatos(nombre,apellidos) as "Torneos ganados" FROM Personas 
WHERE contar_campeonatos(nombre,apellidos) != 0
ORDER BY "Torneos ganados" DESC;

--13.	¿Cuál es el precio promedio de los productos de tipo Accesorios vendidos en un estadio dado durante el torneo?

CREATE OR REPLACE FUNCTION precio_promedio_Accesorios(id_estadio INT)
RETURNS NUMERIC AS $$
DECLARE
    precio_promedio NUMERIC;
BEGIN
    SELECT AVG(p.precio) precio_promedio INTO precio_promedio
	FROM Productos p
		JOIN ProductosEnEstadios pe ON p.idProducto = pe.idProducto
		JOIN Categorías c ON p.idCategoría = c.idCategoría
    WHERE pe.idEstadio = id_estadio AND c.tipo = 'Accesorios';

    RETURN precio_promedio;
END;
$$ LANGUAGE plpgsql;

SELECT nombre, precio_promedio_Accesorios(idEstadio) AS "Precio promedio de Accesorios" FROM Estadios;

--14.	¿Cuáles son las nacionalidades de los jugadores ambidiestros entrenados por cierto entrenador?

CREATE OR REPLACE FUNCTION nacionalidades_jugadores_ambidiestros_entrenados_por(nombre_entrenador VARCHAR, apellido_entrenador VARCHAR)
RETURNS TABLE(nacionalidad VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT pa.nombre FROM Personas p
		JOIN Entrenadores e ON p.idPersona = e.idPersona
		JOIN EntrenadoresDeJugadores ej ON e.idPersona = ej.idEntrenador
		JOIN Jugadores j ON ej.idJugador = j.idPersona
		JOIN ManoDominante md ON j.id_mano_dominante = md.idMano
		JOIN Personas pj ON j.idPersona = pj.idPersona
		JOIN Paises pa ON pj.pais_nacimiento = pa.idPais
    WHERE md.tipo = 'Ambidiestro' AND p.nombre = nombre_entrenador AND p.apellidos = apellido_entrenador;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM nacionalidades_jugadores_ambidiestros_entrenados_por('Ana','Silva');

SELECT p.idPersona, p.nombre , p.apellidos  FROM Personas p
JOIN Jugadores j ON j.idPersona = p.idPersona;

--Para comprobar:
SELECT  per1.idPersona as "Id Entrenador", CONCAT(per1.nombre,' ',per1.apellidos) as "Nombre entrenador",
	per2.idPersona as "Id jugador" ,CONCAT(per2.nombre,' ',per2.apellidos) as "Nombre jugador", pa.nombre as "Nacionalidad",
	md.tipo FROM EntrenadoresDeJugadores as e
	JOIN Personas per1 ON per1.idPersona = e.idEntrenador
	JOIN Personas per2 ON per2.idPersona = e.idJugador
	JOIN Jugadores j ON per2.idPersona = j.idPersona
	JOIN ManoDominante md ON md.idMano = j.id_mano_dominante
	JOIN Paises pa ON pa.idPais = per2.pais_nacimiento;

--15.	¿Qué noticias han sido publicadas por un periodista dado en un canal dado?
CREATE OR REPLACE FUNCTION noticias_publicadas_por(nombre_periodista VARCHAR, apellido_periodista VARCHAR, nombre_canal VARCHAR)
RETURNS TABLE(idNoticia INT, fecha DATE, título VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT n.idNoticia, n.fecha, n.título FROM Noticias n
		JOIN Periodistas p ON n.idPeriodista = p.idPersona
		JOIN Personas per ON p.idPersona = per.idPersona
		JOIN Canales c ON n.idCanal = c.idCanal
    WHERE per.nombre = nombre_periodista AND per.apellidos = apellido_periodista AND c.nombre = nombre_canal;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM noticias_publicadas_por('Amira', 'Ben Ali', 'NBC');

SELECT p.idPersona, p.nombre , p.apellidos  FROM Personas p
JOIN Periodistas pe ON pe.idPersona = p.idPersona;

SELECT CONCAT(p.nombre,' ',p.apellidos) nombres , c.nombre FROM Noticias n
JOIN Personas p ON p.idpersona = n.idPeriodista
JOIN Canales c ON c.idCanal = n.idCanal;

--16.	¿Cuáles son las manos dominantes más comunes entre los campeones del torneo?

CREATE OR REPLACE VIEW raking_manoDominante_campeones AS

	SELECT md.tipo AS mano_dominante, COUNT(*) AS cantidad
	FROM Campeones c JOIN Jugadores j ON c.idJugadorMasculino = j.idPersona OR c.idJugadorFemenino = j.idPersona
	JOIN ManoDominante md ON j.id_mano_dominante = md.idMano
	GROUP BY md.tipo
	ORDER BY cantidad DESC;

SELECT * FROM raking_manoDominante_campeones;

--17.	¿Qué jugadores fueron los campeónes  de una edición de un torneo dado?

CREATE OR REPLACE FUNCTION obtener_campeones_por_edicion(torneo_ano int) 
RETURNS TABLE (nombre_jugador VARCHAR, apellido_jugador VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT P.nombre, P.apellidos FROM Campeones C
		JOIN Jugadores j ON c.idJugadorMasculino = j.idPersona OR c.idJugadorFemenino = j.idPersona
		JOIN EdicionesDelTorneo E ON C.idEdicionTorneo = E.idEdicion_torneo
		JOIN Personas P ON j.idPersona = P.idPersona
    WHERE E.año = torneo_ano;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM obtener_campeones_por_edicion(2020);

--18.	¿Qué árbitros han dirigido más de un partido en la última edición del torneo?
CREATE OR REPLACE VIEW arbitrosQueDirigieronMasDeUnPartidos AS

	SELECT DISTINCT per.nombre, per.apellidos
	FROM Arbitros A
	JOIN Personas Per ON A.idPersona = Per.idPersona
	JOIN ArbitrosEnPartidos AP ON A.idPersona = AP.idArbitro
	JOIN Partidos P ON AP.idPartido = P.idPartido
	JOIN EdicionesDelTorneo E ON P.idEdicionTorneo = E.idEdicion_torneo
	WHERE E.año = (SELECT MAX(año) FROM EdicionesDelTorneo)
	GROUP BY Per.nombre, Per.apellidos
	HAVING COUNT(AP.idPartido) > 1;

SELECT * FROM arbitrosQueDirigieronMasDeUnPartidos;

--19.	¿Qué patrocinadores han estado presentes en los últimos tres años consecutivos?
CREATE OR REPLACE VIEW PatrocinadoresUltimosTresAños AS
	WITH UltimosTresAños AS (
		SELECT año 
		FROM EdicionesDelTorneo
		ORDER BY año DESC
		LIMIT 3
	),
	PatrocinadoresPorAño AS (
		SELECT pt.idPatrocinador, ed.año AS año
		FROM PatrocinadoresDelTorneo pt
		JOIN EdicionesDelTorneo ed ON pt.idEdicionTorneo = ed.idEdicion_torneo
		WHERE ed.año IN (SELECT año FROM UltimosTresAños)
	)
	SELECT idPatrocinador
	FROM PatrocinadoresPorAño
	GROUP BY idPatrocinador
	HAVING COUNT(DISTINCT año) = 3;

SELECT * FROM PatrocinadoresUltimosTresAños;

--20.	¿Qué jugadores llegaron a las semifinales en la edición del torneo de 2023?

SELECT DISTINCT
    j1.idPersona AS idJugador, 
    p1.nombre AS nombreJugador,
    p1.apellidos AS apellidosJugador
FROM Partidos AS pa
JOIN Etapas AS e ON pa.idEtapa = e.idEtapa
JOIN EdicionesDelTorneo AS et ON pa.idEdicionTorneo = et.idEdicion_torneo
JOIN Jugadores AS j1 ON pa.idJugador1 = j1.idPersona
JOIN Personas AS p1 ON j1.idPersona = p1.idPersona
WHERE et.año = 2023 AND e.tipo = 'Semifinalista'
UNION
SELECT DISTINCT
    j2.idPersona AS idJugador, 
    p2.nombre AS nombreJugador,
    p2.apellidos AS apellidosJugador
FROM Partidos AS pa
JOIN Etapas AS e ON pa.idEtapa = e.idEtapa
JOIN EdicionesDelTorneo AS et ON pa.idEdicionTorneo = et.idEdicion_torneo
JOIN Jugadores AS j2 ON pa.idJugador2 = j2.idPersona
JOIN Personas AS p2 ON j2.idPersona = p2.idPersona
WHERE et.año = 2023 AND e.tipo = 'Semifinalista';

