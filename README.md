# Proyecto Base de Datos - Roland Garros 🎾

## 📌 Descripción
Este proyecto fue desarrollado en equipo como parte de la materia de **Bases de Datos**.
El objetivo fue **modelar y construir la base de datos del torneo Roland Garros**, siguiendo todas las etapas del ciclo de diseño y validación de una base de datos relacional.

Se aplicaron conceptos de **modelado conceptual, lógico y físico**, **normalización de tablas**, además de la implementación en **PostgreSQL**, con pruebas mediante consultas y datos de ejemplo.

---

## 📂 Contenido del proyecto
El proyecto está compuesto por los siguientes entregables:

- **1. Historias de Usuario (`1. Historias de usuario.docx`)**
  Documento con las necesidades de los usuarios que interactuarán con la base de datos.
  Sirvió como punto de partida para definir los requerimientos del sistema.

- **2. Modelos Conceptuales**
  - `2.1 Modelo Conceptual p1.png`
  - `2.2 Modelo Conceptual p2.png`
  Diagramas conceptuales que representan entidades, atributos y relaciones del sistema.

- **3. Modelo Lógico (`3. Modelo Lógico.png`)**
  Transformación del modelo conceptual en un modelo lógico para bases de datos relacionales.

- **4. Preguntas (`4. Preguntas (20).docx`)**
  Documento con **20 preguntas de negocio** que se responden utilizando consultas SQL sobre la base de datos.

- **5. Implementación en SQL**
  - `5.1 CreacionDeTablas.sql` → Script para la creación de las tablas en PostgreSQL.
  - `5.2 InsercionDeDatos.sql` → Script con datos de prueba para poblar la base de datos.

- **6. Consultas SQL (`6. Respuestas a preguntas (vistas y funciones).sql`)**
  Archivo con las consultas SQL que responden a las 20 preguntas planteadas.
  Incluye **vistas** y **funciones** que permiten validar la correcta estructura y funcionamiento de la base de datos.

- **README.md**
  Documento de descripción del proyecto.

---

## ⚙️ Tecnologías utilizadas
- **PostgreSQL** como sistema gestor de base de datos.
- **SQL** para la definición de tablas, inserción de datos y consultas.
- Herramientas de modelado para los diagramas conceptuales y lógicos.

---

## 🚀 Metodología
1. **Historias de usuario** → Identificación de necesidades de los usuarios.
2. **Modelado conceptual** → Creación de diagramas E/R iniciales.
3. **Modelado lógico** → Normalización y diseño de tablas.
4. **Normalización de tablas** → Aplicación de reglas de normalización (1FN, 2FN, 3FN) para garantizar integridad y evitar redundancia.
5. **Implementación** → Creación de tablas en PostgreSQL.
6. **Inserción de datos** → Registros de prueba para validar la BD.
7. **Consultas SQL** → Resolución de 20 preguntas mediante algoritmos en SQL.

---

## 📖 Ejecución del proyecto
1. Crear la base de datos en PostgreSQL.
2. Ejecutar el script de **creación de tablas** (`5.1 CreacionDeTablas.sql`).
3. Ejecutar el script de **inserción de datos** (`5.2 InsercionDeDatos.sql`).
4. Probar las **consultas SQL** (`6. Respuestas a preguntas (vistas y funciones).sql`).

---

## 👥 Autores
Proyecto realizado por:
- Alfonso Salazar
- Carolina Gutiérrez
- Samir Bertel

---
