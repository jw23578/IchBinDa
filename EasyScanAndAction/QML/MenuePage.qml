import QtQuick 2.15
import QtQuick.Controls 2.15

ESAAPage
{
    signal editContactData
    signal close
    signal editQRCode
    signal help
    signal myVisitsClicked
    signal showKontaktTagebuchQRCode(string qrKontaktTagebuchQRCodeFilename);
    caption: "Menü"

    onShowing:
    {
        shareButton.blink(400)
        shareButton.rotate(400)
        spendenButton.blink(500)
    }

    Flickable
    {
        anchors.top: parent.top
        anchors.bottom: shareButton.top
        anchors.bottomMargin: ESAA.spacing * 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 2 * ESAA.spacing, contentWidth)
        contentHeight: height
        contentWidth: theGrid.width
        Grid
        {
            id: theGrid
            property int buttonSize: ESAA.screenWidth / 3
            property int buttonFontPixelSize: ESAA.fontButtonPixelsize
            property int anzahl: 6 + (myVisits.visible ? 1 : 0) + (kontakttagebuch.visible ? 1 : 0)
            columns: anzahl / 2 + anzahl % 2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: (buttonSize + spacing) * columns - spacing
            spacing: ESAA.spacing * 2
            rowSpacing: ESAA.spacing * 2
            topPadding: ESAA.spacing * 3
            CircleButton
            {
                id: qrcodebutton
                smallTopText: "Als Betreiber"
                text: "QR-Code\nanlegen"
                onClicked: editQRCode()
                width: parent.buttonSize
                font.pixelSize: theGrid.buttonFontPixelSize
            }
            CircleButton
            {
                id: editButton
                font.pixelSize: theGrid.buttonFontPixelSize
                alertAniRunning: ESAA.fstname == "" || ESAA.surname == ""
                repeatAlertAni: ESAA.fstname == "" || ESAA.surname == ""
                smallTopText: "Als Besucher"
                text: qsTr("Kontaktdaten<br>bearbeiten")
                onClicked: editContactData()
                width: parent.buttonSize
            }
            CircleButton
            {
                id: websiteButton
                font.pixelSize: theGrid.buttonFontPixelSize * 1.1
                text: qsTr("IchBinDa!<br>im Internet")
                onClicked: Qt.openUrlExternally("https://www.app-ichbinda.de")
                width: parent.buttonSize
            }
            CircleButton
            {
                id: myVisits
                text: qsTr("Meine<br>Besuche<br>") + AllVisits.count
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                width: parent.buttonSize
                visible: AllVisits.count > 0
                onClicked: myVisitsClicked()
            }

            CircleButton
            {
                id: helpButton
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                text: qsTr("Hilfe")
                onClicked: help()
                width: parent.buttonSize
            }
            CircleButton
            {
                id: spendenButton
                text: qsTr("Spenden")
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M29Q4NYS8DXYJ&source=url")
                width: parent.buttonSize
            }
            CircleButton
            {
                id: inCaseButton
                font.pixelSize: theGrid.buttonFontPixelSize * 1.1
                text: qsTr("Im Falle<br>des Falles")
                onClicked: Qt.openUrlExternally("https://www.app-ichbinda.de/index.html#for-operator-in-case")
                width: parent.buttonSize
            }
            CircleButton
            {
                id: kontakttagebuch
//                visible: ESAA.isDevelop
                font.pixelSize: theGrid.buttonFontPixelSize * 1.1
                text: qsTr("Kontakt<br>tagebuch<br>QR-Code")
                onClicked:
                {
                    if (ESAA.fstname == "")
                    {
                        ESAA.showMessage("Bitte gib vorher noch deinen Vornamen in deinen Kontaktdaten ein.")
                        return;
                    }
                    if (ESAA.surname == "")
                    {
                        ESAA.showMessage("Bitte gib vorher noch deinen Nachnamen in deinen Kontaktdaten ein.")
                        return;
                    }
                    if (ESAA.emailAdress == "")
                    {
                        ESAA.showMessage("Bitte gib vorher noch deinen E-Mail-Adresse in deinen Kontaktdaten ein.")
                        return;
                    }
                    var fn = ESAA.generateKontaktTagebuchQRCode()
                    showKontaktTagebuchQRCode(fn)
                }

                width: parent.buttonSize
            }

        }
    }
    ShareButton
    {
        id: shareButton
    }
    BackButton
    {
        onClicked: close()
    }
    onBackPressed:
    {
        console.log("menuepage back")
        close()
    }
}
