# Privates E-Mail-Postfach — Zeitfresser

**Datum:** 2026-05-30
**Von:** Stefan
**Zweck:** Erkundung, welche Teile der privaten E-Mail-Verwaltung sich mit Werkzeugen beschleunigen oder teilautomatisieren ließen.

Nachfolgend eine erste Entwurfsliste von Zeitfressern im privaten Postfach.

> **Globale Pain-IDs:** Jeder Zeitfresser trägt eine stabile globale ID (`P01`, `P02`, …), die sich bei Umsortierung **nicht** ändert. Die führende Zahl zeigt nur die aktuelle Sortierung innerhalb des Themenbereichs. Alle generierten Dokumente referenzieren die globalen IDs.

**TODO: Schärfen:**

- ✅ **Bestätigen**, welche Punkte im Alltag tatsächlich wehtun.
- ✏️ **Umformulieren**, was falsch oder zu vage beschrieben ist.
- ❌ **Streichen**, was kein echtes Problem ist (oder bereits gelöst wurde).
- ➕ **Ergänzen**, was fehlt — besonders die Zeitfresser, mit denen man sich stillschweigend abgefunden hat.
- 🔥 **Den wichtigsten Punkt markieren** — der Punkt, der den größten Unterschied machen würde, wenn er gelöst wäre.

---

## Themenbereich 1 — Anhänge und Dokumente

Eingehende Mails bringen Anhänge mit (Rechnungen, Verträge, Tickets, Fotos, Dokumente), die irgendwo strukturiert abgelegt werden sollten — ohne dass man daran denkt oder es manuell tut.

### Relevante Zeitfresser

1. `[P01]` **Anhänge in den richtigen Google-Drive-Ordner ablegen** — Rechnung kommt per Mail, Anhang muss manuell heruntergeladen und in den passenden Ordner (z. B. `Finanzen/Rechnungen/2026`) hochgeladen werden. Wiederkehrend, stupide, wird oft aufgeschoben.
2. `[P02]` **Den passenden Zielordner für einen Anhang finden** — verschiedene Absender, verschiedene Dokumenttypen: Wo gehört diese PDF hin? Die Entscheidung kostet Aufmerksamkeit.
3. `[P03]` **Anhänge wiederfinden** — „Wo ist die Garantieurkunde für das Gerät, das ich letztes Jahr gekauft habe?" — steckt in einem alten Mail-Thread statt in der strukturierten Ablage.

### 🔥 Wichtigster Punkt

**P01** (inkl. **P02**): Kommt häufig vor und ist lästig

---

## Themenbereich 2 — Archivieren empfangener Mails

Gelesene Mails bleiben im Posteingang, weil Archivieren manuelle Aufmerksamkeit kostet. Das Postfach füllt sich, nichts ist mehr zu finden.

### Relevante Zeitfresser

1. `[P04]` **Manuelles Archivieren nach dem Lesen** — jede Mail einzeln anfassen, entscheiden ob archivieren oder nicht, und in den richtigen Ordner schieben oder nur „Archivieren" drücken.
2. `[P05]` **Archivierungs-Rückstand aufarbeiten** — wenn man sich Wochen nicht darum gekümmert hat, wächst der Rückstand, und der Aufwand zum Aufräumen wirkt überwältigend.
3. `[P06]` **Fehlende Ordnerstruktur** — Mails landen im Archiv, sind aber nicht thematisch sortiert, also später trotzdem schwer zu finden.

### 🔥 Wichtigster Punkt

**P04:** ist lästig und wird gerne vergessen

---

## Themenbereich 3 — Triage gelöschter Mails

Im Papierkorb stecken oft Mails, die endgültig gelöscht werden sollen — aber auch solche, die eigentlich ins Archiv oder in einen thematischen Ordner gehören. Blind löschen ist keine Option.

### Relevante Zeitfresser

1. `[P07]` **Endgültig zu löschende Mails identifizieren** — Newsletter, Spam, automatische Benachrichtigungen, Quittungen für bereits abgelegte Dokumente: Diese können direkt weg, brauchen aber trotzdem einen kurzen Blick zur Bestätigung.
2. `[P08]` **Mails, die doch aufbewahrt werden sollen, retten** — manche Mails wandern versehentlich in den Papierkorb oder man merkt beim Aufräumen, dass ein Thread doch relevant ist (z. B. nach Thema oder Absender).
3. `[P09]` **Themen- oder absenderbasierte Triage** — Nicht alles ist schwarz-weiß. Manche Absender produzieren immer Mails desselben Typs (z. B. Bank, Versicherung, Online-Shop): Eine Regel pro Absender/Thema würde viel Entscheidungsaufwand ersparen.
4. `[P10]` **Kein Überblick über den Papierkorb-Inhalt** — der Papierkorb wird selten geöffnet, bis er überläuft. Ohne Struktur ist eine sinnvolle Triage kaum möglich.

### 🔥 Wichtigster Punkt

**P08:** Aktuell sind wichtige Mails in der Menge der gelöschten Mails schwer aufzufinden

---

## Themenbereich 4 — Themensuche über alte Mails

Informationen zu einem Thema verteilen sich über viele alte Mails und Threads. Die Antwort auf eine konkrete Frage steckt verstreut im Postfach und müsste mühsam zusammengesucht werden.

### Relevante Zeitfresser

1. `[P11]` **Alles zu einem Thema zusammentragen** — „Alles über meine Versicherungen bezüglich X (z. B. KFZ, Haftpflicht)." — relevante Mails liegen über Monate oder Jahre verstreut, von verschiedenen Absendern, mit unterschiedlichen Betreffzeilen.
2. `[P12]` **Volltextsuche reicht nicht** — die eingebaute Suche findet nur exakte Begriffe, versteht aber nicht das Thema: Synonyme, Absender, Vertragsnummern und Anhänge müssten gemeinsam betrachtet werden.
3. `[P13]` **Antwort aus mehreren Mails zusammenfassen** — selbst wenn man die richtigen Mails gefunden hat, muss man sie lesen und die eigentliche Information (Tarif, Frist, Vertragsstand) selbst herausziehen.

### 🔥 Wichtigster Punkt

**P11:** Der eigentliche Bedarf — eine konkrete Frage zu einem Thema schnell beantwortet bekommen, ohne selbst das ganze Archiv durchsuchen zu müssen.

---

## Querschnitt — Mustererkennung und Automatisierung

Über alle vier Bereiche hinweg steckt das eigentliche Problem darin, dass immer wieder dieselben Entscheidungen getroffen werden — für dieselben Absender, dieselben Dokumenttypen, dieselben Aktionen. Einmal gelernte Muster müssten nicht wiederholt werden.

- `[P14]` **Absender-basierte Regeln** — „Mails von meiner Bank enthalten immer Kontoauszüge → Anhang nach `Finanzen/Kontoauszüge/` + Mail archivieren."
- `[P15]` **Dokumenttyp-Erkennung** — Rechnung vs. Vertrag vs. Ticket vs. Newsletter: automatisch unterscheiden und entsprechend handeln.
- `[P16]` **Kontextabhängige Entscheidungen** — manche Mails erfordern wirklich menschliche Entscheidung; andere könnten vollautomatisch erledigt werden. Diese Grenze sauber zu ziehen ist der Kern des Problems.

### 🔥 Wichtigster Punkt

_(bitte eintragen: Pain-ID + kurze Begründung)_
