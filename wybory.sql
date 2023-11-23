-- Referendum
SELECT * 
FROM referendum;
SELECT referendum.Wojew�dztwo, 
SUM(referendum.[Liczba_wyborc�w_kt�rym_wydano_karty_do_g�osowania_w_lokalu_wyborczym_oraz_w_g�osowaniu_korespondencyjnym_��cznie]) AS [Liczba os�b bior�cych udzia� w referendum],
ROUND(CAST(SUM(CAST(referendum.[Liczba_wyborc�w_kt�rym_wydano_karty_do_g�osowania_w_lokalu_wyborczym_oraz_w_g�osowaniu_korespondencyjnym_��cznie] AS FLOAT))/SUM(CAST(Liczba_os�b_uprawnionych_do_g�osowania AS FLOAT)) AS DECIMAL(3,2)),2) AS [Procent wyborc�w bior�cych udzia� w referendum],
SUM(Sprawa_1_Liczba_g�os�w_niewa�nych)+SUM(Sprawa_2_Liczba_g�os�w_niewa�nych)+SUM(Sprawa_3_Liczba_g�os�w_niewa�nych)+SUM(Sprawa_4_Liczba_g�os�w_niewa�nych) AS [Liczba g�os�w niewa�nych w 4 pytaniach],
ROUND(CAST(CAST((SUM(Sprawa_1_Liczba_g�os�w_niewa�nych)+SUM(Sprawa_2_Liczba_g�os�w_niewa�nych)+SUM(Sprawa_3_Liczba_g�os�w_niewa�nych)+SUM(Sprawa_4_Liczba_g�os�w_niewa�nych)) AS FLOAT)/CAST(SUM(referendum.[Liczba_wyborc�w_kt�rym_wydano_karty_do_g�osowania_w_lokalu_wyborczym_oraz_w_g�osowaniu_korespondencyjnym_��cznie]) AS FLOAT) AS DECIMAL(2,2)),2) AS [Ilo�� niewa�nych odpowiedzi na osob�],
ROUND(CAST(CAST(SUM(Sprawa_1_Liczba_g�os�w_nie) AS FLOAT)/CAST(SUM(Sprawa_1_Liczba_g�os�w_wa�nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 1 % nie],
ROUND(CAST(CAST(SUM(Sprawa_2_Liczba_g�os�w_nie) AS FLOAT)/CAST(SUM(Sprawa_2_Liczba_g�os�w_wa�nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 2 % nie],
ROUND(CAST(CAST(SUM(Sprawa_3_Liczba_g�os�w_nie) AS FLOAT)/CAST(SUM(Sprawa_3_Liczba_g�os�w_wa�nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 3 % nie],
ROUND(CAST(CAST(SUM(Sprawa_4_Liczba_g�os�w_nie) AS FLOAT)/CAST(SUM(Sprawa_4_Liczba_g�os�w_wa�nych) AS FLOAT) AS DECIMAL(2,2)),2) AS [Sprawa 4 % nie],
SUM(Liczba_os�b_g�osuj�cych_przez_pe�nomocnika) AS [Liczba os�b g�osuj�cych przez pe�nomocnika],
SUM(sejm_wyniki.Liczba_wyborc�w_kt�rym_wydano_karty_do_g�osowania_w_lokalu_wyborczym_oraz_w_g�osowaniu_korespondencyjnym_��cznie) - SUM(referendum.Liczba_wyborc�w_kt�rym_wydano_karty_do_g�osowania_w_lokalu_wyborczym_oraz_w_g�osowaniu_korespondencyjnym_��cznie) AS [Liczba os�b, kt�re pobra�y karty do g�osowania bez referendum]
FROM referendum
LEFT JOIN sejm_wyniki ON referendum.Nr_komisji = sejm_wyniki.Nr_komisji AND referendum.Siedziba = sejm_wyniki.Siedziba
WHERE referendum.Wojew�dztwo IS NOT NULL
GROUP BY referendum.Wojew�dztwo
ORDER BY [Procent wyborc�w bior�cych udzia� w referendum] DESC,
[Liczba os�b bior�cych udzia� w referendum] DESC;

--Kandydaci do sejmu, kt�rzy otrzymali mandat
SELECT *
FROM sejm_kandydaci;
SELECT Zaw�d,
COUNT(Zaw�d) AS [Liczba kandydat�w, kt�rzy otrzymali mandat],
COUNT(CASE WHEN P�e� = 'M�czyzna' THEN 1 END) AS [Ilo�� m�czyzn, kt�rzy otrzymali mandat],
COUNT(CASE WHEN P�e� = 'Kobieta' THEN 1 END) AS [Ilo�� kobiet, kt�re otrzyma�y mandat],
SUM(Liczba_g�os�w) AS [Liczba g�os�w],
ROUND(CAST(CAST(SUM(Liczba_g�os�w) AS FLOAT)/CAST(COUNT(Zaw�d) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g�os�w na jedn� osob� danego zawodu]
FROM sejm_kandydaci
WHERE Czy_przyznano_mandat = 'Tak'
GROUP BY Zaw�d
ORDER BY COUNT(Zaw�d) DESC

--Kandydaci do sejmu, kt�rzy nie otrzymali mandatu
SELECT *
FROM sejm_kandydaci;
SELECT Zaw�d,
COUNT(Zaw�d) AS [Liczba kandydat�w, kt�rzy nie otrzymali mandatu],
COUNT(CASE WHEN P�e� = 'M�czyzna' THEN 1 END) AS [Ilo�� m�czyzn, kt�rzy nie otrzymali mandatu],
COUNT(CASE WHEN P�e� = 'Kobieta' THEN 1 END) AS [Ilo�� kobiet, kt�re nie otrzyma�y mandatu],
SUM(Liczba_g�os�w) AS [Liczba g�os�w],
ROUND(CAST(CAST(SUM(Liczba_g�os�w) AS FLOAT)/CAST(COUNT(Zaw�d) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g�os�w na jedn� osob� danego zawodu]
FROM sejm_kandydaci
WHERE Czy_przyznano_mandat = 'Nie'
GROUP BY Zaw�d
ORDER BY COUNT(Zaw�d) DESC

--Kandydaci do senatu, kt�rzy otrzymali mandat
SELECT *
FROM senat_kandydaci;
UPDATE senat_kandydaci
SET Zaw�d = 'menad�er'
WHERE Zaw�d = 'mened�er';
UPDATE senat_kandydaci
SET Zaw�d = 'prawnik'
WHERE Zaw�d = 'prawniczka';
UPDATE senat_kandydaci
SET Zaw�d = 'socjolog'
WHERE Zaw�d = 'socjolo�ka';
SELECT Zaw�d,
COUNT(Zaw�d) AS [Liczba kandydat�w, kt�rzy otrzymali mandat],
COUNT(CASE WHEN P�e� = 'M�czyzna' THEN 1 END) AS [Ilo�� m�czyzn, kt�rzy otrzymali mandat],
COUNT(CASE WHEN P�e� = 'Kobieta' THEN 1 END) AS [Ilo�� kobiet, kt�re otrzyma�y mandat],
SUM(Liczba_g�os�w) AS [Liczba g�os�w],
ROUND(CAST(CAST(SUM(Liczba_g�os�w) AS FLOAT)/CAST(COUNT(Zaw�d) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g�os�w na osob� danego zawodu]
FROM senat_kandydaci
WHERE Czy_przyznano_mandat = 'Tak'
GROUP BY Zaw�d
ORDER BY COUNT(Zaw�d) DESC

--Kandydaci do senatu, kt�rzy nieotrzymali mandatu
SELECT *
FROM senat_kandydaci;
SELECT Zaw�d,
COUNT(Zaw�d) AS [Liczba kandydat�w, kt�rzy nie otrzymali mandatu],
COUNT(CASE WHEN P�e� = 'M�czyzna' THEN 1 END) AS [Ilo�� m�czyzn, kt�rzy nie otrzymali mandatu],
COUNT(CASE WHEN P�e� = 'Kobieta' THEN 1 END) AS [Ilo�� kobiet, kt�re nie otrzyma�y mandatu],
SUM(Liczba_g�os�w) AS [Liczba g�os�w],
ROUND(CAST(CAST(SUM(Liczba_g�os�w) AS FLOAT)/CAST(COUNT(Zaw�d) AS FLOAT) AS DECIMAL(30,2)),2) AS [Liczba g�os�w na osob� danego zawodu]
FROM senat_kandydaci
WHERE Czy_przyznano_mandat = 'Nie'
GROUP BY Zaw�d
ORDER BY COUNT(Zaw�d) DESC

--Wykaz list do sejmu
SELECT * 
FROM wykaz_list_sejm;
ALTER TABLE wykaz_list_sejm
ALTER COLUMN Liczba_mandat�w INT NOT NULL;
SELECT Nazwa_Komitetu AS [Nazwa Komitetu],
SUM(Liczba_kandydat�w) AS [Liczba kandydat�w],
SUM(Liczba_mandat�w) AS [Liczba mandat�w],
SUM(Liczba_g�os�w) AS [Liczba g�os�w]
FROM wykaz_list_sejm
GROUP BY Nazwa_Komitetu
ORDER BY [Liczba mandat�w] DESC,
[Liczba kandydat�w] DESC

--wyniki sejm
SELECT * 
FROM sejm_wyniki;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_BEZPARTYJNI_SAMORZ�DOWCY = 0
WHERE KOMITET_WYBORCZY_BEZPARTYJNI_SAMORZ�DOWCY IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_POLSKA_JEST_JEDNA = 0
WHERE KOMITET_WYBORCZY_POLSKA_JEST_JEDNA IS NULL;
UPDATE sejm_wyniki
SET KOMITET_WYBORCZY_WYBORC�W_RUCHU_DOBROBYTU_I_POKOJU = 0
WHERE KOMITET_WYBORCZY_WYBORC�W_RUCHU_DOBROBYTU_I_POKOJU IS NULL;
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
SET KOMITET_WYBORCZY_WYBORC�W_MNIEJSZO��_NIEMIECKA = 0
WHERE KOMITET_WYBORCZY_WYBORC�W_MNIEJSZO��_NIEMIECKA IS NULL;
SELECT Wojew�dztwo,
Powiat,
SUM(Liczba_wyborc�w_uprawnionych_do_g�osowania) AS [Liczba wyborc�w uprawnionych do g�osowania],
SUM(Liczba_wyborc�w_kt�rym_wydano_karty_do_g�osowania_w_lokalu_wyborczym_oraz_w_g�osowaniu_korespondencyjnym_��cznie) AS [Liczba wyborc�w, kt�rzy g�osowali],
SUM(Liczba_wyborc�w_g�osuj�cych_przez_pe�nomocnika) AS [Liczba wyborc�w g�osuj�cych przez pe�nomocnika],
SUM(Liczba_g�os�w_niewa�nych) AS [Liczba g�os�w niewa�nych],
SUM(KOMITET_WYBORCZY_PRAWO_I_SPRAWIEDLIWO��) AS [Prawo i Sprawiedliwo��],
SUM(KOALICYJNY_KOMITET_WYBORCZY_KOALICJA_OBYWATELSKA_PO_N_IPL_ZIELONI) AS [Koalicja Obywatelska],
SUM(KOALICYJNY_KOMITET_WYBORCZY_TRZECIA_DROGA_POLSKA_2050_SZYMONA_HO�OWNI_POLSKIE_STRONNICTWO_LUDOWE) AS [Trzecia Droga],
SUM(KOMITET_WYBORCZY_NOWA_LEWICA) AS [Nowa Lewica],
SUM(KOMITET_WYBORCZY_KONFEDERACJA_WOLNO��_I_NIEPODLEG�O��) AS [Konfederacja],
SUM(KOMITET_WYBORCZY_BEZPARTYJNI_SAMORZ�DOWCY) + SUM(KOMITET_WYBORCZY_POLSKA_JEST_JEDNA) + SUM(KOMITET_WYBORCZY_WYBORC�W_RUCHU_DOBROBYTU_I_POKOJU) + SUM(KOMITET_WYBORCZY_NORMALNY_KRAJ) + SUM(KOMITET_WYBORCZY_ANTYPARTIA) + SUM(KOMITET_WYBORCZY_RUCH_NAPRAWY_POLSKI) + SUM(KOMITET_WYBORCZY_WYBORC�W_MNIEJSZO��_NIEMIECKA) AS [Inne Komitety Wyborcze]
FROM sejm_wyniki
WHERE Wojew�dztwo IS NOT NULL
GROUP BY Wojew�dztwo, Powiat
ORDER BY Wojew�dztwo, Powiat;


-- najbardziej popierani politycy
SELECT *
FROM sejm_kandydaci;
SELECT Nazwisko_i_imiona,
Nazwa_Komitetu,
Procent_g�os�w_oddanych_w_okr�gu,
Liczba_g�os�w
FROM sejm_kandydaci
ORDER BY Procent_g�os�w_oddanych_w_okr�gu DESC,
Liczba_g�os�w DESC;
