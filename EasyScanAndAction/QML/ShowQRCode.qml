import QtQuick 2.0

ESAAPage
{
    signal back
    onBackPressed:
    {
        back()
    }
    property string qrCodeFileName: ""
    property alias sendEMailTo: qrCodeEMailAdresse.text
    property string facilityName: ""
    Flickable
    {
        anchors.bottom: sendButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.2
        clip: true
        Rectangle
        {
            anchors.fill: theColumn
            color: ESAA.textBackgroundColor
            radius: 5
            opacity: 0.8
        }

        Column
        {
            y: ESAA.spacing
            spacing: ESAA.spacing
            id: theColumn
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - parent.width / 10
            Item
            {
                width: parent.width
                height: ESAA.spacing / 2
            }
            Rectangle
            {
                id: qrRectangle
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - ESAA.spacing
                height: width
                Image
                {
                    cache: false
                    anchors.fill: parent
                    anchors.margins: ESAA.spacing / 2
                    id: qrImage
                    fillMode: Image.PreserveAspectFit
                    sourceSize.height: height
                    sourceSize.width: width
                    source: qrCodeFileName ? "file://" + qrCodeFileName : ""
                }
            }
            ESAALineInputWithCaption
            {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - ESAA.spacing
                caption: "QR-Code senden an"
                id: qrCodeEMailAdresse
                inputMethodHints: Qt.ImhEmailCharactersOnly
            }
        }
    }

    ESAAButton
    {
        id: sendButton
        anchors.margins: ESAA.spacing
        anchors.bottom: quitButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: "QR-Code senden"
        onClicked:
        {
            if (!ESAA.isEmailValid(qrCodeEMailAdresse.displayText))
            {
                ESAA.showMessage("Bitte gib eine gültige E-Mail-Adresse ein.");
                qrCodeEMailAdresse.forceActiveFocus();
                return
            }

            ESAA.sendQRCode(qrCodeEMailAdresse.displayText, facilityName)
        }
    }

    ESAAButton
    {
        id: quitButton
        anchors.margins: ESAA.spacing
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Abbrechen"
        onClicked: back()
    }
}
