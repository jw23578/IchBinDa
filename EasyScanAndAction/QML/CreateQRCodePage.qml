import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15
import "Comp"
import "qrc:/foundation"
import "qrc:/javascript/IDPRequestFunctions.js" as IDPRequest

ESAAPage
{
    caption: "QR-Code erstellen"
    captionImageSource: "qrc:/images/mobileImage4.svg"
    headerImageSizeFactor: 1.3
    id: createqrcodepage
    signal close
    signal showCode
    onBackPressed:
    {
        console.log("create qr code")
        close()
    }
    property string qrCodeFileName: ""
    property string theLogoUrl: ""
    property alias theFacilityName: facilityName.displayText
    property alias theContactReceiveEMail: contactReceiveEMail.displayText
    property variant ticketNamesVector: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    property variant ticketPriceVector: []
    property variant yesQuestionVector: []
    property var currentTicketName: null
    function generate()
    {
        ESAA.clearTicketData();
        for (var i = 0; i < ticketNamesVector.count; ++i)
        {
            if (ticketNamesVector[i] != "")
            {
                ESAA.addTicketData(ticketNamesVector[i], ticketPriceVector[i] * 100)
            }
        }

        ESAA.clearYesQuestions()
        for (var i = 0; i < yesQuestionRepeater.count; ++i)
        {
            if (yesQuestionVector[i] != "")
            {
                ESAA.addYesQuestions(yesQuestionVector[i])
            }
        }
        theLogoUrl = logoUrl.displayText
        qrCodeFileName = ""
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
                                             lunchMenue.displayText,
                                             paypalclientid.displayText);
    }
    component HighlightBar : Rectangle {
            color: JW78APP.mainColor
            radius: height / 2
            property int space: IDPGlobals.spacing / 2
            x: positionView.currentItem.x + positionView.currentItem.width / 2 - positionView.currentItem.contentWidth / 2 - space
            y: positionView.currentItem.y + positionView.currentItem.height / 2 - positionView.currentItem.contentHeight / 2 - space
            width: positionView.currentItem.contentWidth + 2 * space
            height: positionView.currentItem.contentHeight + 2 * space
            Behavior on width { SpringAnimation {
                    duration: IDPGlobals.fastAnimationDuration
                    spring: 2; damping: 0.1 } }
            Behavior on x { SpringAnimation {
                    duration: IDPGlobals.fastAnimationDuration
                    spring: 3; damping: 0.2 } }
        }
    ListView
    {
        ListModel {
            id: itemModel
            ListElement
            {
                caption: "Firmendaten"
            }
            ListElement
            {
                caption: "Optionen"
            }
            ListElement
            {
                caption: "Besucherinfos"
            }
            ListElement
            {
                caption: "Tickets"
            }
        }
        highlight: HighlightBar {}
        highlightFollowsCurrentItem: false
        model: itemModel
        delegate: Item {
            width: textItem.width + IDPGlobals.spacing * 2
            height: textItem.height + IDPGlobals.spacing * 3
            property alias contentHeight: textItem.contentHeight
            property alias contentWidth: textItem.contentWidth
            IDPText {
                fontSizeFactor: 0.8
                font.bold: true
                anchors.centerIn: parent
                width: contentWidth
                height: contentHeight
                id: textItem
                text: caption
                color: positionView.currentIndex == index ? "white" : IDPGlobals.textFontColorInactive
                Behavior on color {
                    ColorAnimation {
                        duration: IDPGlobals.fastAnimationDuration
                    }
                }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    console.log("click")
                    positionView.currentIndex = index
                }
            }
        }
        onCurrentIndexChanged: theSwipeView.currentIndex = currentIndex

        orientation: ListView.Horizontal
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        implicitHeight: contentItem.childrenRect.height
        id: positionView
    }
    SwipeView
    {
        id: theSwipeView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: positionView.bottom
        anchors.bottom: showCodeButton.top
        anchors.bottomMargin: JW78APP.spacing
        onCurrentIndexChanged: positionView.currentIndex = currentIndex
        Item
        {            
            Column
            {
                spacing: JW78APP.spacing / 2
                id: theColumn1
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                IDPLineEditWithCaption
                {
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
                IDPLineEditWithCaption
                {
                    id: facilityName
                    containedCaption: true
                    width: parent.width
                    caption: qsTr("Name des Geschäfts")
                    helpText: "Dieser Name wird dem Besucher angezeigt, wenn er den QR-Code eingescannt hat."
                    onHelpClicked: ESAA.showMessage(ht)
                }
                IDPLineEditWithCaption
                {
                    containedCaption: true
                    id: logoUrl
                    caption: "Logo-Url"
                    width: parent.width
                    inputMethodHints: Qt.ImhUrlCharactersOnly
                }
                ESAALineInputWithCaption
                {
                    width: parent.width
                    caption: "Farbcode (Format: #ffffff)"
                    colorEdit: true
                    id: colorInput
                    helpText: "Diese Farbe wird angezeigt, wenn ein Besucher seine Daten gesendet hat, so kann - zusammen mit dem Logo - schnell erkannt werden, dass der richtige Besuch angezeigt wird."
                    onHelpClicked: ESAA.showMessage(ht)
                }
                IDPLineEditWithCaption
                {
                    containedCaption: true
                    id: contactReceiveEMail
                    caption: "Kontaktdaten senden an (E-Mail-Adresse)"
                    width: parent.width
                    inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                    helpText: "An diese E-Mail-Adresse werden die verschlüsselten Kontaktdaten des Besuchers gesendet."
                    onHelpClicked: ESAA.showMessage(ht)
                }
                IDPLineEditWithCaption
                {
                    containedCaption: true
                    id: anonymReceiveEMail
                    caption: "Anonym senden an (E-Mail-Adresse)"
                    width: parent.width
                    inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                    helpText: "An diese E-Mail-Adresse wird ausschließlich eine Besuchsinfo gesendet, ohne Kontaktdaten des Besuchers."
                    onHelpClicked: ESAA.showMessage(ht)
                }
                IDPLineEditWithCaption
                {
                    containedCaption: true
                    id: visitCounts
                    caption: "Jeden xten Besuch anzeigen"
                    width: parent.width
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                ESAALineInputWithCaption
                {
                    visible: parseInt(visitCounts.displayText) > 0
                    width: parent.width
                    caption: "Farbcode für xten Besuch<br>(Format: #ffffff)"
                    colorEdit: true
                    id: colorInputVisitCount
                }
            }
        }
        Item
        {
            ESAAFlickable
            {
                id: theFlick2
                anchors.fill: parent
                contentHeight: theColumn2.height * 1.3
                Column
                {
                    parent: theFlick2.contentItem
                    spacing: JW78APP.spacing / 2
                    id: theColumn2
                    width: parent.width - 2 * ESAA.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int switchX: width / 6
                    property int switchWidth: width - switchX
                    IDPText
                    {
                        width: parent.width
                        id: textId
                        text: qsTr("Welche Daten sollen neben den Adressdaten erfasst werden?")
                        wrapMode: Text.WordWrap
                    }
                    ESAASwitch
                    {
                        id: emailSwitch
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("E-Mail-Adresse")
                    }
                    ESAASwitch
                    {
                        id: mobileSwitch
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("Handynummer")
                    }
                    IDPText
                    {
                        width: parent.width
                        text: "Folgende Informationen müssen bei jedem Besuch neu angegeben werden:"
                        wrapMode: Text.WordWrap
                    }
                    ESAASwitch
                    {
                        id: tableNumber
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("Die Tischnummer")
                    }
                    ESAASwitch
                    {
                        id: whoIsVisited
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("Wer besucht wird")
                    }
                    ESAASwitch
                    {
                        id: station
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("Die Station")
                    }
                    ESAASwitch
                    {
                        id: room
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("Die Raumnummer")
                    }
                    ESAASwitch
                    {
                        id: block
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("Die Blocknummer")
                    }
                    ESAASwitch
                    {
                        id: seatNumber
                        x: parent.switchX
                        width: parent.switchWidth
                        text: qsTr("Die Sitznummer")
                    }
                }
            }
        }
        Item
        {
            ESAAFlickable
            {
                id: theFlick3
                anchors.fill: parent
                contentHeight: theColumn3.height * 1.3
                Column
                {
                    parent: theFlick3.contentItem
                    spacing: JW78APP.spacing / 2
                    id: theColumn3
                    width: parent.width - 2 * ESAA.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    IDPLineEditWithCaption
                    {
                        containedCaption: true
                        id: websiteURL
                        caption: "Url zur Webseite"
                        width: parent.width
                        inputMethodHints: Qt.ImhUrlCharactersOnly
                    }
                    IDPLineEditWithCaption
                    {
                        containedCaption: true
                        id: foodMenue
                        caption: "Url zur Speisekarte (Webseite oder PDF)"
                        width: parent.width
                        inputMethodHints: Qt.ImhUrlCharactersOnly
                    }
                    IDPLineEditWithCaption
                    {
                        containedCaption: true
                        id: drinksMenue
                        caption: "Url zur Getränkekarte (Webseite oder PDF)"
                        width: parent.width
                        inputMethodHints: Qt.ImhUrlCharactersOnly
                    }
                    IDPLineEditWithCaption
                    {
                        containedCaption: true
                        id: lunchMenue
                        caption: "Url zur Mittagskarte (Webseite oder PDF)"
                        width: parent.width
                        inputMethodHints: Qt.ImhUrlCharactersOnly
                    }
                    IDPLineEditWithCaption
                    {
                        containedCaption: true
                        id: individualURL1
                        caption: "Url zur individuellen Nutzung (Webseite oder PDF)"
                        width: parent.width
                        inputMethodHints: Qt.ImhUrlCharactersOnly
                    }
                    IDPLineEditWithCaption
                    {
                        containedCaption: true
                        id: individualURL1Caption
                        caption: "Buttontext der Individuellen Url"
                        width: parent.width
                    }
                    IDPText
                    {
                        width: parent.width
                        text: "Folgende Fragen müssen bei jedem Besuch mit \"Ja\" beantwortet werden:"
                        wrapMode: Text.WordWrap
                    }
                    Repeater
                    {
                        id: yesQuestionRepeater
                        model: 1
                        Row
                        {
                            property alias questionText: yesQuestion.text
                            width: parent.width
                            IDPLineEditWithCaption
                            {
                                containedCaption: true
                                width: parent.width
                                caption: (index + 1) + ". Frage"
                                id: yesQuestion
                                Component.onCompleted: text = yesQuestionVector.length > index ? yesQuestionVector[index] : ""
                                onDisplayTextChanged: yesQuestionVector[index] = displayText
                                eraseButtonActive: index > 0
                                onEraseButtonClicked: {
                                    if (yesQuestionRepeater.count <= 1)
                                    {
                                        yesQuestionRepeater.itemAt(0).questionText = ""
                                        yesQuestionVector[0] = ""
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
                    IDPTextCircle
                    {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "+"
                        width: contentWidth * 1.5
                        fontSizeFactor: 2
                        onClicked: yesQuestionRepeater.model = yesQuestionRepeater.count + 1
                    }
                }
            }
        }
        Item
        {
            Column
            {
                spacing: JW78APP.spacing / 2
                id: theColumn4
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                IDPLineEditWithCaption
                {
                    containedCaption: true
                    id: paypalclientid
                    caption: "PayPal-ClientId"
                    width: parent.width
                }
                Repeater
                {
                    id: ticketRepeater
                    model: 1
                    Column
                    {
                        width: parent.width
                        spacing: ESAA.spacing / 2
                        property alias ticketNameText: ticketName.text
                        Row
                        {
                            width: parent.width
                            IDPLineEditWithCaption
                            {
                                width: parent.width
                                eraseButtonActive: index > 0
                                containedCaption: true
                                caption: "Bezeichnung " + (index + 1) + ". Ticket"
                                id: ticketName
                                Component.onCompleted: {
                                    text = (ticketNamesVector.length > index) ? ticketNamesVector[index] : ""
                                    extraText = (ticketNamesVector[index] == "" || displayText == "") ? "Vorschläge" : ""
                                }
                                onDisplayTextChanged:
                                {
                                    ticketNamesVector[index] = displayText
                                    extraText = (ticketNamesVector[index] == "" || displayText == "") ? "Vorschläge" : ""
                                }
//                                extraText: (ticketNamesVector[index] == "" || displayText == "") ? "Vorschläge" : ""
                                onExtraButtonClicked: {
                                    currentTicketName = ticketName
                                    ticketSelect.open()
                                }
                                onEraseButtonClicked:
                                {
                                    if (ticketRepeater.count <= 1)
                                    {
                                        ticketRepeater.itemAt(0).ticketNameText = ""
                                        ticketRepeater[0] = ""
                                        return
                                    }

                                    for (var i = index; i < ticketRepeater.count; ++i)
                                    {
                                        ticketName[i] = ticketName[i + 1]
                                        ticketPriceVector[i] = ticketPriceVector[i + 1]
                                    }
                                    ticketName[ticketRepeater.count - 1] = ""
                                    ticketPriceVector[ticketRepeater.count - 1] = 0
                                    ticketRepeater.model = ticketRepeater.count - 1
                                }
                            }
                        }
                        IDPLineEditWithCaption
                        {
                            containedCaption: true
                            validator:  RegularExpressionValidator { regularExpression: /([0-9]{1,4}(,[0-9]{2})?)/ }
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            suffix: "EUR"
                            width: parent.width
                            caption: "Preis für " + (ticketName.displayText.length ? ticketName.displayText : ((index + 1) + ". Ticket"))
                            id: ticketPrice
                            Component.onCompleted: text = ticketPriceVector.length > index ? ticketPriceVector[index] : ""
                            onDisplayTextChanged: ticketPriceVector[index] = displayText
                        }
                    }


                }
                IDPTextCircle
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "+"
                    width: contentWidth * 1.5
                    fontSizeFactor: 2
                    onClicked: ticketRepeater.model = ticketRepeater.count + 1
                }
            }
        }
    }

    function createQRCode()
    {
        generate()
        showCode()
    }

    IDPButtonCircle
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
            createQRCode()
        }
    }
    IDPSelectForm
    {
        anchors.fill: parent
        id: ticketSelect
        model: ticketTypes
        delegate: circleDelegate
        caption: "Ticketart"
        callback: function(number, caption, index)
        {
            currentTicketName.text = caption.replace("<br>", " ")
        }

        ListModel
        {
            id: ticketTypes
            ListElement
            {
                caption: qsTr("Erwachsene")
                number: 0
                subCaption: ""
            }
            ListElement
            {
                caption: qsTr("Kinder")
                number: 1
                subCaption: ""
            }
            ListElement
            {
                caption: qsTr("Kinder und<br>Jugendliche")
                number: 2
                subCaption: ""
            }
            ListElement
            {
                caption: qsTr("Familien")
                number: 3
                subCaption: ""
            }
            ListElement
            {
                caption: qsTr("VIP")
                number: 4
                subCaption: ""
            }
            ListElement
            {
                caption: qsTr("Gruppen")
                number: 5
                subCaption: ""
            }
            ListElement
            {
                caption: qsTr("Dauerkarte")
                number: 6
                subCaption: ""
            }
        }
    }
}
