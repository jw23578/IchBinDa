import QtQuick 2.15
import QtQuick.Controls 2.13

ESAAPage
{
    signal editContactData
    signal close
    signal editQRCode
    signal help
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
            columns: 3
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: buttonSize * 3 + 2 * spacing
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
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                text: qsTr("IchBinDa!<br>im Internet")
                onClicked: Qt.openUrlExternally("https://www.app-ichbinda.de")
                width: parent.buttonSize
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
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                text: qsTr("Im Falle<br>des Falles")
                onClicked: Qt.openUrlExternally("https://www.app-ichbinda.de/index.html#for-operator-in-case")
                width: parent.buttonSize
            }        }
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
