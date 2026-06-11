# E-Mail-getriebene Tagesarbeit — Zeitfresser zur Überprüfung

**Datum:** 2026-05-28
**Von:** Stefan
**Zweck:** Erkundung, welche Teile unserer e-mail-lastigen Tagesarbeit sich mit Werkzeugen beschleunigen oder teilautomatisieren ließen.

Nachfolgend eine erste Entwurfsliste von Zeitfressern je Rolle.

> **Globale Pain-IDs:** Jeder Zeitfresser trägt eine stabile globale ID (`A01`, `A02`, …), die sich bei Umsortierung **nicht** ändert. Die führende Zahl (1., 2., …) zeigt nur die aktuelle Prioritäts-Sortierung innerhalb der Rolle. Alle generierten Dokumente referenzieren die globalen IDs.

**TODO: Schärfen:**

- ✅ **Bestätigen**, welche Punkte im Arbeitsalltag tatsächlich wehtun.
- ✏️ **Umformulieren**, was falsch oder zu vage beschrieben ist.
- ❌ **Streichen**, was kein echtes Problem ist (oder bereits gelöst wurde).
- ➕ **Ergänzen**, was fehlt — besonders die Zeitfresser, mit denen man sich stillschweigend abgefunden hat.
- 🔥 **Den einen wichtigsten Punkt je Rolle markieren** (und einen im Querschnitt) — der Punkt, der den größten Unterschied machen würde, wenn er gelöst wäre.

---

## Umfang dieser Übersicht

- **Im Scope:** alles, was heute per E-Mail läuft — persönliche Postfächer, gemeinsame Postfächer (z. B. `sales@`) sowie das historische Archiv (einschließlich alter PST-Dateien). Das CRM ist Pipedrive.
- **Nicht im Scope:** Technischer Support — läuft über ein separates Ticketsystem, nicht über Mail.
- **Ziel:** Zeitfresser identifizieren, bei denen ein kleines, fokussiertes Werkzeug realistisch echte Zeit sparen könnte. Keine Reorganisation, keine große Plattform.

---

## Rolle 1 — Vertriebsinnendienst (Inside Sales)

### Relevante Zeitfresser

1. `[A01]` **Umsortieren der Sales-Mails** — die `sales@…`-Flut: Das Sales-Team muss heute alle eingehenden Vertriebsmails manuell in die jeweiligen, kundenspezifischen Ordner im gemeinsamen Sales-Postfach archivieren. Wunsch: automatische Zuordnung in dieselbe Ordnerstruktur.
2. `[A02]` **Standardantworten / Follow-ups verfassen** (überschneidet sich ggf. mit A03, A04 und A05).
3. `[A03]` **Frühere Antwort zu einer wiederkehrenden Frage finden** (Preisstaffeln, Lizenzmodelle, Eval-Verlängerungen, Registrierungen, Erstversorgung/Nachfassen usw.) — die passende Antwort steckt in alten Threads, ist aber zeitaufwändig zu finden.
4. `[A04]` **Frühere Antwort auf den aktuellen Kunden anpassen und aktuell halten** — gefundene Vorlage umformulieren; und sicherstellen, dass die Antwort noch korrekt ist (Preise/Bedingungen können sich geändert haben).
5. `[A05]` **Nachverfolgung offener Angebote und Deals** — manuelles Mitverfolgen, welche Angebote/Deals eine Aktion erfordern und wann.

### Sekundäre Zeitfresser

6. `[A06]` **Vorgeschichte eines Kunden nachschlagen** — „Wer von uns hat mit diesem Kunden schon worüber gesprochen?" — entweder im gemeinsamen Sales-Postfach oder tief vergraben in archivierten PSTs oder in Pipedrive.
7. `[A07]` **Weiterleiten mit Kontext** — drei Absätze lange Thread-Zusammenfassungen schreiben, wenn etwas an die Entwicklung übergeben wird.
8. `[A08]` **Themensuche über alte Mails** — „Alles, was wir je über X gesagt haben."
9. `[A09]` **Terminfindung per Mail** — Meeting-Koordination mit Kunden, Vorschläge hin und her, ggf. zeitzonenübergreifend.
10. `[A10]` **Mailhygiene & Wiedervorlage** — den Überblick behalten, auf welche Mails man noch auf Antwort wartet und wann nachgefasst werden müsste. Breiter als A03 (jeder offene Thread, nicht nur Deals/Angebote).

