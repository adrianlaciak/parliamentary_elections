-- Referendum
SELECT * 
FROM referendum;
SELECT referendum.Województwo, 
SUM(referendum.[Liczba_wyborców_którym_wydano_karty_do_g³osowania_w_lokalu_wyborczym_oraz_w_g³osowaniu_korespondencyjnym_³¹cznie]) AS [Liczba osób bior¹cych udzia³ w referendum],
ROUND(CAST(SUM(CAST(referendum.[Liczba_wyborców_którym_wydano_karty_do_g³osowania_w_lokalu_wyborczym_oraz_w_g³osowaniu_korespondencyjnym_³¹cznie] AS FLOAT))/SUM(CAST(Liczba_osób_uprawnionych_do_g³osowania AS FLOAT)) AS DECIMAL(3,2)),2) AS [Procent wyborców bior¹cych udzia³ w referendum],
SUM(Sprawa_1_Liczba_g³osów_niewa¿nych)+SUM(Sprawa_2_Liczba_g³osów_niewa¿nych)+SUM(Sprawa_3_Liczba_g³osów_niewa¿nych)+SUM(Sprawa_4_Liczba_g³osów_niewa¿nych) AS [Liczba g³osów niewa¿nych w 4 pytaniach],
ROUND(CAST(CAST((SUM(Sprawa_1_Liczba_g³osów_niewa¿nych)+SUM(Sprawa_2_Liczba_g³osów_niewa¿nych)+SUM(Sprawa_3_Liczba_g³osów_niewa¿nych)+SUM(Sprawa_4_Liczba_g³osów_niewa¿nych)) AS FLOAT)/CAST(SUM(referendum.[Liczba_wyborców_którym_wydano_karty_do_g³osowania_w_lokalu_wyborczym_oraz_w_g³osowaniu_korespondencyjnym_³¹cznie]) AS FLOAT) AS DECIMAL(2,2)),2) AS [Iloœæ niewa¿nych odpowiedzi na osobê],
ROUND(CAST(CAST(SUM(Sprawa_1_Liczba_g³osów_nie) AS FLOAT)/CAST(SUM(Sprawa_1_Liczba_g³osów_wa¿nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 1 % nie],
ROUND(CAST(CAST(SUM(Sprawa_2_Liczba_g³osów_nie) AS FLOAT)/CAST(SUM(Sprawa_2_Liczba_g³osów_wa¿nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 2 % nie],
ROUND(CAST(CAST(SUM(Sprawa_3_Liczba_g³osów_nie) AS FLOAT)/CAST(SUM(Sprawa_3_Liczba_g³osów_wa¿nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 3 % nie],
ROUND(CAST(CAST(SUM(Sprawa_4_Liczba_g³osów_nie) AS FLOAT)/CAST(SUM(Sprawa_4_Liczba_g³osów_wa¿nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 4 % nie],
SUM(Liczba_osób_g³osuj¹cych_przez_pe³nomocnika) AS [Liczba osób g³osuj¹cych przez pe³nomocnika],
SUM(sejm_wyniki.Liczba_wyborców_którym_wydano_karty_do_g³osowania_w_lokalu_wyborczym_oraz_w_g³osowaniu_korespondencyjnym_³¹cznie) - SUM(referendum.Liczba_wyborców_którym_wydano_karty_do_g³osowania_w_lokalu_wyborczym_oraz_w_g³osowaniu_korespondencyjnym_³¹cznie) AS [Liczba osób, które pobra³y karty do g³osowania bez referendum]
FROM referendum
LEFT JOIN sejm_wyniki ON referendum.Nr_komisji = sejm_wyniki.Nr_komisji AND referendum.Siedziba = sejm_wyniki.Siedziba
WHERE referendum.Województwo IS NOT NULL
GROUP BY referendum.Województwo
ORDER BY [Procent wyborców bior¹cych udzia³ w referendum] DESC,
[Liczba osób bior¹cych udzia³ w referendum] DESC;

--Kandydaci do sejmu, którzy otrzymali mandat
SELECT *
FROM sejm_kandydaci;
SELECT Zawód,
COUNT(Zawód) AS [Liczba kandydatów, którzy otrzymali mandat],
COUNT(CASE WHEN P³eæ = 'Mê¿czyzna' THEN 1 END) AS [Iloœæ mê¿czyzn, którzy otrzymali mandat],
COUNT(CASE WHEN P³eæ = 'Kobieta' THEN 1 END) AS [Iloœæ kobiet, które otrzyma³y mandat],
SUM(Liczba_g³osów) AS [Liczba g³osów],
ROUND(CAST(CAST(SUM(Liczba_g³osów) AS FLOAT)/CAST(COUNT(Zawód) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g³osów na jedn¹ osobê danego zawodu]
FROM sejm_kandydaci
WHERE Czy_przyznano_mandat = 'Tak'
GROUP BY Zawód
ORDER BY COUNT(Zawód) DESC

--Kandydaci do sejmu, którzy nie otrzymali mandatu
SELECT *
FROM sejm_kandydaci;
SELECT Zawód,
COUNT(Zawód) AS [Liczba kandydatów, którzy nie otrzymali mandatu],
COUNT(CASE WHEN P³eæ = 'Mê¿czyzna' THEN 1 END) AS [Iloœæ mê¿czyzn, którzy nie otrzymali mandatu],
COUNT(CASE WHEN P³eæ = 'Kobieta' THEN 1 END) AS [Iloœæ kobiet, które nie otrzyma³y mandatu],
SUM(Liczba_g³osów) AS [Liczba g³osów],
ROUND(CAST(CAST(SUM(Liczba_g³osów) AS FLOAT)/CAST(COUNT(Zawód) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g³osów na jedn¹ osobê danego zawodu]
FROM sejm_kandydaci
WHERE Czy_przyznano_mandat = 'Nie'
GROUP BY Zawód
ORDER BY COUNT(Zawód) DESC

--Kandydaci do senatu, którzy otrzymali mandat
SELECT *
FROM senat_kandydaci;
UPDATE senat_kandydaci
SET Zawód = 'menad¿er'
WHERE Zawód = 'mened¿er';
UPDATE senat_kandydaci
SET Zawód = 'prawnik'
WHERE Zawód = 'prawniczka';
UPDATE senat_kandydaci
SET Zawód = 'socjolog'
WHERE Zawód = 'socjolo¿ka';
SELECT Zawód,
COUNT(Zawód) AS [Liczba kandydatów, którzy otrzymali mandat],
COUNT(CASE WHEN P³eæ = 'Mê¿czyzna' THEN 1 END) AS [Iloœæ mê¿czyzn, którzy otrzymali mandat],
COUNT(CASE WHEN P³eæ = 'Kobieta' THEN 1 END) AS [Iloœæ kobiet, które otrzyma³y mandat],
SUM(Liczba_g³osów) AS [Liczba g³osów],
ROUND(CAST(CAST(SUM(Liczba_g³osów) AS FLOAT)/CAST(COUNT(Zawód) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g³osów na osobê danego zawodu]
FROM senat_kandydaci
WHERE Czy_przyznano_mandat = 'Tak'
GROUP BY Zawód
ORDER BY COUNT(Zawód) DESC

--Kandydaci do senatu, którzy nieotrzymali mandatu
SELECT *
FROM senat_kandydaci;
SELECT Zawód,
COUNT(Zawód) AS [Liczba kandydatów, którzy nie otrzymali mandatu],
COUNT(CASE WHEN P³eæ = 'Mê¿czyzna' THEN 1 END) AS [Iloœæ mê¿czyzn, którzy nie otrzymali mandatu],
COUNT(CASE WHEN P³eæ = 'Kobieta' THEN 1 END) AS [Iloœæ kobiet, które nie otrzyma³y mandatu],
SUM(Liczba_g³osów) AS [Liczba g³osów],
ROUND(CAST(CAST(SUM(Liczba_g³osów) AS FLOAT)/CAST(COUNT(Zawód) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g³osów na osobê danego zawodu]
FROM senat_kandydaci
WHERE Czy_przyznano_mandat = 'Nie'
GROUP BY Zawód
ORDER BY COUNT(Zawód) DESC

--Wykaz list do sejmu
SELECT * 
FROM wykaz_list_sejm;
ALTER TABLE wykaz_list_sejm
ALTER COLUMN Liczba_mandatów INT NOT NULL;
SELECT Nazwa_Komitetu AS [Nazwa Komitetu],
SUM(Liczba_kandydatów) AS [Liczba kandydatów],
SUM(Liczba_mandatów) AS [Liczba mandatów],
SUM(Liczba_g³osów) AS [Liczba g³osów]
FROM wykaz_list_sejm
GROUP BY Nazwa_Komitetu
ORDER BY [Liczba mandatów] DESC,
[Liczba kandydatów] DESC

--wyniki sejm
SELECT * 
FROM sejm_wyniki;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_BEZPARTYJNI_SAMORZ¥DOWCY = 0
WHERE KOMITET_WYBORCZY_BEZPARTYJNI_SAMORZ¥DOWCY IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_POLSKA_JEST_JEDNA = 0
WHERE KOMITET_WYBORCZY_POLSKA_JEST_JEDNA IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_WYBORCÓW_RUCHU_DOBROBYTU_I_POKOJU = 0
WHERE KOMITET_WYBORCZY_WYBORCÓW_RUCHU_DOBROBYTU_I_POKOJU IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_NORMALNY_KRAJ = 0
WHERE KOMITET_WYBORCZY_NORMALNY_KRAJ IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_ANTYPARTIA = 0
WHERE KOMITET_WYBORCZY_ANTYPARTIA IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_RUCH_NAPRAWY_POLSKI = 0
WHERE KOMITET_WYBORCZY_RUCH_NAPRAWY_POLSKI IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_WYBORCÓW_MNIEJSZOŒÆ_NIEMIECKA = 0
WHERE KOMITET_WYBORCZY_WYBORCÓW_MNIEJSZOŒÆ_NIEMIECKA IS NULL;
SELECT Województwo,
Powiat,
SUM(Liczba_wyborców_uprawnionych_do_g³osowania) AS [Liczba wyborców uprawnionych do g³osowania],
SUM(Liczba_wyborców_którym_wydano_karty_do_g³osowania_w_lokalu_wyborczym_oraz_w_g³osowaniu_korespondencyjnym_³¹cznie) AS [Liczba wyborców, którzy g³osowali],
SUM(Liczba_wyborców_g³osuj¹cych_przez_pe³nomocnika) AS [Liczba wyborców g³osuj¹cych przez pe³nomocnika],
SUM(Liczba_g³osów_niewa¿nych) AS [Liczba g³osów niewa¿nych],
SUM(KOMITET_WYBORCZY_PRAWO_I_SPRAWIEDLIWOŒÆ) AS [Prawo i Sprawiedliwoœæ],
SUM(KOALICYJNY_KOMITET_WYBORCZY_KOALICJA_OBYWATELSKA_PO_N_IPL_ZIELONI) AS [Koalicja Obywatelska],
SUM(KOALICYJNY_KOMITET_WYBORCZY_TRZECIA_DROGA_POLSKA_2050_SZYMONA_HO£OWNI_POLSKIE_STRONNICTWO_LUDOWE) AS [Trzecia Droga],
SUM(KOMITET_WYBORCZY_NOWA_LEWICA) AS [Nowa Lewica],
SUM(KOMITET_WYBORCZY_KONFEDERACJA_WOLNOŒÆ_I_NIEPODLEG£OŒÆ) AS [Konfederacja],
SUM(KOMITET_WYBORCZY_BEZPARTYJNI_SAMORZ¥DOWCY) + SUM(KOMITET_WYBORCZY_POLSKA_JEST_JEDNA) + SUM(KOMITET_WYBORCZY_WYBORCÓW_RUCHU_DOBROBYTU_I_POKOJU) + SUM(KOMITET_WYBORCZY_NORMALNY_KRAJ) + SUM(KOMITET_WYBORCZY_ANTYPARTIA) + SUM(KOMITET_WYBORCZY_RUCH_NAPRAWY_POLSKI) + SUM(KOMITET_WYBORCZY_WYBORCÓW_MNIEJSZOŒÆ_NIEMIECKA) AS [Inne Komitety Wyborcze]
FROM sejm_wyniki
WHERE Województwo IS NOT NULL
GROUP BY Województwo, Powiat
ORDER BY Województwo, Powiat;


-- najbardziej popierani politycy
SELECT *
FROM sejm_kandydaci;
SELECT Nazwisko_i_imiona,
Nazwa_Komitetu,
Procent_g³osów_oddanych_w_okrêgu,
Liczba_g³osów
FROM sejm_kandydaci
ORDER BY Procent_g³osów_oddanych_w_okrêgu DESC,
Liczba_g³osów DESC;
