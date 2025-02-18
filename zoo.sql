---------------------------------------------------------------------------------------AUTORI-----------------------------------------------------------------------------

/*Veronika Laukova: xlauko00*/
/*Michal Belovec: xbelov04*/

----------------------------------------------------------------------------------------DROP------------------------------------------------------------------------------

DROP TABLE meranie;
DROP TABLE zviera;
DROP TABLE umiestnenie;
DROP TABLE druh;
DROP TABLE osetrovatel;
DROP TABLE administrativny_zamestnanec;
DROP TABLE zamestnanec;
DROP SEQUENCE seq_zviera_id;
DROP MATERIALIZED VIEW poh_potomkov;

-----------------------------------------------------------------------------------CREATE TABLE---------------------------------------------------------------------------

CREATE TABLE zamestnanec(
    login VARCHAR2(10) NOT NULL,
    meno_zam VARCHAR2(40) NOT NULL,
    narodenie_zam DATE,
    adresa VARCHAR2(50),
    telefon NUMERIC(10,0),
    email VARCHAR(50),
    heslo VARCHAR(50),
    CONSTRAINT PK_zamestnanec PRIMARY KEY (login)
);

--Specializace
CREATE TABLE administrativny_zamestnanec(
    login VARCHAR2(10) NOT NULL,
    zameranie VARCHAR2(30) NOT NULL,
    CONSTRAINT PK_ad_zamestnanec PRIMARY KEY (login),
    CONSTRAINT FK_zamest_ad FOREIGN KEY (login) REFERENCES zamestnanec ON DELETE CASCADE
);

--Specializace
CREATE TABLE osetrovatel(
    login VARCHAR2(10) NOT NULL,
    typ_oset VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_osetrovatel PRIMARY KEY (login),
    CONSTRAINT FK_zamest FOREIGN KEY (login) REFERENCES zamestnanec ON DELETE CASCADE
);

CREATE TABLE umiestnenie (
    id_umiest NUMERIC(6,0) NOT NULL,
    typ_umiest VARCHAR(10),
    kapacita NUMERIC(5,0),
    CONSTRAINT PK_umiest PRIMARY KEY (id_umiest)
);

CREATE TABLE druh (
    id_druhu VARCHAR2(50) NOT NULL,
    celad VARCHAR2(50),
    rod VARCHAR2(50),
    CONSTRAINT PK_druh PRIMARY KEY (id_druhu)
);

CREATE TABLE zviera (
    id_zv INT,
    narodenie_zv DATE,
    umrie_zv DATE,
    meno_zv VARCHAR(15),
    pohlavie VARCHAR(1),
    potomkovia NUMERIC(3,0),
    povod VARCHAR(15),
    umiest_zv NUMERIC(6,0),
    druh_zv VARCHAR2(50),
    CONSTRAINT FK_druh FOREIGN KEY (druh_zv) REFERENCES druh ON DELETE CASCADE,
    CONSTRAINT FK_umiestnenie FOREIGN KEY (umiest_zv) REFERENCES umiestnenie,
    CONSTRAINT PK_zviera PRIMARY KEY (id_zv) 
);

CREATE TABLE meranie (
    id_mer NUMERIC(6,0) NOT NULL,
    id_zv INT,
    datum DATE,
    hmotnost_kg NUMERIC(8,2) CHECK(hmotnost_kg>0),
    dlzka_cm NUMERIC(5,0) CHECK(dlzka_cm>0),
    sirka_cm NUMERIC(5,0) CHECK(sirka_cm>0),
    vyska_cm NUMERIC(5,0) CHECK(vyska_cm>0),
    zdravotny_stav VARCHAR2(20),
    login VARCHAR2(10),
    CONSTRAINT FK_vykonal FOREIGN KEY (login) REFERENCES zamestnanec,
    CONSTRAINT FK_meranie_zv FOREIGN KEY (id_zv) REFERENCES zviera,
    CONSTRAINT PK_meranie PRIMARY KEY (id_mer)
);

------------------------------------------------------------------TRIGGER---------------------------------------------------------------------

CREATE SEQUENCE seq_zviera_id;