### 🔥 Wichtigster Punkt

**A01, A02:** Umsortieren ist lästig, fehleranfällig und kostet unnötige Zeit. Antworten erstellen kostet die meiste Zeit.

---

## Rolle 2 — Technischer Vertrieb / Pre-Sales Engineer

### Relevante Zeitfresser

1. `[A11]` **Kurze technische Faktenantwort wiederfinden** — z. B. „Unterstützt der EtherCAT-Master X auf RTOS Y mit Kernel Z?" Die Antwort steckt in alten Threads/Dokumenten und ist zeitaufwändig zu finden.
2. `[A12]` **Längere technische Ausarbeitung wiederverwenden** — eine ausführliche Erklärung (Architekturskizze, Konzepttext), die vor zwei Jahren für Kunde A geschrieben wurde; Kunde B fragt dasselbe; die Vorlage zu finden und anzupassen ist langsam.

### Sekundäre Zeitfresser

3. `[A13]` **Kunden-Setup-Historie übergreifend nachverfolgen** — Versionen, frühere Konfigurationen, verstreut über Mail, Tickets und Erinnerungen.
4. `[A14]` **Übergabe Sales → Technik** — unvollständiger Kontext, der gesamte Thread muss neu gelesen werden.
5. `[A15]` **Sichtbarkeit wiederkehrender Fragen** — „5. Kunde in diesem Quartal fragt X → vielleicht braucht das ein FAQ / Docs-Update."
6. `[A16]` **Mailhygiene & Wiedervorlage** — den Überblick behalten, auf welche Mails man noch auf Antwort wartet und wann nachgefasst werden müsste.

### 🔥 Wichtigster Punkt

**A11:** Kommt am häufigsten vor.

---

## Rolle 3 — Management / Allgemein

### Relevante Zeitfresser

1. `[A17]` **Briefing** — z. B.: „Ich habe in 30 Min. einen Call mit Kunde X — gib mir die letzten 5 Bullet-Points zur Historie." — heute: den Vertriebsmitarbeiter fragen, der dann sucht.
2. `[A18]` **Erkennen kritische Deals** — Stille bei einem wichtigen Account, sich verändernder Ton, Beschwerden, die im Vertriebspostfach oder im Ticketsystem aufschlagen. Aktueller Stand: falls im Ticketsystem, wird im Sales womöglich gar nicht bemerkt.
3. `[A19]` **Reaktionszeit / Sichtbarkeit auf gemeinsamen Postfächern** — „Wird `sales@` zügig, innerhalb eines Tages beantwortet?" — kein Dashboard, nur Bauchgefühl.
4. `[A20]` **Compliance / Auditpfad** — „Was haben wir diesem Kunden wann versprochen?" — besonders über PSTs ehemaliger Mitarbeiter oder Kollegen.

### Sekundäre Zeitfresser

5. `[A21]` **Pipeline-Realitätscheck aus der Mail** — Pipedrive zeigt die Deal-*Phase*, aber der echte Status steckt im letzten Mail-Thread. Heute: entweder den Vertriebsmitarbeiter fragen oder Threads selbst lesen.
6. `[A22]` **Kundenfrage-Themen und -Trends** — Womit beschäftigen sich Kunden gerade? Als Input für Roadmap, Marketing und Dokumentation.
7. `[A23]` **Prognose-Plausibilitätsprüfung** — Sales sagt, ein Deal schließt in Q3, aber der tatsächliche Mail-Austausch mit diesem Kunden ist seit sechs Wochen eingeschlafen — fällt erst auf, wenn die Prognose verfehlt wird.

### 🔥 Wichtigster Punkt

**A17, A18, A19:** das ist nur eine Annahme.

---

