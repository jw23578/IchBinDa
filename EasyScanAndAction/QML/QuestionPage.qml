import QtQuick 2.15
import QtWebView 1.15
import QtQuick.Controls 2.15
import "Comp"
import "qrc:/foundation"
import "qrc:/javascript/IDPRequestFunctions.js" as IDPRequest

ESAAPage
{
    onShowing:
    {
        theFlick.contentY = 0
        tableNumber.text = ""
        whoIsVisited.text = ""
        station.text = ""
        room.text = ""
        block.text = ""
        seatNumber.text = ""
    }
    signal saveMeineDaten;
    signal close
    signal abort
    onBackPressed:
    {
        abort()
    }
    property var elemToFocus: null
    function setElemToFocus(elem)
    {
        theFlick.ensureVisible(elem)
        elemToFocus = elem
    }

    function setFocusNow()
    {
        elemToFocus.forceActiveFocus()
    }
    function focusMessage(theMessage, elem)
    {
        setElemToFocus(elem)
        ESAA.showMessageWithCallback(theMessage, setFocusNow)
    }

    PauseAnimation {
        duration: 300
        id: waitAndAbort
        onStopped: abort()
    }
    PauseAnimation {
        duration: 300
        id: waitAndClose
        onStopped: close()
    }

    property variant yesAnswers: []
    property bool meineDaten: ESAA.facilityName == "MeineDaten"
    property color textColor: ESAA.buttonColor
    caption: ESAA.facilityName
    captionImageSource: "qrc:/images/headerImage2.svg"
    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: sendButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.4
        Column
        {
            parent: theFlick.contentItem
            id: theColumn
            y: ESAA.spacing
            width: parent.width
            spacing: ESAA.spacing / 2
            //            topPadding: spacing
            Image
            {
                visible: !meineDaten
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 3 / 10
                height: width
                source: ESAA.logoUrl
                fillMode: Image.PreserveAspectFit
                cache: false
                onSourceChanged:
                {
                    console.log("Logosource: " + source)
                }
            }
            IDPText
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: ESAA.facilityName
                color: textColor
                font.pixelSize: ESAA.fontTextPixelsize * 1.5
                font.bold: true
                visible: !meineDaten
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Tischnummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: tableNumber
                visible: !meineDaten && ESAA.tableNumberWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Wer wird besucht")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: whoIsVisited
                visible: !meineDaten && ESAA.whoIsVisitedWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Station")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: station
                visible: !meineDaten && ESAA.stationWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Raumnummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: room
                visible: !meineDaten && ESAA.roomWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Block")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: block
                visible: !meineDaten && ESAA.blockWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Sitzplatz")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: seatNumber
                visible: !meineDaten && ESAA.seatNumberWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Vorname")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                focus: true
                id: fstname
                text: MainPerson.fstname
                textColor: textColor
            }

            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Nachname")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: surname
                text: MainPerson.surname
                textColor: textColor
            }

            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Straße")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: street
                text: MainPerson.street
                visible: meineDaten || ESAA.adressWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Hausnummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: housenumber
                text: MainPerson.housenumber
                visible: meineDaten || ESAA.adressWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Postleitzahl")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: zip
                text: MainPerson.zip
                visible: meineDaten || ESAA.adressWanted
                inputMethodHints: Qt.ImhDigitsOnly
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Ort")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: location
                text: MainPerson.location
                visible: meineDaten || ESAA.adressWanted
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("Handynummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: mobile
                text: ESAA.mobile
                visible: meineDaten || ESAA.mobileWanted
                inputMethodHints: Qt.ImhDialableCharactersOnly
                textColor: textColor
            }
            IDPLineEditWithCaption
            {
                containedCaption: true
                caption: qsTr("E-Mail-Adresse")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: emailAdress
                text: MainPerson.emailAdress
                visible: meineDaten || ESAA.emailWanted
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                textColor: textColor
            }
            Repeater
            {
                model: ESAA.yesQuestionCount
                Column
                {
                    width: parent.width - 2 * ESAA.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    IDPText
                    {
                        width: parent.width
                        id: textId
                        color: createqrcodepage.textColor
                        text: ESAA.getYesQuestion(index)
                        wrapMode: Text.WordWrap
                    }
                    ESAASwitch
                    {
                        id: mobileSwitch
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Ja")
                        fontColor: createqrcodepage.textColor
                        onCheckedChanged: yesAnswers[index] = checked
                    }

                }
            }

            Item
            {
                width: parent.width
                height: 1
            }
        }
    }
    CentralActionButton
    {
        id: sendButton
        text: meineDaten ? "Speichern" : "Daten<br>senden"
        belowCaption: meineDaten ? "" : "an: " + ESAA.facilityName
        onClicked:
        {
            ESAA.clearData2Send()
            if (meineDaten)
            {
                MainPerson.fstname = fstname.displayText
                MainPerson.surname = surname.displayText
                MainPerson.street = street.displayText
                MainPerson.housenumber = housenumber.displayText
                MainPerson.zip = zip.displayText
                MainPerson.location = location.displayText
                MainPerson.emailAdress = emailAdress.displayText
                ESAA.mobile = mobile.displayText
                ESAA.saveData();
                ESAA.showMessage("Deine Kontaktdaten wurden gespeichert")
                waitAndClose.start()
                return
            }
            LastVisit.fstname = ""
            LastVisit.surname = ""
            ESAA.lastVisitStreet = ""
            ESAA.lastVisitHousenumber = ""
            ESAA.lastVisitZip = ""
            ESAA.lastVisitLocation = ""
            ESAA.lastVisitEmailAdress = ""
            ESAA.lastVisitMobile = ""

            LastVisit.facilityName = ESAA.facilityName
            LastVisit.logoUrl = CurrentQRCodeData.logoUrl
            LastVisit.websiteURL = CurrentQRCodeData.websiteURL
            LastVisit.foodMenueURL = CurrentQRCodeData.foodMenueURL
            LastVisit.drinksMenueURL = CurrentQRCodeData.drinksMenueURL
            LastVisit.individualURL1 = CurrentQRCodeData.individualURL1
            LastVisit.individualURL1Caption = CurrentQRCodeData.individualURL1Caption
            LastVisit.lunchMenueURL = CurrentQRCodeData.lunchMenueURL
            LastVisit.color = ESAA.color
            LastVisit.locationContactMailAdress = CurrentQRCodeData.locationContactMailAdress
            LastVisit.locationAnonymContactMailAdress = CurrentQRCodeData.locationAnonymContactMailAdress

            ESAA.addData2Send(qsTr("FacilityName"), ESAA.facilityName)
            if (fstname.visible)
            {
                if (fstname.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deinen Vornamen ein"), fstname)
                    return;
                }
                MainPerson.fstname = fstname.displayText
                LastVisit.fstname = fstname.displayText
                ESAA.addData2Send(qsTr("Vorname"), fstname.displayText)
            }
            if (surname.visible)
            {
                if (surname.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deinen Nachnamen ein"), surname)
                    return;
                }
                MainPerson.surname = surname.displayText
                LastVisit.surname = surname.displayText
                ESAA.addData2Send(qsTr("Nachname"), surname.displayText)
            }
            if (street.visible)
            {
                if (street.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deine Straße ein"), street)
                    return;
                }
                MainPerson.street = street.displayText
                ESAA.lastVisitStreet = street.displayText
                ESAA.addData2Send(qsTr("Straße"), street.displayText)
            }
            if (housenumber.visible)
            {
                if (housenumber.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deine Hausnummer ein"), housenumber)
                    return;
                }
                MainPerson.housenumber = housenumber.displayText
                ESAA.lastVisitHousenumber = housenumber.displayText
                ESAA.addData2Send(qsTr("Hausnummer"), housenumber.displayText)
            }
            if (zip.visible)
            {
                if (zip.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deine Postleitzahl ein"), zip)
                    return;
                }
                ESAA.addData2Send(qsTr("Postleitzahl"), zip.displayText)
                MainPerson.zip = zip.displayText
                ESAA.lastVisitZip = zip.displayText
            }
            if (location.visible)
            {
                if (location.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deinen Ort ein"), location)
                    return;
                }
                ESAA.addData2Send(qsTr("Ort"), location.displayText)
                MainPerson.location = location.displayText
                ESAA.lastVisitLocation = location.displayText
            }
            if (mobile.visible)
            {
                if (mobile.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deine Handynummer ein"), mobile)
                    return;
                }
                ESAA.addData2Send(qsTr("Handynummer"), mobile.displayText)
                ESAA.mobile = mobile.displayText
                ESAA.lastVisitMobile = mobile.displayText
            }
            if (emailAdress.visible)
            {
                if (emailAdress.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch deine E-Mail-Adresse ein"), emailAdress)
                    return;
                }
                MainPerson.emailAdress = emailAdress.displayText
                ESAA.lastVisitEmailAdress = emailAdress.displayText
                ESAA.addData2Send(qsTr("E-Mail-Adresse"), emailAdress.displayText)
            }
            if (tableNumber.visible)
            {
                if (tableNumber.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch die Tischnummer ein"), tableNumber)
                    return;
                }
                ESAA.addData2Send(qsTr("Tischnummer"), tableNumber.displayText)
                LastVisit.tableNumber = tableNumber.displayText
            }
            if (whoIsVisited.visible)
            {
                if (whoIsVisited.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch ein wen du besuchst"), whoIsVisited)
                    return;
                }
                ESAA.addData2Send(qsTr("Besucht wurde"), whoIsVisited.displayText)
                LastVisit.whoIsVisited = whoIsVisited.displayText
            }
            if (station.visible)
            {
                if (station.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch die Station ein"), station)
                    return;
                }
                ESAA.addData2Send(qsTr("Station"), station.displayText)
                LastVisit.station = station.displayText
            }
            if (room.visible)
            {
                if (room.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch die Raumnummer ein"), room)
                    return;
                }
                ESAA.addData2Send(qsTr("Raumnummer"), room.displayText)
                LastVisit.room = room.displayText
            }
            if (block.visible)
            {
                if (block.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch die Blocknummer ein"), block)
                    return;
                }
                ESAA.addData2Send(qsTr("Blocknummer"), block.displayText)
                LastVisit.block = block.displayText
            }
            if (seatNumber.visible)
            {
                if (seatNumber.displayText == "")
                {
                    focusMessage(qsTr("Bitte gib noch die Sitznummer ein"), seatNumber)
                    return;
                }
                ESAA.addData2Send(qsTr("Sitznummer"), seatNumber.displayText)
                LastVisit.seatNumber = seatNumber.displayText
            }
            for (var i = 0; i < ESAA.yesQuestionCount; ++i)
            {
                if (!yesAnswers[i])
                {
                    ESAA.showMessage("Diese Frage musst du noch mit \"Ja\" beantworten:<br><br>" + ESAA.getYesQuestion(i))
                    return;
                }
                ESAA.addSubData2Send("yesQuestion", "yq" + i, ESAA.getYesQuestion(i))
            }
            ESAA.showWaitMessage("Bitte einen Moment Geduld")
            ESAA.sendContactData();
            close()
        }
    }
    IDPFadeInOutRectangle
    {
        anchors.fill: parent
        id: ticketForm
        opacity: JW78APP.ticketDataCount > 0 ? 1 : 0
        property variant ticketCount: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ESAAFlickable
        {
            id: ticketFlick
            anchors.margins: ESAA.spacing
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            contentHeight: theTicketColumn.height * 1.4
            Column
            {
                parent: ticketFlick.contentItem
                id: theTicketColumn
                y: ESAA.spacing
                width: parent.width
                spacing: ESAA.spacing
                IDPText
                {
                    width: parent.width - 2 * ESAA.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Tickets"
                    color: textColor
                    font.pixelSize: ESAA.fontTextPixelsize * 1.5
                    font.bold: true
                }
                Repeater
                {
                    model: JW78APP.ticketDataCount
                    Column
                    {
                        width: parent.width
                        id: oneTicketColumn
                        property int changeCounter: 1
                        spacing: ESAA.spacing / 2
                        IDPText
                        {
                            width: parent.width - 2 * ESAA.spacing
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignRight
                            text: oneTicketColumn.changeCounter > 0 ? ticketForm.ticketCount[index] + " * " + JW78APP.getTicketName(index) + " " + JW78APP.getTicketPriceString(index) : ""
                            color: textColor
                            font.pixelSize: ESAA.fontTextPixelsize * 1.5
                        }
                        Row
                        {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: JW78APP.spacing * 4
                            IDPButtonCircle
                            {
                                width: JW78Utils.screenWidth / 8
                                text: "+"
                                onClicked: {
                                    ticketForm.ticketCount[index] += 1
                                    oneTicketColumn.changeCounter += 1
                                }
                            }
                            IDPButtonCircle
                            {
                                width: JW78Utils.screenWidth / 8
                                text: "-"
                                onClicked: {
                                    if (ticketForm.ticketCount[index] == 0)
                                    {
                                        return;
                                    }

                                    ticketForm.ticketCount[index] -= 1
                                    oneTicketColumn.changeCounter -= 1
                                }
                            }
                        }
                    }
                }
            }
        }
        CentralActionButton
        {
            id: buyButton
            property string actionId: ""
            text: "Jetzt Tickets<br>kaufen"
            anchors.horizontalCenterOffset: noBuyButton.visible ? -noBuyButton.anchors.horizontalCenterOffset  : 0
            function startPayment(data)
            {
                var amount = 0.0
                for (var i = 0; i < JW78APP.ticketDataCount; ++i)
                {
                    amount += ticketForm.ticketCount[i] * JW78APP.getTicketPrice(i)
                }

                buyButton.actionId = data.responseText
                console.log("ActionID: " + actionId);
                var url = "https://www.jw78.de/payment.php?"
                url += "actionId=" + actionId
                url += "&amount=" + amount
                url += "&clientId=" + CurrentQRCodeData.paypalClientId
                console.log("url: " + url)
                Qt.openUrlExternally(url)
                paypalwait.opacity = 1
            }
            function errorOnStartPayment()
            {

            }
            onClicked: {
                IDPRequest.request("https://www.jw78.de/startPayment.php", startPayment, errorOnStartPayment)
            }
        }
        CentralActionButton
        {
            id: noBuyButton
            text: "Ohne Tickets<br>einchecken"
            anchors.horizontalCenterOffset: parent.width / 6
        }
    }


    BackButton
    {
        visible: !ESAA.firstStart
        onClicked: {
            ESAA.ignoreQRCode()
            abort()
        }
    }
    IDPFadeInOutRectangle
    {
        id: paypalwait
        anchors.fill: parent
        Text {
            anchors.centerIn: parent
            text: qsTr("Bitte die Bezahlung abschließen")
        }
        Timer
        {
            id: waitTimer
            running: paypalwait.visible
            interval: 2000
            repeat: true
            function paymentInProgress(data)
            {
                console.log("paymentInProgress" + data.responseText);
                if (data.responseText.indexOf("404 Not Found") >= 0)
                {
                    console.log("paymentFinished");
                    paypalwait.opacity = 0;
                    JW78APP.ticketDataCount = 0
                }
                else
                {
                    console.log("paymentInProgress" + data.responseText);
                }
            }
            function paymentError()
            {
                console.log("paymentError");
            }

            onTriggered:
            {
                var url = "https://www.jw78.de/paymentStateFiles/paymentInProgress" + buyButton.actionId + ".txt"
                console.log(url)
                IDPRequest.request(url, paymentInProgress, paymentError)
            }
        }
    }
}