/*Trigger na automaticke generovanie ID pre tabulku "zviera"*/
CREATE OR REPLACE TRIGGER trg_zviera_id
    BEFORE INSERT ON zviera
    FOR EACH ROW
BEGIN
    SELECT seq_zviera_id.nextval
    INTO :NEW.id_zv
    FROM dual;
END;
/

/*Trigger na zakodovanie hesla zamestnancov*/
CREATE OR REPLACE TRIGGER heslo_hash
    BEFORE INSERT ON zamestnanec
    FOR EACH ROW
BEGIN
    :NEW.heslo := DBMS_OBFUSCATION_TOOLKIT.MD5(input => UTL_I18N.STRING_TO_RAW(:NEW.heslo));
END;
/

-------------------------------------------------------------------INSERT---------------------------------------------------------------------

INSERT INTO zamestnanec
VALUES('novakj88', 'Jan Novák', DATE '1988-10-28', 'Rooseveltova 7, Brno', 771894562, 'novakjan@gmail.com', 'jannovak');

INSERT INTO zamestnanec
VALUES('dokoupim94', 'Marek Dokoupil', DATE '1994-08-29', 'Vevěří 152/5, Brno', 778956421, 'dokoupilmarek@gmail.com', 'mardoko');

INSERT INTO zamestnanec
VALUES('schwarzp80', 'Petr Schwarz', DATE '1980-02-03', 'Rooseveltova 7, Brno', 764851239, 'schwarzpetr@gmail.com', 'petrsch');

INSERT INTO zamestnanec
VALUES('kovaca95', 'Anna Kováčová', DATE '1995-12-20', 'Rooseveltova 7, Brno', 714528369, 'kovacova.anna@gmail.com', 'ankovac');

INSERT INTO zamestnanec
VALUES('xbelov04', 'Michal Belovec', DATE '2001-08-19', 'Osloboditeľov 8, Lučenec', 774992094, 'xbelov04@stud.fit.vutbr.cz', 'michbel');

INSERT INTO zamestnanec
VALUES('xlauko00', 'Veronika Lauková', DATE '2001-07-21', 'Podrečany 231, Podrečany', 754894562, 'xlauko00@stud.fit.vutbr.cz', 'verlauko');

INSERT INTO zamestnanec
VALUES('horvatha95', 'Adriana Horváthová', DATE '1995-11-18', 'Záhrebská 468, Praha 2-Vinohrady', 774568547, 'adka.horvathova@gmail.com', 'adrihor');

INSERT INTO osetrovatel
VALUES('novakj88', 'Lekár');

INSERT INTO osetrovatel
VALUES('kovaca95', 'Ošetrovateľ');

INSERT INTO osetrovatel
VALUES('xlauko00', 'Veterinár');

INSERT INTO osetrovatel
VALUES('schwarzp80', 'Ošetrovateľ');

INSERT INTO administrativny_zamestnanec
VALUES('horvatha95', 'Účtovníctvo');

INSERT INTO administrativny_zamestnanec
VALUES('dokoupim94', 'Pokladna');

INSERT INTO administrativny_zamestnanec
VALUES('xbelov04', 'Správa skladu');

INSERT INTO umiestnenie
VALUES(102678,'pavilon', 50);

INSERT INTO umiestnenie
VALUES(154875,'klietka', 10);

INSERT INTO umiestnenie
VALUES(682459,'klietka', 20);

INSERT INTO umiestnenie
VALUES(457895,'výbeh', 20);

INSERT INTO umiestnenie
VALUES(789456,'pavilon', 30);

INSERT INTO umiestnenie
VALUES(147852,'akvárium', 10);

INSERT INTO umiestnenie
VALUES(102745,'výbeh', 20);

INSERT INTO druh
VALUES('lev púšťový', 'mačkovité', 'panthera');

INSERT INTO druh
VALUES('klaun očkatý', 'sapínovité', 'ampiphrion');

INSERT INTO druh
VALUES('zebra stepná', 'koňovité', 'equus');

INSERT INTO druh
VALUES('slon indický', 'slonovité', 'elephas');

