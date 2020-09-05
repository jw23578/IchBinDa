import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal editContactData
    signal close
    signal editQRCode
    signal help
    caption: "Menü"
    Rectangle
    {
        id: removeMeLater
        anchors.fill: parent
        color: "white"
    }

    onShowing:
    {
        shareButton.blink(400)
        shareButton.rotate(400)
        spendenButton.blink(500)
    }

    Column
    {
        anchors.fill: parent
        anchors.margins: ESAA.spacing
        topPadding: spacing / 2
        spacing: (height - 6 * qrcodebutton.height) / 6
        ESAAButton
        {
            id: qrcodebutton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "QR-Code\nanlegen"
            onClicked: editQRCode()
        }
        ESAAButton
        {
            id: editButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Meine Kontaktdaten\nbearbeiten")
            onClicked: editContactData()
        }
        ESAAButton
        {
            id: helpButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Hilfe"
            onClicked: help()
        }
        ESAAButton
        {
            id: shareButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Weiterempfehlen")
            onClicked: ESAA.recommend()
            source: "qrc:/images/share-icon-40146.png"
        }
        ESAAButton
        {
            id: spendenButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Spenden")
            onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M29Q4NYS8DXYJ&source=url")
        }
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
