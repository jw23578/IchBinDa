# Ich bin da!
Aktionen/Aufgaben/Informationen per QR-Code übertragen und ausführen

## In aller Kürze:
Mittels der App können QR-Codes sowohl erstellt als auch gelesen und ausgeführt werden.
Bei einem Scan triggern die enthaltenen Informationen (halb-)automatische Aktionen, wie den Versand einer vorformatierten E-Mail an einen - im QR-Code enthaltenen - Empfänger.\
Die App eignet sich für Android und iOS.\
Die QR-Codes werden als PDF und Bilddatei zur Verfügung gestellt und können individuell in Aufsteller oder Speisekarten integriert werden.

Entwickelt werden soll die App in ihrer Basisfunktionalität im OL Civic Data Lab Hackathon [1]. Das Protokoll, also welche Daten/Aktionen im QR-Code ausgetauscht werden können, ist noch nicht festgelegt. Gerade um einen schönen Strauß an Anwendungsmöglichkeiten zu bekommen, bietet sich ein Hackathon mit vielen Teilnehmern aus verschiedensten Fachrichtungen und mit unterschiedlichen Interessen an.

## Szenario 1 (Kontaktdatenerfassung bzgl. Corona):
Aktuell müssen - zum Beispiel in Restaurants und in Frisörläden - zur Corona-Kontaktnachverfolgung bei jedem Besuch die Kontaktdaten des Kunden aufgenommen und für wenige Wochen aufbewahrt werden.
Bis auf kleine Unterschiede im Umfang der erhobenen Daten findet immer der gleiche Vorgang statt.
Mit der App kann dieser Vorgang sowohl für den Kunden als auch für das Geschäft wesentlich komfortabler gestaltet werden:
Das Geschäft erstellt mit der App einen QR-Code, der Folgendes enthält:
- Eine Aktions-ID (Daten abfragen und senden)
- Umfang der gewünschten Kontaktdaten
- E-Mail-Adresse, an die die Kontaktdaten geschickt werden sollen.

Der QR-Code wird als PDF erstellt, ausgedruckt und für den Kunden scannbar am Eingangstresen oder auf den Tischen angebracht.

Der Kunde kann den QR-Code mit dieser App scannen. Daraufhin wird die Aktions-ID interpretiert und die gewünschten Daten in einem Formular abgefragt. Nur beim ersten Mal müssen die Daten eingegeben werden. Beim zweiten Besuch oder auch in einem anderen Geschäft, das die App verwendet, werden die Daten dann automatisch vorausgefüllt.
Mit einem Klick auf Absenden wird eine entsprechend formatierte und gefüllte Mail an die übergebene E-Mail-Adresse gesendet.

Papier ist damit nicht mehr nötig und die Datenerfassung geht wesentlich schneller und einfacher.

### Mögliche Einrichtungen für die Kontaktdatenerfassung bzgl. Corona:
* Restaurant
* Frisör
* Gerichte
* Pflegeheime
* Krankenhäuser

## Szenario 2:
Die App ermöglicht den Einmalzugang nach Bezahlung, beispielsweise in ein Fitnessstudio.\
Der Kunde scannt am Eingang des Fitnessstudios einen QR-Code, über den ein Bezahlvorgang angezeigt und dann mittels der App gestartet bzw. erledigt werden kann. Sobald das Fitnessstudio den Geldeingang registriert hat, wird das Drehkreuz bzw. die Tür geöffnet.\
In diesem Szenario ist die App allein nicht ausreichend, da das Drehkreuz bzw. der Türöffner vom Fitnessstudio angesteuert werden muss.

## QR-Code Protokoll (mögliche enthaltene Daten)
* Aktions-ID
* Kontaktdaten, die abgefragt werden sollen
* E-Mail-Adresse des Geschäfts
* Name des Geschäfts
* URL zur Speisekarte
* URL zur Getränkekarte
* WLAN-Zugangsdaten 
* URL zum Logo des Geschäfts
* URL zum Public-Key, mit dem die Daten verschlüsselt werden sollen
* Ob ein eindeutiges Token erzeugt werden soll, das veröffentlicht werden kann, ohne dass Rückschlüsse auf den Kunden gezogen werden können.
* Zu bestätigende/verneinende Abfragen. Beispiel: Waren Sie in den letzten 14 Tagen in einem Risikogebiet?

## Technik
QT/QML [2] \
qzxing [3] \
Zint [4] \
Botan [5]

## Lizenz
Es wird eine OpenSource-Lizenz; welche - muss noch entschieden werden

[1] https://hackathon.kreativitaet-trifft-technik.de/ \
[2] https://www.qt.io/, https://doc.qt.io/qt-5/qtqml-index.html \
[3] https://github.com/ftylitak/qzxing \
[4] https://github.com/zint/zint \
[5] https://github.com/randombit/botan

## Download

Prototyp:

https://www.jw78.de/download/ibd.apk

## Kontakt
Jens Wienöbst \
ichbinda@jw78.de