INSERT INTO druh
VALUES('surikata vlnkavá', 'mungovité', 'suricata');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2022-03-05', 'Alex', 'M', 0, 'Zambia', 102678, 'lev púšťový');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2020-01-24', 'Sarah', 'F', 0, 'Zambia', 102678, 'lev púšťový');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2016-11-14', 'Luna', 'F', 2, 'Zambia', 102678, 'lev púšťový');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2015-01-24', 'Simba', 'F', 2, 'Zambia', 102678, 'lev púšťový');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2021-10-22', 'Nemo', 'M', 10, 'Austrália', 147852, 'klaun očkatý');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2021-11-26', 'Dory', 'F', 10, 'Austrália', 147852, 'klaun očkatý');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2022-02-07', 'Felix', 'M', 0, 'Austrália', 147852, 'klaun očkatý');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2020-02-07', 'Cindy', 'F', 0, 'Austrália', 147852, 'klaun očkatý');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2017-04-01', 'Cody', 'M', 0, 'Namíbia', 457895, 'zebra stepná');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2018-05-30', 'Ellie', 'F', 0, 'Namíbia', 457895, 'zebra stepná');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2013-01-27', 'Johan', 'M', 0, 'India', 789456, 'slon indický');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2011-07-07', 'Elsa', 'F', 0, 'India', 789456, 'slon indický');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2019-05-12', 'Zaya', 'F', 3, 'Botswana', 102745, 'surikata vlnkavá');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2021-07-11', 'Pumba', 'M', 0, 'Botswana', 102745, 'surikata vlnkavá');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2018-04-19', 'Timon', 'M', 3, 'Botswana', 102745, 'surikata vlnkavá');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2021-11-07', 'Oscar', 'M', 0, 'Botswana', 102745, 'surikata vlnkavá');

INSERT INTO zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2021-11-07', 'Dave', 'M', 0, 'Botswana', 102745, 'surikata vlnkavá');

INSERT INTO meranie
VALUES(254987, 1, DATE '2022-04-14', 5.28, 68, 20, 37, 'zdravý', 'novakj88');

INSERT INTO meranie
VALUES(254988, 2, DATE '2022-04-13', 50.00, 71, 50, 87, 'zdravý', 'xlauko00');

INSERT INTO meranie
VALUES(254989, 3, DATE '2021-04-13', 40.45, 71, 50, 87, 'chory', 'novakj88');

INSERT INTO meranie
VALUES(254990, 4, DATE '2022-04-13', 57.00, 71, 49, 87, 'zdravý', 'novakj88');

INSERT INTO meranie
VALUES(254991, 4, DATE '2022-04-13', 57.00, 71, 49, 87, 'zdravý', 'xlauko00');

INSERT INTO meranie
VALUES(254992, 5, DATE '2022-04-08', 17.00, 31, 50, 87, 'zdravý', 'schwarzp80');

INSERT INTO meranie
VALUES(254993, 15, DATE '2022-04-08', 4.13, 31, 50, 87, 'chorý', 'xlauko00');

INSERT INTO meranie
VALUES(254994, 9, DATE '2022-04-08', 76.00, 31, 50, 87, 'chorý', 'kovaca95');

INSERT INTO meranie
VALUES(254995, 11, DATE '2022-04-08', 1200.00, 500, 250, 389, 'zdravý', 'kovaca95');

INSERT INTO meranie
VALUES(254996, 16, DATE '2022-04-08', 3.54, 31, 50, 87, 'zdravý', 'schwarzp80');

INSERT INTO meranie
VALUES(254997, 6, DATE '2022-04-08', 0.54, 30, 15, 20, 'zdravý', 'schwarzp80');

INSERT INTO meranie
VALUES(254998, 7, DATE '2022-04-08', 4.64, 28, 42, 87, 'zdravý', 'kovaca95');

INSERT INTO meranie
VALUES(254999, 8, DATE '2022-04-08', 2.74, 49, 38, 26, 'zdravý', 'xlauko00');

INSERT INTO meranie
VALUES(255000, 10, DATE '2022-04-08', 1.24, 62, 20, 58, 'zdravý', 'xlauko00');

