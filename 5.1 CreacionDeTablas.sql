CREATE TABLE Paises(
	idPais SERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(45) not null
);
CREATE TABLE Personas(
	idPersona SERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	apellidos VARCHAR(100) NOT NULL,
	fecha_de_nacimiento DATE NOT NULL CHECK(fecha_de_nacimiento < CURRENT_DATE),
	pais_nacimiento INT NOT NULL,
	
	FOREIGN KEY(pais_nacimiento) REFERENCES Paises(idPais)
);

CREATE TABLE Sexos(
	idSexo SERIAL PRIMARY KEY NOT NULL,
	tipo varchar(20)
);



CREATE TABLE ManoDominante(
	idMano SERIAL PRIMARY KEY NOT NULL,
	tipo VARCHAR(45)
);

CREATE TABLE Jugadores(
	idPersona SERIAL PRIMARY KEY NOT NULL,
	ranking INT,
	altura NUMERIC NOT NULL,
	peso NUMERIC NOT NULL,
	partidos_ganados INT NOT NULL,
	partidos_perdidos INT NOT NULL,
	ganancias INT NOT NULL,
	idSexo INT NOT NULL,
	id_mano_dominante INT NOT NULL,
	
	FOREIGN KEY(idPersona) REFERENCES Personas(idPersona),
	FOREIGN KEY (id_mano_dominante) REFERENCES ManoDominante(idMano),
	FOREIGN KEY (idSexo) REFERENCES Sexos(idSexo)
);

CREATE TABLE Estados(
	idEstado SERIAL PRIMARY KEY NOT NULL,
	tipo VARCHAR(45) NOT NULL
);

CREATE TABLE EstadosDeJugadores(
	idJugador int REFERENCES Jugadores(idPersona),
	idEstado int REFERENCES Estados(idEstado),
	añoInicio int NOT NULL,
	añoFin int,
	
	PRIMARY KEY(idJugador,idEstado)
);


CREATE TABLE Medicos(
	idPersona SERIAL PRIMARY KEY NOT NULL,
	
	FOREIGN KEY (idPersona) REFERENCES Personas(idPersona)
);
CREATE TABLE Especialidades(
	idEspecialidad SERIAL PRIMARY KEY NOT NULL,
	descripción VARCHAR(100) NOT NULL
);
CREATE TABLE EspecialidadesMedicos(
	idMedico INT not null, 
	idEspecialidad INT not null, 
	
	FOREIGN KEY (idMedico) REFERENCES Medicos(idPersona),
	FOREIGN KEY (idEspecialidad) REFERENCES Especialidades(idEspecialidad),
	
	PRIMARY KEY(idMedico,idEspecialidad)
	
	
);

CREATE TABLE Arbitros(
	idPersona SERIAL primary key references Personas(idPersona),
	año_inicio int not null
	
);

CREATE TABLE EdicionesDelTorneo(
	idEdicion_torneo serial primary key NOT NULL,
	año int not null unique
);


CREATE TABLE Etapas(
	idEtapa SERIAL primary key NOT NULL,
	tipo varchar(100) not null,
	premio numeric not null
);
CREATE TABLE Estadios(
	idEstadio serial primary key NOT NULL,
	nombre varchar(300) not null,
	direccion varchar(500) not null,
	cantidad_maxima_expectadores INTEGER not null
);
CREATE TABLE Partidos(
	idPartido serial primary key,
	fecha timestamp not null,
	idEtapa INT not null references Etapas(idEtapa),
	idJugador1 INT NOT NUll references Jugadores(idPersona),
	idJugador2 INT NOT NUll references Jugadores(idPersona),
	idEstadio INT NOT NULL references Estadios(idEstadio),
	idEdicionTorneo INT NOT NULL references EdicionesDelTorneo(idEdicion_torneo)
);

CREATE TABLE ResultadosPartidos(
	idPartido SERIAL PRIMARY KEY NOT NULL,
	idJugadorGanador INT NOT NULL REFERENCES Jugadores(idPersona),
	
	FOREIGN KEY (idPartido) REFERENCES Partidos(idPartido)
);

CREATE TABLE ArbitrosEnPartidos(
	idArbitro int not null references Arbitros(idPersona),
	idPartido int not null references Partidos(idPartido),
	PRIMARY KEY (idArbitro,idPartido)

);

