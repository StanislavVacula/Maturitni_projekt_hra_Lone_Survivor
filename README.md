# Maturitni_projekt_hra_Lone_Survivor
Toto je oficiální repozitář maturitního projektu na OAUH - Stanislav Vacula, za cíl na maturitní projekt jsem si vybral vytvořit 2d akční hru.

🎮 Návrh maturitního projektu – 2D akční hra
1. Název projektu

Lone Survivor

2. Scénář a herní koncept

Hra Lone Survivor se odehrává v pixel-artovém světě inspirovaném vojenským prostředím.
Hráč se ujímá role vojáka, který jako jediný přežil pád vojenského vrtulníku za nepřátelskými liniemi.
Ocítá se v neznámém území plném ozbrojených nepřátel, pastí a překážek. Jeho cílem je přežít, najít cestu ven a dostat se zpět k vlastní jednotce.

Každý level představuje jinou část nepřátelského území – od džungle až po vesnici.
Hráč musí využívat prostředí, šetřit municí a postupně nacházet zbraně a vybavení.
Cílem hry je kombinace akce, strategie a napětí z přežití.

3. Herní mechaniky

Pohyb: chůze, běh, skoky a krytí.

Útoky: střelné zbraně (pistole) a boj zblízka.

Interakce: sbírání předmětů, posouvání krabic, otevírání dveří.

Systém zdraví: hráč má počet životů zobrazený pomocí ukazatele.

Checkpointy: po smrti se hráč vrací na poslední uložený bod.

4. Počet a struktura levelů
Level	Název	Hlavní prvky
1	Džungle	Základní pohyb, první nepřátelé.
2	Džungle	První střelba, zbraně a krytí.
3	Zničená vesnice	Omezená munice, tichý pohyb.
4	Zničená vesnice	Puzzle a těžké souboje.
5	Tábor	Boss fight, kombinace všech mechanik.
5. Zvyšování obtížnosti

Obtížnost hry se bude zvyšovat s každým levelem.
Nepřátelé budou rychlejší, přesnější a vybaveni lepšími zbraněmi.
Hráč bude muset lépe plánovat své kroky a šetřit střelivem.

6. Postavy a objekty
🪖 Hlavní postava – Player (voják)

Hráč ovládá vojáka, který přežil havárii vrtulníku.
Má omezené zdroje a musí se probojovat ven z nepřátelského území.

Atributy: zdraví, rychlost, zbraň, pozice.

🔫 Nepřátelé – Enemy

Nepřátelští vojáci různých typů, liší se rychlostí, přesností a počtem životů.

🧰 Objekty – Object

Krabice, zbraně, lékárničky.
Hráč s nimi může interagovat a využívat je strategicky.

7. Grafika a vizuální styl

Hra je vytvořena v pixel-art stylu s důrazem na vojenské prostředí.
Postavy a animace jsou realizovány pomocí uzlu AnimatedSprite2D v Godotu.

8. Použitý framework

Pro vývoj hry je zvolen Godot Engine (verze 4.4).
Je vhodný pro 2D hry, má přehlednou strukturu scén, efektivní systém skriptování (GDScript)
a je zcela open-source.
Díky tomu umožňuje snadnou implementaci logiky, animací a fyziky.

9. Diagram tříd

Hlavní třídy a jejich atributy:

Player: zdraví, rychlost, zbraň, pozice

Enemy: zdraví, rychlost, typ útoku

Object: typ, interaktivita, pozice

Weapon: typ, poškození, rychlost útoku

10. Shrnutí a přínos projektu

Cílem projektu je vytvořit 2D akční hru v Godotu, která kombinuje herní logiku, animace a fyzikální systém.
Projekt demonstruje znalost programování, tvorby scén a herních mechanik a přináší ucelený koncept survival akční hry.
