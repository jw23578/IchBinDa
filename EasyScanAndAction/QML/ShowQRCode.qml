import QtQuick 2.15
import "Comp"

ESAAPage
{
    signal back
    onBackPressed:
    {
        back()
    }
    property string qrCodeFileName: ""
    property string logoUrl: ""
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
            ESAAText
            {
                width: parent.width
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: ESAA.fontTextPixelsize * 0.9
                text: "QR-Code an folgende E-Mail-Adresse senden:"
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

    CircleButton
    {
        id: sendButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        text: "QR-Code<br>senden"
        onClicked:
        {
            if (!ESAA.isEmailValid(qrCodeEMailAdresse.displayText))
            {
                ESAA.showMessage("Bitte gib eine gültige E-Mail-Adresse ein.");
                qrCodeEMailAdresse.forceActiveFocus();
                return
            }
            ESAA.showWaitMessage("Bitte einen Moment Geduld. Es werden ein paar PDFs mit Logo und QR-Code erstellt, das dauert kurz.")
            ESAA.sendQRCode(qrCodeEMailAdresse.displayText, facilityName, logoUrl)
            back()
        }
    }
    BackButton
    {
        id: quitButton
        onClicked: back()
    }
}
