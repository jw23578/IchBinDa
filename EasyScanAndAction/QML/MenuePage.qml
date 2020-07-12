import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal editContactData
    signal close
    signal editQRCode
    onShowing:
    {
        shareButton.blink(400)
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
            text: qsTr("Meine\nKontaktdaten\nbearbeiten")
            onClicked: editContactData()
        }
        ESAAButton
        {
            id: helpButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Hilfe"
            onClicked: ESAA.firstStart = true
        }
        ESAAButton
        {
            id: shareButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Weiterempfehlen")
            onClicked: ESAA.recommend()
        }
        ESAAButton
        {
            id: spendenButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Spenden")
            onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M29Q4NYS8DXYJ&source=url")
        }

        ESAAButton
        {
            id: closeButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Schließen"
            onClicked: close()
        }
    }
}
