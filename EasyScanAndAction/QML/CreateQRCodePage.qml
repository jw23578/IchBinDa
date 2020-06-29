import QtQuick 2.3
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.0

Rectangle
{
    anchors.fill: parent
    color: "#deb887"
    id: createqrcodepage
    function generate()
    {
        qrImage.source = "file://" + ESAA.generateQRCode(locationName.displayText,
                                                         contactReceiveEMail.displayText,
                                                         logoUrl.displayText,
                                                         colorInput.displayText,
                                                         adressSwitch.position > 0.9,
                                                         emailSwitch.position > 0.9,
                                                         mobileSwitch.position > 0.9);
    }


    ColorDialog
    {
        id: colorDialog
        title: "Please choose a color"
        onAccepted: {
            console.log("You chose: " + colorDialog.color)
            colorRectangle.color = colorDialog.color
        }
    }
    Flickable
    {
        anchors.bottom: quitButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.5
        Column
        {
            spacing: textId.height / 2
            id: theColumn
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - parent.width / 10
            Item
            {
                width: parent.width
                height: parent.spacing
            }

            ESAALineInputWithCaption
            {
                id: locationName
                width: parent.width
                caption: qsTr("Name des Geschäfts")
                onDisplayTextChanged: generate()
            }
            ESAALineInputWithCaption
            {
                id: logoUrl
                caption: "Logo-Url"
                width: parent.width
                onDisplayTextChanged: generate()
            }
            ESAALineInputWithCaption
            {
                width: parent.width
                caption: "Farbcode"
                text: "#ffffff"
                onDisplayTextChanged:
                {
                    colorRectangle.color = displayText
                    generate()
                }
                id: colorInput
            }
            Rectangle
            {
                width: parent.width
                color: "white"
                height: colorInput.height
                id: colorRectangle
            }

            ESAALineInputWithCaption
            {
                id: contactReceiveEMail
                caption: "E-Mail-Adresse an die die Kontaktdaten gesendet werden sollen"
                width: parent.width
                onDisplayTextChanged: generate()
            }
            ESAAText
            {
                id: textId
                text: "Welche Daten sollen erfasst werden?"
            }

            ESAASwitch
            {
                id: adressSwitch
                width: parent.width
                text: qsTr("Adressdaten")
                onClicked: generate()
            }
            ESAASwitch
            {
                id: emailSwitch
                width: parent.width
                text: qsTr("E-Mail-Adresse")
                onClicked: generate()
            }
            ESAASwitch
            {
                id: mobileSwitch
                width: parent.width
                text: qsTr("Handynummer")
                onClicked: generate()
            }
            Image
            {
                width: parent.width
                height: width
                id: qrImage
                fillMode: Image.PreserveAspectFit
                sourceSize.height: height
                sourceSize.width: width
            }
        }
    }
    Button
    {
        id: quitButton
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        text: "Abbrechen"
        onClicked: createqrcodepage.visible = false
    }

}
