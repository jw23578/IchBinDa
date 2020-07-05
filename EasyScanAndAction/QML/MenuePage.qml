import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal editContactData
    signal close
    Column
    {
        anchors.fill: parent
        anchors.margins: ESAA.spacing
        topPadding: spacing / 2
        spacing: (height - 4 * qrcodebutton.height) / 4
        ESAAButton
        {
            id: qrcodebutton
            width: parent.width
            font.pixelSize: parent.height / 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: "QR-Code\nerzeugen"
            onClicked: createqrcodepage.visible = true
        }
        ESAAButton
        {
            width: parent.width
            font.pixelSize: parent.height / 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Hilfe"
            onClicked: ESAA.firstStart = true
        }
        ESAAButton
        {
            width: parent.width
            font.pixelSize: parent.height / 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Meine\nKontaktdaten\nbearbeiten")
            onClicked: editContactData()
        }
        ESAAButton
        {
            width: parent.width
            font.pixelSize: parent.height / 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Schließen"
            onClicked: close()
        }
    }
    CreateQRCodePage
    {
        id: createqrcodepage
        anchors.fill: parent
        visible: false
        onVisibleChanged:
        {
            if (visible)
            {
                camera.stop()
            }
            else
            {
                camera.start()
            }
        }
    }
}
