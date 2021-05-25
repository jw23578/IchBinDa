import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"

ESAAPage
{
    signal agreed
    showMenueButton: false
    caption: "Zustimmung"
    captionImageSource: "qrc:/images/mobileImage1.svg"

    ESAAFlickable
    {
        id: view
        anchors.margins: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: buttons.top
        contentHeight: theText.height
        TextArea
        {
            parent: view.contentItem
            id: theText
            height: contentHeight * 1.1
            width: parent.width
            readOnly: true
            textFormat: TextEdit.RichText
            wrapMode: Text.WordWrap
            text: "<h3>Zustimmung</h3><h4>Für Betreiber:</h4>" +
                  "Du bekommst die Daten verschlüsselt an eine Deiner E-Mail-Adressen gesendet. " +
                  "Durch die Verschlüsselung ist es nicht zwingend nötig die Daten nach bestimmten Fristen zu löschen." +
                  "<br>Ausschließlich entsprechenden Einrichtungen wie dem Gesundheitsamt werden die Daten entschlüsselt.<br>" +
                  "<h4>Für Kunden und Besucher:</h4>" +
                  "Deine Daten werden verschlüsselt per E-Mail an den Betreiber übertragen, beim Versand werden außerdem die gängigen Verschlüsselungsverfahren benutzt.<br>" +
                  "Deine Daten können nur eingesehen werden, wenn diese<br>" +
                  "a) vom entsprechenden Stellen, zum Beispiel dem Gesundheitsamt, angefordert werden<br>" +
                  "und<br>" +
                  "b) der entsprechende private Key zum entschlüsseln vorliegt.<br>" +
                  "<br><br>Pro Besuch wird ein zufälliges anonymes Token erzeugt das mit Datum/Uhrzeit und einem Locationtoken auf einem Server gespeichert wird. Über diese Token können keine persönlichen Daten in Erfahrung gebracht werden." +
                  "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                  "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos."
            color: JW78APP.mainColor
        }
    }
    TwoCircleImages
    {
        id: buttons
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        leftSource: "qrc:/images/thumbs-up.svg"
        leftImagesize: buttonSize / 2
        rightImagesize: buttonSize / 2
        leftCircle.color: JW78APP.mainColor
        leftCircle.layerEnabled: false
        onLeftClicked:
        {
            ESAA.aggrementChecked = true
            ESAA.saveData()
            agreed()
        }
        rightSource: "qrc:/images/thumbs-down.svg"
        rightCircle.color: "transparent"
        rightCircle.border.color: JW78APP.mainColor
        rightCircle.layerEnabled: false
        onRightClicked: Qt.quit()

    }
}
