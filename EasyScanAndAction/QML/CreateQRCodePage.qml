import QtQuick 2.3
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.0

ESAAPage
{
    caption: "QR-Code erstellen"
    id: createqrcodepage
    signal close
    signal showCode
    onBackPressed:
    {
        console.log("create qr code")
        close()
    }
    Rectangle
    {
        id: removeMeLater
        anchors.fill: parent
        color: "white"
    }
    property string qrCodeFileName: ""
    property alias theFacilityName: facilityName.displayText
    property alias theContactReceiveEMail: contactReceiveEMail.displayText
    property color textColor: "#4581B3"
    property variant yesQuestionVector: []
    function generate()
    {
        ESAA.clearYesQuestions()
//        for (var i = 0; i < yesQuestionRepeater.count; ++i)
//        {
//            if (yesQuestionVector[i] != "")
//            {
//                ESAA.addYesQuestions(yesQuestionVector[i])
//            }
//        }

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

    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: showCodeButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.3
        Column
        {
            parent: theFlick.contentItem
            y: ESAA.spacing
            spacing: ESAA.spacing
            id: theColumn
            width: parent.width
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
                caption: "Farbcode (Format: #ffffff)"
                colorEdit: true
                onDisplayTextChanged:
                {
                    colorRectangle.color = displayText
                }
                id: colorInput
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: contactReceiveEMail
                caption: "Kontaktdaten senden an (E-Mail-Adresse)"
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                inputMethodHints: Qt.ImhEmailCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: anonymReceiveEMail
                caption: "Anonym senden an (E-Mail-Adresse)"
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
                caption: "Farbcode für xten Besuch (Format: #ffffff)"
                text: "#ffffff"
                colorEdit: true
                id: colorInputVisitCount
            }
            ESAAText
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: textId
                color: createqrcodepage.textColor
                text: "Welche Daten sollen erfasst werden?"
                wrapMode: Text.WordWrap
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
            /*
            ESAAText
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                color: createqrcodepage.textColor
                text: "Folgende Fragen müssen jedesmal mit \"Ja\" beantwortet werden:"
                wrapMode: Text.WordWrap
            }
            Repeater
            {
                id: yesQuestionRepeater
                model: 1
                Row
                {
                    width: parent.width - 2 * ESAA.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    ESAALineInputWithCaption
                    {
                        color: createqrcodepage.textColor
                        width: parent.width - height
                        caption: (index + 1) + ". Frage"
                        id: yesQuestion
                        Component.onCompleted: text = yesQuestionVector[index]
                        onDisplayTextChanged: yesQuestionVector[index] = displayText
                    }
                    Item
                    {
                        width: ESAA.spacing / 2
                    }

                    ESAAIconButton
                    {
                        source: "qrc:/images/eraseIcon.svg"
                        width: yesQuestion.inputHeight
                        height: width
                        anchors.bottom: parent.bottom
                        Component.onCompleted:
                        {
                            if (index == yesQuestionRepeater.count - 1)
                            {
                                rotate(100)
                            }
                        }
                        onClicked:
                        {
                            if (yesQuestionRepeater.count <= 1)
                            {
                                return
                            }

                            for (var i = index; i < yesQuestionRepeater.count; ++i)
                            {
                                yesQuestionVector[i] = yesQuestionVector[i + 1]
                            }
                            yesQuestionVector[yesQuestionRepeater.count - 1] = ""
                            yesQuestionRepeater.model = yesQuestionRepeater.count - 1
                        }
                    }
        }
    }
            ESAAButton
            {
                width: parent.width
                text: "weitere Frage"
                onClicked: yesQuestionRepeater.model = yesQuestionRepeater.count + 1
                anchors.horizontalCenter: parent.horizontalCenter
            }*/

            Item
            {
                width: parent.width
                height: 1
            }
        }
    }
    CircleButton
    {
        id: showCodeButton
        anchors.margins: ESAA.spacing
        anchors.bottom: parent.bottom
        anchors.bottomMargin: height / 2
        anchors.horizontalCenter: parent.horizontalCenter
        text: "QR-Code<br>erzeugen"
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
    BackButton
    {
        onClicked: close()
    }
}
