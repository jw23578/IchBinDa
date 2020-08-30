import QtQuick 2.3
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.0

ESAAPage
{
    id: createqrcodepage
    signal close
    signal showCode
    onBackPressed:
    {
        console.log("create qr code")
        close()
    }
    property string qrCodeFileName: ""
    property alias theFacilityName: facilityName.displayText
    property alias theContactReceiveEMail: contactReceiveEMail.displayText
    property color textColor: ESAA.textColor
    function generate()
    {
        qrCodeFileName = ESAA.generateQRCode(facilityName.displayText,
                                             contactReceiveEMail.displayText,
                                             logoUrl.displayText,
                                             colorInput.displayText,
                                             adressSwitch.position > 0.9,
                                             emailSwitch.position > 0.9,
                                             mobileSwitch.position > 0.9,
                                             anonymReceiveEMail.displayText,
                                             parseInt(visitCounts.displayText),
                                             colorInputVisitCount.displayText);
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
        anchors.margins: ESAA.spacing
        anchors.bottom: showCodeButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.3
        clip: true
        Column
        {
            y: ESAA.spacing
            spacing: ESAA.spacing
            id: theColumn
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - parent.width / 10
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: facilityName
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                caption: qsTr("Name des Geschäfts")
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: logoUrl
                caption: "Logo-Url"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                inputMethodHints: Qt.ImhUrlCharactersOnly

            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
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
                color: createqrcodepage.textColor
                id: contactReceiveEMail
                caption: "E-Mail-Adresse an die die Kontaktdaten gesendet werden sollen"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                inputMethodHints: Qt.ImhEmailCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: anonymReceiveEMail
                caption: "Besuch anonym senden an"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                inputMethodHints: Qt.ImhEmailCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: visitCounts
                caption: "Jeden xten Besuch anzeigen"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                inputMethodHints: Qt.ImhDigitsOnly
            }
            ESAALineInputWithCaption
            {
                visible: parseInt(visitCounts.displayText) > 0
                color: createqrcodepage.textColor
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "Farbcode für xten Besuch"
                text: "#ffffff"
                onDisplayTextChanged:
                {
                    colorRectangleVisitCount.color = displayText
                }
                id: colorInputVisitCount
            }
            Rectangle
            {
                visible: parseInt(visitCounts.text) > 0
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                height: colorInputVisitCount.height
                id: colorRectangleVisitCount
            }

            ESAAText
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: textId
                color: createqrcodepage.textColor
                text: "Welche Daten sollen erfasst werden?"
            }

            ESAASwitch
            {
                id: adressSwitch
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Adressdaten")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: emailSwitch
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("E-Mail-Adresse")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: mobileSwitch
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Handynummer")
                fontColor: createqrcodepage.textColor
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
            if (facilityName.displayText == "")
            {
                facilityName.forceActiveFocus()
                ESAA.showMessage("Bitte gib noch den Namen des Geschäfts an.")
                return
            }
            if (contactReceiveEMail.displayText == "")
            {
                contactReceiveEMail.forceActiveFocus()
                ESAA.showMessage("Bitte gib noch die E-Mail-Adresse, an die die verschlüsselten Kontaktdaten gesendet werden sollen, an.")
                return
            }
            if (!ESAA.isEmailValid(contactReceiveEMail.displayText))
            {
                contactReceiveEMail.forceActiveFocus()
                ESAA.showMessage("Die E-Mail-Adresse, an die die verschlüsselten Kontaktdaten gesendet werden sollen ist ungültig.<br>Bitte korrigieren.")
                return
            }
            if (anonymReceiveEMail.displayText != "" && !ESAA.isEmailValid(anonymReceiveEMail.displayText))
            {
                anonymReceiveEMail.forceActiveFocus()
                ESAA.showMessage("Die E-Mail-Adresse, an die die Besuche anonym gesendet werden sollen ist ungültig.<br>Bitte korrigieren.")
                return
            }
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