## Rolle 4 — Auftragsabwicklung (Order Processing)

### Relevante Zeitfresser

1. `[A24]` **Auftragserfassung aus der Mail** — Kunde schickt eine Bestellung (PDF oder im Text), Mensch tippt sie manuell ins ERP. Langweilig und fehleranfällig.
2. `[A25]` **Lizenzschlüssel generieren und ausliefern** — Anfrage kommt per Mail, Schlüssel wird generiert, Mail zurück mit Schlüssel und Bedingungen. Repetitiv.
3. `[A26]` **Bestellung ↔ Angebot abgleichen** — Stimmt die eingehende Bestellung tatsächlich mit dem gesendeten Angebot überein (Preis, Menge, Lizenzbedingungen, Lieferdatum)?
4. `[A27]` **Dokumente zwischen ERP und Mail routen** — beide Richtungen: (a) im ERP erzeugte Rechnungen/Versandbestätigungen müssen im richtigen Mail-Thread/Kundenordner landen und ggf. versendet werden; (b) ausgehende oder eingehende Mails mit ERP-relevanten Dokumenten zurück ins ERP / in die Kundenakte. Manuelles Zusammenführen.
5. `[A28]` **Erinnerungen für Verlängerungen / Wartung** — „Die Wartung dieses Kunden läuft in 60 Tagen ab."

### Sekundäre Zeitfresser

6. `[A29]` **Bestellstatus-Anfragen** — „Wo ist meine Bestellung / wann wird geliefert / wo ist meine Rechnung?" — Antwort steckt im ERP, wird aber manuell eingetippt.
7. `[A30]` **Fehlende Angaben einfordern** — Eingehende Bestellung ohne USt-IdNr., Endnutzerinfo (Exportkontrolle), korrekte Rechnungsadresse — hin und her per Mail.
8. `[A31]` **Exportkontrolle / Compliance-Kennzeichnung bei Bestellungen** — Endnutzerprüfung, Dual-Use, Screening für sanktionierte Länder — heute teilweise mail-getrieben.

### 🔥 Wichtigster Punkt

_(bitte eintragen: Pain-ID + kurze Begründung)_

---

## Querschnitt — Anhänge & Dokumente

Anhänge sind in allen Rollen ein Thema, mit unterschiedlichem Schwerpunkt je Rolle. Zu klären/priorisieren je Rolle:

- `[A32]` **Eingehende Anhänge wiederfinden** — „Wo war nochmal die signierte NDA von Kunde X / die Logdatei von Kunde Y / das unterschriebene Angebot?"
- `[A33]` **Versionschaos** — mehrere Varianten desselben Dokuments im Thread; unklar, welches die finale Fassung ist.
- `[A34]` **Ausgehende Anhänge zusammenstellen** — Angebot + Datenblatt + Lizenzbedingungen + Compliance-Dokumente als Paket.
- `[A35]` **Ablage / Routing** — Anhänge aus der Mail in die strukturierte Ablage (Fileserver, Pipedrive, ERP) bringen, ohne dass etwas verloren geht.
- `[A36]` **Kritische Dokumenttypen (Zeitfresser oder fehleranfällig)** — z. B. Bestell-PDFs, signierte Verträge/NDAs, technische Specs, Logs/Crash-Dumps, Angebote.

### 🔥 Wichtigster Punkt

_(bitte eintragen: Pain-ID + kurze Begründung)_

---

## Fehlt etwas?

Bitte Rollen oder Zeitfresser ergänzen, die hier nicht abgedeckt sind. Besonders interessant:

- **Themen, über die man aufgehört hat zu klagen oder über die man nicht reflektiert**, weil „das eben so ist."
- **Workarounds**, die man sich persönlich gebaut hat (Outlook-Regeln, private Tabellen, Skripte) — die sind starke Signale, dass darunter ein echter Schmerz steckt.
- **Reibung zwischen Rollen** — Übergaben zwischen Vertriebsinnendienst ↔ Technischem Vertrieb ↔ Auftragsabwicklung, bei denen Mail-Kontext verloren geht.
