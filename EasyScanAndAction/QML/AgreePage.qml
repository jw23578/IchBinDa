import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal agreed
    Flickable
    {
        id: view
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: button.top
        flickableDirection: Flickable.VerticalFlick

        TextArea
        {
            width: parent.width
            readOnly: true
            textFormat: TextEdit.RichText
            wrapMode: Text.WordWrap
            text: "<h3>Zustimmung</h3><h4>Für Betreiber:</h4>" +
                  "Du bekommst die Daten per E-Mail an eine beliebige Deiner E-Mail-Adressen gesendet und bist für die orgnungsgemäße Löschung nach Ablauf der Fristen zuständig. Bitte informiere Deine Kunden/Besucher entsprechend." +
                  "<h4>Für Kunden und Besucher:</h4>" +
                  "Deine Daten werden per E-Mail an den Betreiber übertragen, die E-Mail selbst ist nicht verschlüsselt, beim Versand werden die gängigen Verschlüsselungsverfahren benutzt." +
                  "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                  "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos."
            color: ESAA.fontColor

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
