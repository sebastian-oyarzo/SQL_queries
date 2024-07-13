-- ejercicio 1 (setup)
CREATE DATABASE desafio3_sebastian_oyarzo_678;

CREATE TABLE usuarios(
    id SERIAL PRIMARY KEY ,
    email VARCHAR ,
    nombre VARCHAR ,
    apellido VARCHAR ,
    rol VARCHAR CHECK (rol IN ('administrador' , 'usuario'))
);

INSERT INTO usuarios (email , nombre , apellido , rol) VALUES
('jose@jose' , 'jose' , 'hernandez' , 'usuario') ,
('maria@maria' , 'maria' , 'fernandez' , 'usuario') ,
('juan@juan' , 'juan' , 'echeverria' , 'administrador') ,
('sebastian@sebastian' , 'sebastian' , 'oyarzo' , 'usuario') ,
('ana@ana' , 'ana' , 'larrain' , 'administrador');

CREATE TABLE post(
    id SERIAL PRIMARY KEY ,
    titulo VARCHAR ,
    contenido text ,
    fecha_creacion TIMESTAMP ,
    fecha_actualizado TIMESTAMP ,
    destacado BOOLEAN ,
    usuario_id BIGINT
);

INSERT INTO post (titulo , contenido , fecha_creacion , fecha_actualizado , destacado ,  usuario_id) VALUES
('como crear una pagina web' , 'paso1 -debes saber muchas cosas , paso2 - debes aplicarlas'
 , '2024-01-01' , '2024-02-03' , true , 3) ,
('tutorial hacer video en youtube' , 'primero tienes que hacer un video y luego subirlo a youtube'
, '2024-01-02' , '2024-02-04' , false , 3) ,
('como descargar juegos de ps2' , 'para descargar juegos debes tener un CD, luego bajar los juegos de internet, con eso ya podras jugar favilmente' , '2024-03-03' , '2024-03-04' , true , 1) ,
('tutorial como adiestrar a tu perro' , 'primero que todo y mas importante, debes tener un perro, el perro tiene que tener 4 patas y debe tener cola peluda' , '2024-02-01' , '2024-02-04' , false , 2) ,
('como volar en avion' , 'debes extender los brazos como alas y correr a gran velocidad, de esa manera podras volar exitosamente' , '2024-01-04' , '2024-02-05' , true , null);

CREATE TABLE comentarios(
    id SERIAL PRIMARY KEY ,
    contenido varchar ,
    fecha_creacion TIMESTAMP ,
    usuario_id BIGINT ,
    post_id BIGINT
);

INSERT into comentarios (contenido , fecha_creacion , usuario_id , post_id) VALUES
('que buen aporte , muchas gracias' , '2024-01-01' ,1 , 1 ) ,
('no me quedo claro cual es la pagina para descargar' , '2024-01-02' ,2 , 1 ) ,
('me encanta como explicas los tutoriales, todo clarisimo' , '2024-01-04' ,3 , 1 ) ,
('sos grande sabelo, me agrego te doy 10 de puntuacion' , '2024-01-05' ,1 , 2 ) ,
('pesimo tutorial, no me funciono, terrible explicacion' , '2024-01-06' ,2 , 2 );

-- ejercicio 2
SELECT u.nombre, u.email , p.titulo , p.contenido
FROM usuarios AS u
INNER JOIN post AS p ON p.usuario_id = u.id;

-- ejercicio 3
SELECT p.id, p.titulo, p.contenido
FROM post AS P
LEFT JOIN usuarios AS u ON u.id = p.usuario_id
WHERE u.rol = 'administrador';

-- ejercicio 4
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios AS u
LEFT JOIN post AS p ON u.id = p.usuario_id
GROUP BY u.id;

-- ejercicio 5
SELECT  u.email
FROM usuarios AS u
INNER JOIN (
    SELECT p.usuario_id, COUNT(p.id) AS cantidad_posts
    FROM post As p
    GROUP BY p.usuario_id
) AS post_counts ON u.id = post_counts.usuario_id
ORDER BY post_counts.cantidad_posts DESC
LIMIT 1;

-- ejercicio 6
SELECT u.nombre, MAX(p.fecha_creacion) AS ultima_fecha
FROM usuarios AS u
LEFT JOIN post AS p ON u.id = p.usuario_id
GROUP BY u.id, u.nombre
ORDER BY ultima_fecha DESC;

-- ejercicio 7
SELECT p.titulo , p.contenido
FROM post AS p
INNER JOIN (
    SELECT c.post_id , COUNT(c.id) AS cantidad_comentarios
    FROM comentarios AS c
    GROUP BY c.post_id
) AS total_comentarios
ON total_comentarios.post_id = p.id
ORDER BY total_comentarios.cantidad_comentarios DESC LIMIT 1;

-- ejercicio 8
SELECT p.titulo , p.contenido , c.contenido , u.email
FROM post AS p
INNER JOIN comentarios AS c ON c.post_id = p.id
INNER JOIN usuarios AS u ON u.id = c.usuario_id;

-- ejercicio 9
SELECT u.nombre, c.contenido
FROM usuarios AS u
LEFT JOIN (
    SELECT c1.usuario_id, c1.contenido, c1.fecha_creacion
    FROM comentarios AS c1
    JOIN (
        SELECT usuario_id, MAX(fecha_creacion) AS ultima_fecha
        FROM comentarios
        GROUP BY usuario_id
    ) AS c2 ON c1.usuario_id = c2.usuario_id AND c1.fecha_creacion = c2.ultima_fecha
) AS c ON u.id = c.usuario_id;

-- ejercicio 10
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios AS u
LEFT JOIN post AS p ON u.id = p.usuario_id
GROUP BY u.id, u.email
HAVING COUNT(p.id) = 0;