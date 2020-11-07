import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"

ESAAPage
{
    signal startNow
    signal back
    caption: "Hilfe"
    function goStartNow()
    {
        betreiberinfo.visible = false
        kundeinfo.visible = false
        startNow()
    }
    function backFunction()
    {
        if (betreiberinfo.visible || kundeinfo.visible)
        {
            betreiberinfo.visible = false
            kundeinfo.visible = false
            return
        }
        back()
    }

    onBackPressed:
    {
        backFunction()
    }

    signal editContactData
    function goEditContactData()
    {
        betreiberinfo.visible = false
        kundeinfo.visible = false
        editContactData()
    }

    Column
    {
        visible: !betreiberinfo.visible && !kundeinfo.visible
        id: theGrid
        property int buttonSize: JW78Utils.screenWidth / 2
        property int buttonFontPixelSize: ESAA.fontButtonPixelsize * 1.5
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: buttonSize
        topPadding: spacing
        spacing: buttonSize / 4
        CircleButton
        {
            id: b1
            smallTopText: "Ich bin"
            text: "Betreiber<br>oder<br>Veranstalter"
            onClicked:
            {
                view.contentY = 0
                betreiberinfo.visible = true
            }
            width: theGrid.buttonSize
            font.pixelSize: theGrid.buttonFontPixelSize
        }
        CircleButton
        {
            smallTopText: "Ich bin"
            text: "Kunde<br>oder<br>Besucher"
            onClicked:
            {
                view2.contentY = 0
                kundeinfo.visible = true
            }
            width: theGrid.buttonSize
            font.pixelSize: theGrid.buttonFontPixelSize
        }
    }
    BackButton
    {
        visible: !ESAA.firstStart
        onClicked: backFunction()
    }
    Item
    {
        id: betreiberinfo
        visible: false
        anchors.fill: parent
        ESAAFlickable
        {
            id: view
            anchors.margins: ESAA.spacing
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: betreiberFinishedButton.top
            contentHeight: theText.height + 2 * ESAA.spacing
            TextArea
            {
                parent: view.contentItem
                id: theText
                height: contentHeight
                width: parent.width
                readOnly: true
                textFormat: TextEdit.RichText
                wrapMode: Text.WordWrap
                text: "Als Betreiber kannst du mit dieser App einen QR-Code anlegen in dem enthalten ist, welche Kontaktdaten du abfragen möchtest. " +
                      "Außerdem gibst du an, an welche E-Mail-Adresse die Kontaktdaten geschickt werden sollen." +
                      "Für die Speicherung der Kontaktdaten wird kein zentraler Server eingesetzt, sondern ausschließlich dein E-Mail-Postfach für das du verantwortlich bist.<br>" +
                      "Die Kontaktdaten der Kunden/Besucher werden verschlüsselt in der Mail übertragen und können nicht von dir ausgelesen werden.<br>" +
                      "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                      "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos.<br>"
                color: ESAA.buttonColor

            }
        }
        CircleButton
        {
            id: betreiberFinishedButton
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: ESAA.spacing
            text: "Los geht's"
            onClicked: goStartNow()
        }
    }
    Item
    {
        id: kundeinfo
        visible: false
        anchors.fill: parent
        ESAAFlickable
        {
            id: view2
            anchors.margins: ESAA.spacing
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: editButton.top
            contentHeight: theText2.height + 2 * ESAA.spacing
            TextArea
            {
                parent: view2.contentItem
                id: theText2
                height: contentHeight
                width: parent.width
                readOnly: true
                textFormat: TextEdit.RichText
                wrapMode: Text.WordWrap
                text: "Als Kunde/Besucher kannst du mit dieser App die <b>" + ESAA.appName + "</b>-QR-Codes scannen " +
                      "und deine Kontaktdaten komfortabel an den Betreiber übermitteln." +
                      "<br><br>Du musst deine " +
                      "Daten nur <b>einmal</b> eingeben, für den nächsten Besuch sind sie dann schon gespeichert und werden vorbelegt. " +
                      "<br><br>Deine Kontaktdaten werden <b>ausschließlich</b> in der App gespeichert und per <b>verschlüsselter</b> E-Mail an den Betreiber übermittelt. " +
//                      "<br>Es gibt keinen zentralen Server auf dem " +
//                      "deine persönlichen Daten gespeichert werden würden." +
                      "<br><br>Der Betreiber/Anbieter ist <b>ausschließlich</b> in der Lage auf deine Kontaktdaten zuzugreifen, wenn er von entsprechenden Einrichtungen aufgefordert wird die Kontaktdaten auszuhändigen. " +
//                      "<br><br>Pro Besuch wird ein anonymes Token erzeugt und auf einem Server gespeichert. <b>Ausschließlich</b> deine App kann dieses Token dir zuordnen. Lediglich Besuchsort Standort und Datum/Uhrzeit lesbar, " +
//                      "so dass Veranstaltungen bei denen es möglicherweise nachzuverfolgende Kontakte gab markiert werden können. " +
                      "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                      "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos.<br>"
                color: ESAA.buttonColor
            }
        }
        CircleButton
        {
            id: editButton
            anchors.bottom: parent.bottom
            anchors.margins: ESAA.spacing
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Meine<br>Kontaktdaten<br>bearbeiten")
            onClicked: goEditContactData()
        }

//        TwoCircleButtons
//        {
//            id: editButton
//            anchors.bottom: parent.bottom
//            anchors.margins: ESAA.spacing
//            leftText: qsTr("Meine<br>Kontaktdaten<br>bearbeiten")
//            onLeftClicked: goEditContactData()
//            rightText: "Los geht's"
//            onRightClicked: goStartNow()
//        }
    }
}