INSERT INTO meranie
VALUES(255001, 12, DATE '2022-04-08', 3.67, 35, 46, 82, 'zdravý', 'novakj88');

INSERT INTO meranie
VALUES(255002, 13, DATE '2022-04-08', 7.89, 37, 57, 46, 'zdravý', 'kovaca95');

INSERT INTO meranie
VALUES(255003, 14, DATE '2022-04-08', 10.54, 85, 50, 98, 'zdravý', 'schwarzp80');

INSERT INTO meranie
VALUES(255004, 17, DATE '2022-04-08', 6.14, 94, 56, 42, 'zdravý', 'kovaca95');

-----------------------------------------------------------------SELECT--------------------------------------------------------------------------

/*Ktoré zvieratá meral Ján Novák?*/
SELECT id_zv, meno_zv, datum
FROM zamestnanec NATURAL JOIN meranie NATURAL JOIN zviera
WHERE meno_zam = 'Jan Novák';

/*Koľko je zvierat v jednom druhu?*/
SELECT druh_zv, count(*) pocet
FROM zviera
GROUP BY druh_zv;

/*Ktore zvierata boli merane v roku 2022*/
SELECT *
FROM zviera
WHERE id_zv IN
    (SELECT id_zv
    FROM meranie
    WHERE datum BETWEEN DATE '2022-01-01' AND DATE '2022-12-31');

/*Kolko zvierat sa nachadza v jednotlivych umiestneniach?*/
SELECT typ_umiest, count(id_zv) pocet
FROM zviera JOIN umiestnenie ON zviera.umiest_zv = umiestnenie.id_umiest
GROUP BY typ_umiest;

/*Ktore zvierata boli merane iba zamestnancom s loginom novakj88?*/
SELECT zviera.id_zv, zviera.meno_zv
FROM zviera, meranie
WHERE zviera.id_zv = meranie.id_zv
AND login = 'novakj88'
AND NOT EXISTS (SELECT *
    FROM meranie
    WHERE zviera.id_zv = meranie.id_zv
    AND login <>'novakj88')
ORDER BY zviera.id_zv;

/*Kym bola merana levica Simba?*/
SELECT datum, login
FROM zviera NATURAL JOIN meranie
WHERE meno_zv = 'Simba';

--------------------------------------------------------------DEMONSTRACIA TRIGGEROV--------------------------------------------------------------

/*Lev Alex by mal mat id_zv 1, levica Sarah id_zv 2 a tak dalej, posledne zviera, surikata Dave by malo mat id_zv 17.*/
SELECT Z.id_zv, Z.meno_zv, Z.druh_zv
FROM zviera Z
ORDER BY Z.id_zv;

/*Hesla zamestnancov by mali byt zakodovane.*/
SELECT login, heslo
FROM zamestnanec;

-------------------------------------------------------------------PROCEDURY----------------------------------------------------------------------


/*Procedúra vypočíta priemerný počet zvierat v jednotlivých typoch umiestnení*/
CREATE OR REPLACE PROCEDURE priemerny_pocet_zvierat_v_umiest AS
    priemer_pocet_zv_klietka NUMBER;
    priemer_pocet_zv_pavilon NUMBER;
    priemer_pocet_zv_vybeh NUMBER;
    priemer_pocet_zv_akva NUMBER;
    pocet_klietka NUMBER;
    pocet_pavilon NUMBER;
    pocet_vybeh NUMBER;
    pocet_akva NUMBER;
    pocet_zv_klietka NUMBER;
    pocet_zv_pavilon NUMBER;
    pocet_zv_vybeh NUMBER;
    pocet_zv_akva NUMBER;
