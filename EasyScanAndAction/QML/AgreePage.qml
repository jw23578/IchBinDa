import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal agreed
    Flickable
    {
        id: view
        anchors.margins: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: button.top
        contentHeight: theText.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

        TextArea
        {
            id: theText
            height: contentHeight
            width: parent.width
            readOnly: true
            textFormat: TextEdit.RichText
            wrapMode: Text.WordWrap
            text: "<h3>Zustimmung</h3><h4>Für Betreiber:</h4>" +
                  "Du bekommst die Daten verschlüsselt per E-Mail an eine beliebige Deiner E-Mail-Adressen gesendet." +
                  "Durch die Verschlüsselung ist es nicht zwingend nötig die Daten nach bestimmten Fristen zu löschen. " +
                  "<h4>Für Kunden und Besucher:</h4>" +
                  "Deine Daten werden verschlüsselt per E-Mail an den Betreiber übertragen, beim Versand werden außerdem die gängigen Verschlüsselungsverfahren benutzt.<br>" +
                  "Deine Daten können nur eingesehen werden, wenn diese<br>" +
                  "a) vom entsprechenden Stellen, zum Beispiel Gesundheitsamt, angefordert werden<br>" +
                  "und<br>" +
                  "b) der entsprechende private Key zum entschlüsseln vorliegt.<br>" +
                  "<br><br>Pro Besuch wird ein zufälliges Token erzeugt das mit Datum/Uhrzeit und einem Locationtoken auf einem Server gespeichert wird. Über diese Token können keine persönlichen Daten in Erfahrung gebracht werden." +
                  "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                  "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos."
            color: ESAA.textColor

        }
    }

    ESAAButton
    {
        id: button
        anchors.bottom: deniebutton.top
        anchors.margins: ESAA.spacing
        text: qsTr("Ich habe verstanden")
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked:
        {
            ESAA.aggrementChecked = true
            ESAA.saveData()
            agreed()
        }
    }
    ESAAButton
    {
        id: deniebutton
        anchors.margins: ESAA.spacing
        anchors.bottom: parent.bottom
        text: qsTr("Dann möchte ich die\nApp nicht benutzen")
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked:
        {
            Qt.quit()
        }
    }
}
