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
    property string qrCodeFileName: ""
    property alias theFacilityName: facilityName.displayText
    property alias theContactReceiveEMail: contactReceiveEMail.displayText
    property color textColor: "#4581B3"
    property variant yesQuestionVector: []
    function generate()
    {
        ESAA.clearYesQuestions()
        for (var i = 0; i < yesQuestionRepeater.count; ++i)
        {
            if (yesQuestionVector[i] != "")
            {
                ESAA.addYesQuestions(yesQuestionVector[i])
            }
        }

        qrCodeFileName = ESAA.generateQRCode(9999,
                                             facilityName.displayText,
                                             contactReceiveEMail.displayText,
                                             logoUrl.displayText,
                                             colorInput.displayText,
                                             adressSwitch.position > 0.9,
                                             emailSwitch.position > 0.9,
                                             mobileSwitch.position > 0.9,
                                             anonymReceiveEMail.displayText,
                                             parseInt(visitCounts.displayText),
                                             colorInputVisitCount.displayText,
                                             tableNumber.position > 0.9,
                                             whoIsVisited.position > 0.9,
                                             station.position > 0.9,
                                             room.position > 0.9,
                                             block.position > 0.9,
                                             seatNumber.position > 0.9,
                                             websiteURL.displayText,
                                             foodMenue.displayText,
                                             drinksMenue.displayText,
                                             individualURL1.displayText,
                                             individualURL1Caption.displayText,
                                             lunchMenue.displayText);
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
            width: parent.width - 2 * ESAA.spacing
            anchors.horizontalCenter: parent.horizontalCenter
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                inputMethodHints: Qt.ImhDigitsOnly
                id: qrCodeNumber
                width: parent.width
                caption: qsTr("Betreiber Code")
                helpText: "Mit einem bestimmten Betreiber Code können die Kontaktdaten mit einem bestimmten Satz von Schlüsseln kodiert und dekodiert werden." +
                          "<br><br>Mit einem individuellen Schlüsselsatz haben Betreiber die Möglichkeit die Daten selbst zu entschlüsseln." +
                          "<br><br>Kontaktieren sie mich unter ichbinda@app-ichbinda.de für weitere Informationen." +
                          "<br><br>Der Standardcode der ausschließlich vom Gesundheitsamt dekodiert werden kann ist <b>9999</b>"
                onHelpClicked: ESAA.showMessage(ht)
                visible: false
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: facilityName
                width: parent.width
                caption: qsTr("Name des Geschäfts")
                helpText: "Dieser Name wird dem Besucher angezeigt, wenn er den QR-Code eingescannt hat."
                onHelpClicked: ESAA.showMessage(ht)
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: logoUrl
                caption: "Logo-Url"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                width: parent.width
                caption: "Farbcode (Format: #ffffff)"
                colorEdit: true
                onDisplayTextChanged:
                {
                    colorRectangle.color = displayText
                }
                id: colorInput
                helpText: "Diese Farbe wird angezeigt, wenn ein Besucher seine Daten gesendet hat, so kann - zusammen mit dem Logo - schnell erkannt werden, dass der richtige Besuch angezeigt wird."
                onHelpClicked: ESAA.showMessage(ht)
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: contactReceiveEMail
                caption: "Kontaktdaten senden an (E-Mail-Adresse)"
                width: parent.width
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                helpText: "An diese E-Mail-Adresse werden die verschlüsselten Kontaktdaten des Besuchers gesendet."
                onHelpClicked: ESAA.showMessage(ht)
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: anonymReceiveEMail
                caption: "Anonym senden an (E-Mail-Adresse)"
                width: parent.width
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                helpText: "An diese E-Mail-Adresse wird ausschließlich eine Besuchsinfo gesendet, ohne Kontaktdaten des Besuchers."
                onHelpClicked: ESAA.showMessage(ht)
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: visitCounts
                caption: "Jeden xten Besuch anzeigen"
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
            }
            ESAALineInputWithCaption
            {
                visible: parseInt(visitCounts.displayText) > 0
                color: createqrcodepage.textColor
                width: parent.width
                caption: "Farbcode für xten Besuch<br>(Format: #ffffff)"
                colorEdit: true
                id: colorInputVisitCount
            }
            ESAAText
            {
                width: parent.width
                id: textId
                color: createqrcodepage.textColor
                text: "Welche Daten sollen erfasst werden?"
                wrapMode: Text.WordWrap
            }

            ESAASwitch
            {
                id: adressSwitch
                width: parent.width
                text: qsTr("Adressdaten")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: emailSwitch
                width: parent.width
                text: qsTr("E-Mail-Adresse")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: mobileSwitch
                width: parent.width
                text: qsTr("Handynummer")
                fontColor: createqrcodepage.textColor
            }
            ESAAText
            {
                width: parent.width
                color: createqrcodepage.textColor
                text: "Folgende Informationen müssen bei jedem Besuch neu angegeben werden:"
                wrapMode: Text.WordWrap
            }
            ESAASwitch
            {
                id: tableNumber
                width: parent.width
                text: qsTr("Die Tischnummer")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: whoIsVisited
                width: parent.width
                text: qsTr("Wer besucht wird")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: station
                width: parent.width
                text: qsTr("Die Station")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: room
                width: parent.width
                text: qsTr("Die Raumnummer")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: block
                width: parent.width
                text: qsTr("Die Blocknummer")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: seatNumber
                width: parent.width
                text: qsTr("Die Sitznummer")
                fontColor: createqrcodepage.textColor
            }
            ESAAText
            {
                width: parent.width
                color: createqrcodepage.textColor
                text: "Folgende Fragen müssen bei jedem Besuch mit \"Ja\" beantwortet werden:"
                wrapMode: Text.WordWrap
            }
            Repeater
            {
                id: yesQuestionRepeater
                model: 1
                Row
                {
                    width: parent.width
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
            CircleButton
            {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "weitere<br>Frage"
                onClicked: yesQuestionRepeater.model = yesQuestionRepeater.count + 1
            }
            ESAAText
            {
                width: parent.width
                color: createqrcodepage.textColor
                text: "Informationen für den Kunden/Besucher:"
                wrapMode: Text.WordWrap
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: websiteURL
                caption: "Url zur Webseite"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: foodMenue
                caption: "Url zur Speisekarte (Webseite oder PDF)"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: drinksMenue
                caption: "Url zur Getränkekarte (Webseite oder PDF)"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: lunchMenue
                caption: "Url zur Mittagskarte (Webseite oder PDF)"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: individualURL1
                caption: "Url zur individuellen Nutzung (Webseite oder PDF)"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: individualURL1Caption
                caption: "Buttontext der Individuellen Url"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }

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
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        text: "QR-Code<br>erzeugen"
        onClicked: {
//            if (qrCodeNumber.displayText == "")
//            {
//                qrCodeNumber.forceActiveFocus()
//                ESAA.showMessage("Bitte gib einen Betreiber Code ein.<br><br>9999 ist der standard Code.")
//                return
//            }
            if (!ESAA.keyNumberOK(parseInt(qrCodeNumber.displayText)))
            {
                qrCodeNumber.forceActiveFocus()
                ESAA.showMessage("Bitte gib einen <b>gültigen</b> Betreiber Code ein.<br><br>9999 ist der standard Code.")
                return
            }

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
            if (individualURL1.displayText != "" && individualURL1Caption.displayText == "")
            {
                individualURL1Caption.forceActiveFocus()
                ESAA.showMessage("Bitte gib noch einen Buttontext für die individuelle URL ein, damit der Kunde/Besucher weiß was mit dem Button geöffnet werden kann.")
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
