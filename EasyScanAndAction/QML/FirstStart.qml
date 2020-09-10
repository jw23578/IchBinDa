import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal startNow
    caption: "Hilfe"
    function goStartNow()
    {
        betreiberinfo.visible = false
        kundeinfo.visible = false
        startNow()
    }
    onBackPressed:
    {
        goStartNow()
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
        property int buttonSize: ESAA.screenWidth / 3
        property int buttonFontPixelSize: ESAA.fontButtonPixelsize
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: buttonSize * 2.5
        topPadding: spacing / 2
        spacing: buttonSize / 3
        Row
        {
            spacing: theGrid.width - 2 * theGrid.buttonSize
            CircleButton
            {
                id: b1
                text: "Ich bin\nBetreiber"
                onClicked: betreiberinfo.visible = true
                width: theGrid.buttonSize
                font.pixelSize: theGrid.buttonFontPixelSize
            }
            CircleButton
            {
                text: "Ich bin Kunde\n/Besucher"
                onClicked: kundeinfo.visible = true
                width: theGrid.buttonSize
                font.pixelSize: theGrid.buttonFontPixelSize
            }
        }
        CircleButton
        {
            id: shareButton
            anchors.horizontalCenter: parent.horizontalCenter
            belowCaption: qsTr("Weiterempfehlen")
            onClicked: ESAA.recommend()
            source: "qrc:/images/share_weiss.svg"
            downSource: "qrc:/images/share_blau.svg"
            width: theGrid.buttonSize
            font.pixelSize: theGrid.buttonFontPixelSize
        }
        Item
        {
            width: parent.width
            height: 1
        }

        CircleButton
        {
            text: "Ich möchte\ndirekt loslegen"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: goStartNow()
            width: theGrid.buttonSize
            font.pixelSize: theGrid.buttonFontPixelSize
        }
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
                      "<br>Es gibt keinen zentralen Server auf dem " +
                      "deine persönlichen Daten gespeichert werden würden." +
                      "<br><br>Der Betreiber/Anbieter ist <b>nicht</b> in der Lage auf deine Kontaktdaten zuzugreifen, dass ist nur entsprechenden Einrichtungen möglich, die den \"private Key\" zum Entschlüsseln bekommen. " +
                      "Außerdem muss diesen Einrichtungen vom Betreiber/Anbieter die verschlüsselte E-Mail weitergeleitet werden." +
                      "<br><br>Pro Besuch wird ein anonymes Token erzeugt und auf einem Server gespeichert. <b>Ausschließlich</b> deine App kann dieses Token dir zuordnen. Lediglich Besuchsort Standort und Datum/Uhrzeit lesbar, " +
                      "so dass Veranstaltungen bei denen es möglicherweise nachzuverfolgende Kontakte gab markiert werden können. " +
                      "<br><br>Diese App und der Hersteller sind nicht für die korrekte Handhabung der Daten verantwortlich und übernehmen keinerlei Haftung." +
                      "<br>Die Benutzung dieser App ist <b>freiwillig</b> und kostenlos.<br>"
                color: ESAA.buttonColor
            }
        }

        TwoCircleButtons
        {
            id: editButton
            anchors.bottom: parent.bottom
            anchors.margins: ESAA.spacing
            leftText: qsTr("Meine<br>Kontaktdaten<br>nbearbeiten")
            onLeftClicked: goEditContactData()
            rightText: "Los geht's"
            onRightClicked: goStartNow()
        }
    }
}
