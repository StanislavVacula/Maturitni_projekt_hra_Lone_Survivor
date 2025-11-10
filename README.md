# 🎮 Lone Survivor – 2D akční hra
**Autor:** Stanislav Vacula

Tento projekt je **maturitní prací** zaměřenou na **vývoj 2D akční hry** v herním enginu **Godot 4.4**. Cílem práce je vytvořit hratelný prototyp, který propojuje herní design, programování a animaci do uceleného systému a představuje komplexní ukázku vývoje 2D herního projektu.

---

## 🎯 Cíle projektu
Hlavním cílem této práce je **navrhnout a implementovat 2D akční survival hru**, která kombinuje **akci, strategii a prvky přežití**.  
Hráč se ujímá role vojáka, jenž po pádu vrtulníku musí přežít v nepřátelském území plném pastí a ozbrojených protivníků.

---

## 🕹️ Herní koncept
- **Název hry:** *Lone Survivor*  
- **Prostředí:** vojenský pixel-art svět  
- **Cíl hry:** přežít, dostat se zpět k vlastní jednotce  
- **Progres:** hra je rozdělena do několika levelů s rostoucí obtížností  
- **Levely zahrnují:** džungli, vesnici i nepřátelský tábor s finálním boss fightem  

---

## ⚙️ Herní mechaniky
- **Pohyb:** chůze, běh, skoky, krytí  
- **Útoky:** střelné zbraně (pistole), boj zblízka  
- **Interakce:** sbírání předmětů, posouvání krabic, otevírání dveří  
- **Zdraví a checkpointy:** systém životů a ukládacích bodů  

---

## 🧍‍♂️ Postavy a objekty
- **Player (voják):** hlavní postava s atributy zdraví, rychlosti a zbraně  
- **Enemy (nepřátelé):** různé typy vojáků s odlišnými schopnostmi  
- **Object (objekty):** krabice, zbraně, lékárničky – interaktivní prvky prostředí  

---

## 🎨 Grafika a styl
- Pixel-art vizuál inspirovaný vojenským prostředím  
- Postavy a animace vytvořeny pomocí uzlu `AnimatedSprite2D`  
- Důraz na přehlednost a atmosféru prostředí  

---

## 💻 Použité technologie
| Oblast | Technologie | Účel |
|--------|------------|------|
| Herní engine | **Godot Engine 4.4** | Vývoj 2D hry a správa scén |
| Jazyk | **GDScript** | Implementace herní logiky a interakcí |
| Grafika | **Pixel-art** | Stylizace postav a prostředí |
| Animace | **AnimatedSprite2D** | Realizace pohybu a akcí postav |
| Fyzika | **Godot Physics2D** | Kolize, pohyb a interakce objektů |

---

## 🧩 Struktura hry
| Level | Název | Hlavní prvky |
|-------|-------|---------------|
| 1 | Džungle | Základní pohyb, první nepřátelé |
| 2 | Džungle II | Střelba, sběr zbraní, krytí |
| 3 | Zničená vesnice | Tichý pohyb, omezená munice |
| 4 | Vesnice II | Puzzle a náročnější souboje |
| 5 | Tábor | Boss fight, kombinace všech mechanik |

---

## 🧠 Přínos projektu
Projekt **Lone Survivor** demonstruje znalost tvorby herní logiky, animací, fyziky a strukturovaného programování.  
Cílem je vytvořit funkční 2D hru, která dokládá pochopení principů herního designu, vývoje v enginu Godot a práce s vizuálními i interaktivními prvky.

---

## 🛠️ Instalace a spuštění
1. **Klonování repozitáře**  
```bash
git clone [URL_VAŠEHO_REPOZITÁŘE]
cd Lone_Survivor

**Otevření projektu v Godotu**  

Spusťte Godot 4.4 a otevřete složku projektu.

**Spuštění hry**  

Otevřete hlavní scénu (Main.tscn) a klikněte na Play Scene.

Hra se spustí a můžete testovat herní mechaniky a levely.