BEGIN
    SELECT COUNT(*) INTO pocet_zv_klietka FROM zviera JOIN umiestnenie ON zviera.umiest_zv = umiestnenie.id_umiest WHERE typ_umiest='klietka';
    SELECT COUNT(*) INTO pocet_zv_pavilon FROM zviera JOIN umiestnenie ON zviera.umiest_zv = umiestnenie.id_umiest WHERE typ_umiest='pavilon';
    SELECT COUNT(*) INTO pocet_zv_vybeh FROM zviera JOIN umiestnenie ON zviera.umiest_zv = umiestnenie.id_umiest WHERE typ_umiest='výbeh';
    SELECT COUNT(*) INTO pocet_zv_akva FROM zviera JOIN umiestnenie ON zviera.umiest_zv = umiestnenie.id_umiest WHERE typ_umiest='akvárium';
    SELECT COUNT(*) INTO pocet_klietka FROM umiestnenie U WHERE U.typ_umiest='klietka';
    SELECT COUNT(*) INTO pocet_pavilon FROM umiestnenie U WHERE U.typ_umiest='pavilon'; 
    SELECT COUNT(*) INTO pocet_vybeh FROM umiestnenie U WHERE U.typ_umiest='výbeh'; 
    SELECT COUNT(*) INTO pocet_akva FROM umiestnenie U WHERE U.typ_umiest='akvárium'; 

    priemer_pocet_zv_klietka := pocet_zv_klietka / pocet_klietka;
    priemer_pocet_zv_pavilon := pocet_zv_pavilon / pocet_pavilon;
    priemer_pocet_zv_vybeh := pocet_zv_vybeh / pocet_vybeh;
    priemer_pocet_zv_akva := pocet_zv_akva / pocet_akva;

    DBMS_OUTPUT.put_line('V priemere je '|| priemer_pocet_zv_klietka ||' zvierat v klietkach, '
                        || priemer_pocet_zv_pavilon || ' v pavilonoch, '
                        || priemer_pocet_zv_vybeh || ' vo výbehoch a '
                        || priemer_pocet_zv_akva ||' v akváriách.');

EXCEPTION WHEN ZERO_DIVIDE THEN
        IF pocet_zv_klietka = 0 THEN
            DBMS_OUTPUT.put_line('Neexistuje žiadne umiestnenie typu "klietka".');
        END IF;

        IF pocet_zv_pavilon = 0 THEN
            DBMS_OUTPUT.put_line('Neexistuje žiadne umiestnenie typu "pavilon".');
        END IF;

        IF pocet_zv_vybeh = 0 THEN
            DBMS_OUTPUT.put_line('Neexistuje žiadne umiestnenie typu "výbeh".');
        END IF;

        IF pocet_zv_akva = 0 THEN
            DBMS_OUTPUT.put_line('Neexistuje žiadne umiestnenie typu "akvárium".');
        END IF;
END;
/

/*Spustenie procedúry*/
BEGIN priemerny_pocet_zvierat_v_umiest;
END;
/

/*Procedúra vypočíta priemerné hodnoty meraní od roku 2020 s využitím kurzoru.*/
CREATE OR REPLACE PROCEDURE merania_udaje AS
    meranie_hmotnost meranie.hmotnost_kg%TYPE;
    meranie_dlzka meranie.dlzka_cm%TYPE;
    meranie_sirka meranie.sirka_cm%TYPE;
    meranie_vyska meranie.vyska_cm%TYPE;
    suma_hmotnost NUMBER;
    suma_dlzka NUMBER;
    suma_sirka NUMBER;
    suma_vyska NUMBER;
    hmotnost_priemer NUMBER;
    dlzka_priemer NUMBER;
    sirka_priemer NUMBER;
    vyska_priemer NUMBER;
    pocet_merani NUMBER;
    CURSOR zviera_cursor IS SELECT hmotnost_kg, dlzka_cm , sirka_cm, vyska_cm FROM meranie WHERE datum >= DATE '2020-01-01';

