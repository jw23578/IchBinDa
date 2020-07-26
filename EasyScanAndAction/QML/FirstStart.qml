import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal startNow
    signal editContactData
    Column
    {
        anchors.fill: parent
        anchors.margins: ESAA.spacing
        topPadding: spacing / 2
        spacing: (height - 4 * b1.height) / 4

        ESAAButton
        {
            visible: !betreiberinfo.visible && !kundeinfo.visible
            id: b1
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich bin\nBetreiber"
            onClicked: betreiberinfo.visible = true
        }
        ESAAButton
        {
            visible: !betreiberinfo.visible && !kundeinfo.visible
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich bin\nKunde/Besucher"
            onClicked: kundeinfo.visible = true
        }
        ESAAButton
        {
            visible: !betreiberinfo.visible && !kundeinfo.visible
            id: shareButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Weiterempfehlen")
            onClicked: ESAA.recommend()
            source: "qrc:/images/share-icon-40146.png"
        }
        ESAAButton
        {
            visible: !betreiberinfo.visible && !kundeinfo.visible
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich möchte\ndirekt loslegen"
            onClicked: startNow()
        }
    }
    Item
    {
        id: betreiberinfo
        visible: false
        anchors.fill: parent
        Rectangle
        {
            anchors.fill: parent
            opacity: 0.8
            color: ESAA.backgroundTopColor
        }
        Flickable
        {
            id: view
            anchors.margins: ESAA.spacing
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: betreiberFinishedButton.top
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
                text: "Als Betreiber kannst du mit dieser App einen QR-Code anlegen in dem enthalten ist, welche Kontaktdaten du abfragen möchtest. " +
                      "Außerdem gibs du an, an welche E-Mail-Adresse die Kontaktdaten geschickt werden sollen." +
                      "Für die Speicherung der Kontaktdaten wird kein zentraler Server eingesetzt, sondern ganz alleine dein E-Mail-Postfach für das du verantwortlich bist.<br>" +
                      "Die Kontaktdaten der Kunden/Besucher werden verschlüsselt in der Mail übertragen und können nicht von dir ausgelesen werden.<br>" +
                      "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                      "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos."
                color: ESAA.fontColor

            }
        }
        ESAAButton
        {
            id: betreiberFinishedButton
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: ESAA.spacing
            text: "Los geht's"
            onClicked: startNow()
        }
    }
    Item
    {
        id: kundeinfo
        visible: false
        anchors.fill: parent
        Rectangle
        {
            anchors.fill: parent
            opacity: 0.8
            color: ESAA.backgroundTopColor
        }
        Flickable
        {
            id: view2
            anchors.margins: ESAA.spacing
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: editButton.top
            contentHeight: theText2.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            TextArea
            {
                id: theText2
                height: contentHeight
                width: parent.width
                readOnly: true
                textFormat: TextEdit.RichText
                wrapMode: Text.WordWrap
                text: "Als Kunde/Besucher kannst du mit dieser App die IchBinDa-QR-Codes scannen " +
                      "und deine Kontaktdaten komfortabel an den Betreiber übermitteln. Du musst deine " +
                      "Daten nur einmal eingeben, für den nächsten Besuch sind die schon gespeichert und werden vorbelegt. " +
                      "Deine Kontaktdaten werden nur in der App gespeichert und per verschlüsselter E-Mail an den Betreiber übermittelt. Es gibt keinen zentralen Server auf dem " +
                      "deine persönlichen Daten gespeichert würden.<br>" +
                      "Der Betreiber/Anbieter ist nicht in der Lage auf deine Kontaktdaten zuzugreifen, dass ist nur entsprechenden Einrichtungen möglich, die den private Key zum Entschlüsseln bekommen. " +
                      "Au0erdem muss diesen Einrichtungen vom Betreiber/Anbieter die E-Mail weitergeleitet werden.<br>" +
                      "Pro Besuch wird ein anonymes Token erzeugt und auf einem Server gespeichert. Dieses Token kann nur deine App erkennen. Der Standort und Datum/Uhrzeit sind in dem Token aber immer gleich, " +
                      "so dass Veranstaltungen bei denen es möglicherweise Corona Kontakte gab markiert werden können. " +
                      "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                      "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos."
                color: ESAA.fontColor

            }
        }
        ESAAButton
        {
            id: editButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: kundenInfoFinishedButton.top
            anchors.margins: ESAA.spacing
            text: qsTr("Meine Kontaktdaten\nbearbeiten")
            onClicked: editContactData()
        }
        ESAAButton
        {
            id: kundenInfoFinishedButton
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Los geht's"
            onClicked: startNow()
            anchors.margins: ESAA.spacing
        }
    }
}