CREATE TABLE MedicosEnPartidos(
	idMedico int not null references Medicos(idPersona),
	idPartido int not null references Partidos(idPartido),
	PRIMARY KEY (idMedico,idPartido)
);
--------------
CREATE TABLE Zonas(
	idZona serial primary key NOT NULL,
	descripcion varchar(45) NOT NULL
);	
CREATE TABLE ZonasDelEstadio(
	idZonaEstadio serial primary key,
	idEstadio int NOT NULL references Estadios(idEstadio),
	idZona INT NOT NULL references Zonas(idZona)
);
CREATE TABLE Guardias(
	idPersona SERIAL primary key references Personas(idPersona),
	horarioTurno TIME not null,
	idZonaEstadio INT NOT NULL references ZonasDelEstadio(idZonaEstadio)
);
CREATE TABLE Categorías(
	idCategoría serial primary key not null,
	tipo varchar(45)
);
CREATE TABLE Productos(
	idProducto serial primary key not null,
	nombre varchar(200) not null,
	precio float not null,
	idCategoría int not null references Categorías(idCategoría)
	
);

create table ProductosEnEstadios(
	idEstadio INT NOT NULL references Estadios(idEstadio),
	idProducto INT not null references Productos(idProducto),
	
	cantidadesDisponibles INTEGER not null,
	primary key(idEstadio,idProducto)
	
);


---------------------------------------------------

CREATE TABLE Entrenadores(
	idPersona SERIAL PRIMARY KEY references Personas(idPersona) ,
	año_inicio INT NOT NULL
);
CREATE TABLE EntrenadoresDeJugadores(
	idJugador INT references Jugadores(idPersona),
	idEntrenador INT references Entrenadores(idPersona),
	PRIMARY KEY(idJugador,idEntrenador)
);

CREATE TABLE Reglas(
	idRegla serial primary key,
	descripción varchar(300) not null,
	fecha DATE not null
);

CREATE TABLE ReglasDelTorneo(
	idRegla int references Reglas(idRegla),
	idEdicion_torneo int references EdicionesDelTorneo(idEdicion_torneo),
	PRIMARY KEY(idRegla,IdEdicion_torneo)
);

CREATE TABLE Campeones(
	idCampeon SERIAL PRIMARY KEY,
	idJugadorMasculino INT references Jugadores(idPersona),
	idJugadorFemenino INT references Jugadores(idPersona),
	idEdicionTorneo INT not null references EdicionesDelTorneo(idEdicion_torneo)
);

CREATE TABLE TipoPatrocinadores(
	idTipoPatrocinador serial primary key NOT NULL,
	tipo varchar (100)
);
CREATE TABLE Patrocinadores(
	idPatrocinador serial primary key NOT NULL,
	nombre varchar(100) not null,
	idTipo int not null references TipoPatrocinadores(idTipoPatrocinador)
);
CREATE TABLE PatrocinadoresDelTorneo(
	idEdicionTorneo INT NOT NULL references EdicionesDelTorneo(idEdicion_torneo),
	idPatrocinador INT NOT NULL references Patrocinadores(idPatrocinador),
	PRIMARY KEY(idEdicionTorneo, idPatrocinador)
);
---------------------------------------------------------------
CREATE TABLE ClasificacionesDeLesiones(
	idClasificacion serial primary key not null,
	tipo varchar(200)
);
CREATE TABLE Lesiones(
	idLesión serial primary key,
	idJugador int not null references Jugadores(idPersona),
	idPartido int not null references Partidos(idPartido),
	idMedico int not null references Medicos(idPersona),
	idClasificacion int not null references ClasificacionesDeLesiones(idClasificacion)
);
CREATE TABLE Periodistas(
	idPersona SERIAL PRIMARY KEY references Personas(idPersona)
);
CREATE TABLE Canales(
	idCanal serial primary key,
	nombre varchar (100)
);

CREATE TABLE CanalesEnPaises(
	idPais int not null references Paises(idPais),
	idCanal int not null references Canales(idCanal),
	
	PRIMARY KEY(idPais,idCanal)
);

CREATE TABLE Noticias(
	idNoticia serial primary key not null,
	fecha DATE not null,
	título varchar(200) not null,
	idPeriodista int not null references Periodistas(idPersona),
	idCanal INT not null references Canales(idCanal)
);