BEGIN

    SELECT COUNT(*) INTO pocet_merani FROM meranie WHERE datum >= DATE '2020-01-01';
    suma_hmotnost := 0;
    suma_dlzka := 0;
    suma_sirka := 0;
    suma_vyska := 0;

    OPEN zviera_cursor;
    LOOP
        FETCH zviera_cursor INTO meranie_hmotnost, meranie_dlzka, meranie_sirka, meranie_vyska;

        EXIT WHEN zviera_cursor%NOTFOUND;

        suma_hmotnost := suma_hmotnost + meranie_hmotnost;
        suma_dlzka := suma_dlzka + meranie_dlzka;
        suma_sirka := suma_sirka + meranie_sirka;
        suma_vyska := suma_vyska + meranie_vyska;

    END LOOP;
    CLOSE zviera_cursor;

    hmotnost_priemer := suma_hmotnost / pocet_merani;
    dlzka_priemer := suma_dlzka / pocet_merani;
    sirka_priemer := suma_sirka / pocet_merani;
    vyska_priemer := suma_vyska / pocet_merani;

    DBMS_OUTPUT.put_line(
        'Priemerne hodnoty merani od roku 2020: hmotnost - ' || hmotnost_priemer || 'kg, dlzka - ' || dlzka_priemer || 'cm, sirka - ' || sirka_priemer || 'cm, vyska - ' || vyska_priemer || 'cm.'
    );

    EXCEPTION WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.put_line(
            'Od roku 2020 neboli vykonane ziadne merania!'
        );
END;
/

/*Spustenie procedúry*/
BEGIN merania_udaje;
END;
/

------------------------------------------------------------------EXPLAIN PLAN--------------------------------------------------------------------

/*SELECT: Ktore zvierata boli merane iba zamestnancom s loginom novakj88?*/
/*Prve spustenie, bez indexu.*/
EXPLAIN PLAN FOR
SELECT zviera.id_zv, zviera.meno_zv
FROM zviera, meranie
WHERE zviera.id_zv = meranie.id_zv
AND login = 'novakj88'
AND NOT EXISTS (SELECT *
    FROM meranie
    WHERE zviera.id_zv = meranie.id_zv
    AND login <>'novakj88')
ORDER BY zviera.id_zv;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/*Index by mal znizit CPU usage.*/
CREATE INDEX index_login ON meranie (login);

/*Druhe spustenie, s indexom.*/
EXPLAIN PLAN FOR
SELECT zviera.id_zv, zviera.meno_zv
FROM zviera, meranie
WHERE zviera.id_zv = meranie.id_zv
AND login = 'novakj88'
AND NOT EXISTS (SELECT *
    FROM meranie
    WHERE zviera.id_zv = meranie.id_zv
    AND login <>'novakj88')
ORDER BY zviera.id_zv;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX index_login;

-------------------------------------------------------------------GRANT PRAV---------------------------------------------------------------------

GRANT ALL ON zamestnanec TO xlauko00;
GRANT ALL ON administrativny_zamestnanec TO xlauko00;
GRANT ALL ON osetrovatel TO xlauko00;
GRANT ALL ON umiestnenie TO xlauko00;
GRANT ALL ON druh TO xlauko00;
GRANT ALL ON zviera TO xlauko00;
GRANT ALL ON meranie TO xlauko00;

GRANT EXECUTE ON priemerny_pocet_zvierat_v_umiest TO xlauko00;
GRANT EXECUTE ON merania_udaje TO xlauko00;

---------------------------------------------------------------MATERIALIZED VIEW------------------------------------------------------------------

/*Materializovany pohlad na potomkov podla druhu, ktory je spustany pouzivatelom xlauko00.*/
CREATE MATERIALIZED VIEW poh_potomkov
REFRESH ON COMMIT AS
    SELECT druh_zv, meno_zv, potomkovia
    FROM xbelov04.zviera;

SELECT * FROM poh_potomkov;

/*Uprava a vkladanie novych dat.*/
UPDATE xbelov04.zviera SET potomkovia=1 WHERE meno_zv='Elsa' AND narodenie_zv=DATE '2011-07-07';

INSERT INTO xbelov04.zviera(narodenie_zv, meno_zv, pohlavie, potomkovia, povod, umiest_zv, druh_zv)
VALUES(DATE '2022-05-02', 'Lili', 'F', 0, 'India', 789456, 'slon indický');
INSERT INTO xbelov04.meranie
VALUES(255005, 18, DATE '2022-05-02', 4.88, 49, 86, 24, 'zdravý', 'novakj88');

SELECT * FROM poh_potomkov;

COMMIT;

/*Pohlad sa aktualizoval.*/
SELECT * FROM poh_potomkov;