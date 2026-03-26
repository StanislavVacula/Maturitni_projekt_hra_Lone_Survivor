# 🎮 Lone Survivor – 2D akční plošinovka

**Autor:** Stanislav Vacula  
**Škola:** OA, VOŠ a JŠ Uherské Hradiště  
**Technologie:** Godot Engine 4.4 (GDScript)

---

## 📖 Popis projektu
Tento projekt je **maturitní prací** zaměřenou na vývoj 2D akční hry. Cílem bylo vytvořit plně funkční herní prototyp, který kombinuje mechaniky pohybu, soubojový systém a interaktivní prostředí. Hra demonstruje využití moderních prvků v herním enginu **Godot 4.4**, jako jsou signály, fyzikální uzly a automatizace animací.

## 📝 Příběh a koncept
Hráč se ujímá role vojáka, který jako jediný přežil pád vrtulníku v hlubokém nepřátelském území. Cesta zpět k vlastní jednotce vede skrze nebezpečnou džungli plnou hlídek a pastí. Hra klade důraz na atmosféru, kterou dokresluje systém vyprávění skrze deníkové záznamy.

---

## 🚀 Klíčové technické vlastnosti
- **Pohybový systém:** Využití třídy `CharacterBody2D` s plynulou fyzikou (`move_and_slide`), detekcí skoků a kolizí.
- **Inteligentní AI:** Nepřátelé využívají uzel `RayCast2D` pro simulaci zorného pole. Útok je zahájen pouze v případě přímé viditelnosti hráče.
- **Interakce a logika:** Systém pák a padacích mostů postavený na **signálech (Signals)** pro oddělení kódu od scény.
- **Atmosférické prvky:** - Integrovaný systém deníku s efektem psacího stroje.
  - Vícevrstvé pozadí (**Parallax Background**) pro efekt hloubky.
- **Uživatelské rozhraní:** Kompletní herní smyčka – hlavní menu, pauza, HUD (zdraví) a obrazovky konce hry.

---

## ⌨️ Ovládání
| Akce | Klávesa |
|:--- |:--- |
| **Pohyb vlevo / vpravo** |  šipky |
| **Skok** | `Mezerník` |
| **Útok** | `K` |
| **Interakce (páka)** | `E` |
| **Pauza** | `Esc` |

---

## 💻 Technické specifikace
| Oblast | Technologie |
|:--- |:--- |
| **Engine** | Godot Engine 4.4 |
| **Jazyk** | GDScript (Object-Oriented) |
| **Grafika** | Pixel-art (Pixelorama, Photoshop) |
| **Level Design** | TileMapLayer se statickými kolizemi |
| **Zvuk** | AudioStreamPlayer2D |

---

## 🏗️ Struktura prototypu
Aktuální verze obsahuje komplexní tutoriálovou úroveň:
1. **Příběhový úvod:** Aktivace deníku a seznámení se situací.
2. **Překonávání terénu:** Skákání přes vodní plochy a plošiny.
3. **Bojový systém:** První střet s nepřítelem a práce s krytím.
4. **Logická část:** Aktivace mechanizmu páky pro uvolnění cesty dál.
5. **Cíl mise:** Průchod do bezpečné zóny (vlajka).

---

## 🛠️ Instalace a spuštění

### Pro hráče (Build)
1. Přejděte do sekce [Releases](../../releases).
2. Stáhněte si archiv `LoneSurvivor_v1.zip`.
3. Rozbalte a spusťte `LoneSurvivor.exe`.
