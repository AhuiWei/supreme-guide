DROP TABLE Personne CASCADE CONSTRAINT;
DROP TABLE Auteur CASCADE CONSTRAINT;
DROP TABLE Livre CASCADE CONSTRAINT;
DROP TABLE Ecriture CASCADE CONSTRAINT;
DROP TABLE Exemplaire CASCADE CONSTRAINT;

DROP SEQUENCE SEQ_Personne;
DROP SEQUENCE SEQ_Auteur;
DROP SEQUENCE SEQ_Livre;
DROP SEQUENCE SEQ_Exemplaire;

CREATE TABLE Personne (
	id number(8,0),
	nom varchar2(32),
	prenom varchar2(32),
	pere number(8,0),
	CONSTRAINT pk_Personne PRIMARY KEY(id),
	CONSTRAINT fk_pere FOREIGN KEY(pere) REFERENCES Personne(id)
);

-- S閝uence ?utiliser pour valuer la colonne id de la table Personne
CREATE SEQUENCE SEQ_Personne START WITH 1;

CREATE TABLE Auteur (
	id number(8,0),
	goncourt number(1),
	idPersonne number(8,0),
	CONSTRAINT pk_Auteur PRIMARY KEY(id),
	CONSTRAINT fk_idPersonne FOREIGN KEY(idPersonne) REFERENCES Personne(id)
);

-- S閝uence ?utiliser pour valuer la colonne id de la table Auteur
CREATE SEQUENCE SEQ_Auteur START WITH 1;

CREATE TABLE Livre (
	ISBN number(8,0),
	titre varchar2(32),
	CONSTRAINT pk_Livre PRIMARY KEY(ISBN)
);

-- S閝uence ?utiliser pour valuer la colonne ISBN de la table Livre
CREATE SEQUENCE SEQ_Livre START WITH 1;

CREATE TABLE Ecriture (
	idAuteur number(8,0),
	idLivre number(8,0),
	CONSTRAINT pk_Ecriture PRIMARY KEY(idAuteur, idLivre),
	CONSTRAINT fk_idAuteur FOREIGN KEY(idAuteur) REFERENCES Auteur(id),
	CONSTRAINT fk_idLivre FOREIGN KEY(idLivre) REFERENCES Livre(ISBN)
);

CREATE TABLE Exemplaire (
	id number(8,0),
	prix number(10,2),
	duLivre number(8,0),
	emprunteur number(8,0), 
	dateEmprunt date,
	CONSTRAINT pk_Exemplaire PRIMARY KEY(id),
	CONSTRAINT fk_emprunteur FOREIGN KEY(emprunteur) REFERENCES Personne(id),
	CONSTRAINT fk_duLivre FOREIGN KEY(duLivre) REFERENCES Livre(ISBN)
);

-- S閝uence ?utiliser pour valuer la colonne id de la table Exemplaire
CREATE SEQUENCE SEQ_Exemplaire START WITH 1;

-- Insertion de donn閑s dans le mod鑜e logique
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'A l''image des g閍nts');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Dieux du Stade');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Le Monde comme je le vois');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Harry Potter, tome 6');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'L''Arche des ombres, Tome 1');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Livre sans exemplaire');

INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hawking', 'Stephen', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Goudon', 'Fred', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Jospin', 'Lionel', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Rowling', 'J.K.', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hobb', 'Robin', null);

INSERT INTO Auteur 
       SELECT SEQ_Auteur.NEXTVAL, DECODE(Personne.nom, 'Goudon',0,1), Personne.id  FROM PERSONNE;

INSERT INTO Ecriture SELECT Livre.isbn, Auteur.id FROM Livre, Auteur where Livre.isbn = Auteur.id;

INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hawking', 'Hans', 1);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hawking', 'Jens', 6);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hobb', 'Thierry', 5);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Shaw', 'Andrew', NULL);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Dieter', 'Fensen', NULL);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Baden', 'Thomas', NULL);

INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, 8, TO_DATE('01/04/2015', 'DD/MM/YYYY'));
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, 8, TO_DATE('15/03/2015', 'DD/MM/YYYY'));
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, 9, TO_DATE('10/01/2015', 'DD/MM/YYYY'));
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 22.33 , 3, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 22.33 , 3, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 22.33 , 3, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 23.75 , 4, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 32.78  ,5, NULL, NULL);

--A-3

SELECT TITRE, count(ID)
FROM LIVRE LEFT OUTER JOIN exemplaire ON LIVRE.ISBN=exemplaire.DULIVRE
GROUP BY TITRE;

--A-4
SELECT ID, NVL(Round(SYSDATE-dateEmprunt,2),0)
FROM EXEMPLAIRE;

--A-5
SELECT DISTINCT personne.nom,personne.prenom
FROM personne,auteur
WHERE personne.ID=auteur.ID;

--A-6
SELECT DISTINCT personne.nom,personne.prenom
FROM personne
MINUS SELECT DISTINCT personne.nom,personne.prenom
FROM personne,auteur
WHERE personne.ID=auteur.ID;

--A-7
SELECT  p.nom, p.prenom,
CASE WHEN LEVEL=1 THEN 'self'
     WHEN LEVEL=2 THEN 'father'
     WHEN LEVEL=3 THEN 'grandpere' END AS "LIEN PARENTAL"
FROM personne p
START WITH prenom='Jens' AND nom='Hawking'
CONNECT BY PRIOR p.pere=p.id;

--B-2
DECLARE 
nom VARCHAR(30) :='ROman';
prenom VARCHAR(30) :='Jenie';
BEGIN
dbms_output.putline('      ') || ' ' ||upper(prenom) || ' '|| upper(nom)|| ' '||substr(upper(nom), 1,3);
END;

--B-3 type 用于创建类似于机构体的东西
     create or replace type typ_calendar as object(   
        年 varchar2(8),   
        月 varchar2(8),   
        星期日 varchar2(8),   
        星期一 varchar2(8),   
        星期二 varchar2(8),   
        星期三 varchar2(8),   
        星期四 varchar2(8),   
        星期五 varchar2(8),   
        星期六 varchar2(8),   
        本月最后一日 varchar2(2)   
    );   
  create table tcalendar of typ_calendar; 
  insert into tcalendar   
  select typ_calendar('2010','05','1','2','3','4','5','6','7','31') from dual;
  select * from tcalendar;  
  
  --B-4
  DECLARE 
  nom Personne.nom%TYPE;
  BEGIN
  dbms_output.put_line('valeur par default:'||nom);
  IF(nom is null)THEN
  dbms_output.put_line('nom est null!');
  END IF;
  END;

