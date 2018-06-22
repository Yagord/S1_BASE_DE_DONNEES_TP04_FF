LOAD DATA LOCAL INFILE 'C:/Users/Jean-Claude/Desktop/IUT/TP BDD/TP4FichierSource/Personne.txt'
INTO TABLE Personne
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:/Users/Jean-Claude/Desktop/IUT/TP BDD/TP4FichierSource/Film.txt'
INTO TABLE Film
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:/Users/Jean-Claude/Desktop/IUT/TP BDD/TP4FichierSource/Jouer.txt'
INTO TABLE Jouer
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:/Users/Jean-Claude/Desktop/IUT/TP BDD/TP4FichierSource/Cinema.txt'
INTO TABLE Cinema
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:/Users/Jean-Claude/Desktop/IUT/TP BDD/TP4FichierSource/Projection.txt'
INTO TABLE Projection
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

CREATE TABLE Personne(
idPersonne int,
nom varchar(45),
prenom varchar(45),
CONSTRAINT pk_personne PRIMARY KEY (idPersonne)
);

CREATE TABLE Film(
idFilm int,
idRealisateur int,
titfilmre varchar(45),
genre varchar(45),
annee year,
CONSTRAINT pk_film PRIMARY KEY (idFilm)
);

CREATE TABLE Jouer(
idActeur int,
idFilm int,
role varchar(45),
CONSTRAINT pk_jouer PRIMARY KEY (idActeur, idFilm)
);

CREATE TABLE Cinema(
idCinema int,
nom varchar(45),
adresse varchar(45),
CONSTRAINT pk_cinema PRIMARY KEY (idCinema)
);

CREATE TABLE Projection(
idCinema int,
idFilm int,
jour date,
CONSTRAINT pk_projection PRIMARY KEY (idCinema, idFilm)
);


ALTER TABLE Film
ADD CONSTRAINT fk_film
FOREIGN KEY (idRealisateur) REFERENCES Personne(idPersonne);

ALTER TABLE Jouer
ADD CONSTRAINT fk_jouer
FOREIGN KEY (idActeur) REFERENCES Personne(idPersonne);

ALTER TABLE Jouer
ADD CONSTRAINT fk_jouer2
FOREIGN KEY (idFilm) REFERENCES Film(idFilm);

ALTER TABLE Projection
ADD CONSTRAINT fk_projection
FOREIGN KEY (idCinema) REFERENCES Cinema(idCinema);

ALTER TABLE Projection
ADD CONSTRAINT fk_projection2
FOREIGN KEY (idFilm) REFERENCES Film(idFilm);




SELECT titre
FROM Film
WHERE genre = 'Drame';

SELECT titre
FROM Film NATURAL JOIN Projection NATURAL JOIN Cinema
WHERE Cinema.nom = 'Le Fontenelle';

SELECT prenom, nom
FROM Personne INNER JOIN Film ON idPersonne = idRealisateur;

SELECT prenom, nom
FROM Personne INNER JOIN Jouer ON idPersonne = idActeur;

SELECT prenom, nom
FROM Personne INNER JOIN Film ON idPersonne = idRealisateur
UNION
SELECT prenom, nom
FROM Personne INNER JOIN Jouer ON idPersonne = idActeur;

SELECT titre
FROM Film
WHERE annee = 2002;

SELECT titre
FROM Film INNER JOIN Personne ON idRealisateur = idPersonne
WHERE idPersonne = 'Lars Von Trier';

SELECT idPersonne, nom
FROM Personne INNER JOIN FILM ON idPersonne = idRealisateur
WHERE genre = 'Epouvante' OR genre = 'Dramatique';

SELECT idPersonne, nom
FROM Personne INNER JOIN Jouer ON idPersonne = idActeur NATURAL JOIN Film
WHERE NOT EXISTS (
SELECT idPersonne, nom
FROM Personne INNER JOIN Jouer ON idPersonne = idActeur NATURAL JOIN Film
WHERE genre = 'Dramatique');

SELECT Personne.idPersonne, Personne.nom
FROM Personne INNER JOIN Jouer ON (Personne.idPersonne = Jouer.idActeur) INNER JOIN Film ON (Jouer.idFilm = Film.idFilm) INNER JOIN Projection ON (Film.idFilm = Projection.idFilm) INNER JOIN Cinema ON (Projection.idCinema = Cinema.idCinema)
WHERE Cinema.nom = 'Le Fonctenelle' AND Film.annee >= 2000;

SELECT Personne.nom, Personne.prenom
FROM Personne INNER JOIN Film ON (Personne.idPersonne = Film.idRealisateur) INNER JOIN Jouer ON (Film.idFilm = Jouer.idFilm)
WHERE Film.idRealisateur = Jouer.idActeur;

SELECT Cinema.idCinema, Cinema.nom
FROM Cinema NATURAL JOIN Projection NATURAL JOIN Film
GROUP BY Cinema.idCinema
HAVING COUNT(Projection.idFilm) = (SELECT COUNT(Film.idFilm) FROM Film);