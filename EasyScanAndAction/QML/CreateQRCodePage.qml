import QtQuick 2.3
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.0

ESAAPage
{
    id: createqrcodepage
    signal close
    signal showCode
    property string qrCodeFileName: ""
    function generate()
    {
        qrCodeFileName = ESAA.generateQRCode(locationName.displayText,
                                             contactReceiveEMail.displayText,
                                             logoUrl.displayText,
                                             colorInput.displayText,
                                             adressSwitch.position > 0.9,
                                             emailSwitch.position > 0.9,
                                             mobileSwitch.position > 0.9,
                                             anonymReceiveEMail.displayText);
    }


    ColorDialog
    {
        id: colorDialog
        title: "Please choose a color"
        onAccepted: {
            colorRectangle.color = colorDialog.color
        }
    }
    Flickable
    {
        anchors.bottom: showCodeButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.5
        clip: true
        ESAATextBackground
        {
            anchors.fill: theColumn
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
                height: 1
            }
            ESAALineInputWithCaption
            {
                color: ESAA.fontColor2
                id: locationName
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                caption: qsTr("Name des Geschäfts")
            }
            ESAALineInputWithCaption
            {
                color: ESAA.fontColor2
                id: logoUrl
                caption: "Logo-Url"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
            }
            ESAALineInputWithCaption
            {
                color: ESAA.fontColor2
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "Farbcode"
                text: "#ffffff"
                onDisplayTextChanged:
                {
                    colorRectangle.color = displayText
                }
                id: colorInput
            }
            Rectangle
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                height: colorInput.height
                id: colorRectangle
            }

            ESAALineInputWithCaption
            {
                color: ESAA.fontColor2
                id: contactReceiveEMail
                caption: "E-Mail-Adresse an die die Kontaktdaten\ngesendet werden sollen"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
            }
            ESAALineInputWithCaption
            {
                color: ESAA.fontColor2
                id: anonymReceiveEMail
                caption: "Besuch anonym senden an"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ESAAText
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: textId
                color: ESAA.fontColor2
                text: "Welche Daten sollen erfasst werden?"
            }

            ESAASwitch
            {
                id: adressSwitch
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Adressdaten")
            }
            ESAASwitch
            {
                id: emailSwitch
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("E-Mail-Adresse")
            }
            ESAASwitch
            {
                id: mobileSwitch
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Handynummer")
            }
            Item
            {
                width: parent.width
                height: 1
            }
        }
    }
    ESAAButton
    {
        id: showCodeButton
        anchors.margins: ESAA.spacing
        anchors.bottom: quitButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: theColumn.width
        text: "QR-Code erzeugen"
        onClicked: {
            generate()
            showCode()
        }
    }

    ESAAButton
    {
        id: quitButton
        anchors.margins: ESAA.spacing
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: theColumn.width
        text: "Abbrechen"
        onClicked: close()
    }
}
