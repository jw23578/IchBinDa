import QtQuick 2.15
import QtQuick.Controls 2.15

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
    property color textColor: ESAA.buttonColor // ESAA.fontColor2
    caption: ESAA.facilityName
    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: sendButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.3
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
            ESAAText
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: ESAA.facilityName
                color: textColor
                font.pixelSize: ESAA.fontTextPixelsize * 1.5
                font.bold: true
                visible: !meineDaten
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Tischnummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: tableNumber
                visible: !meineDaten && ESAA.tableNumberWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Wer wird besucht")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: whoIsVisited
                visible: !meineDaten && ESAA.whoIsVisitedWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Station")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: station
                visible: !meineDaten && ESAA.stationWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Raumnummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: room
                visible: !meineDaten && ESAA.roomWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Block")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: block
                visible: !meineDaten && ESAA.blockWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Sitzplatz")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: seatNumber
                visible: !meineDaten && ESAA.seatNumberWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Vorname")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                focus: true
                id: fstname
                text: ESAA.fstname
                color: textColor
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Nachname")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: surname
                text: ESAA.surname
                color: textColor
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Straße")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: street
                text: ESAA.street
                visible: meineDaten || ESAA.adressWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Hausnummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: housenumber
                text: ESAA.housenumber
                visible: meineDaten || ESAA.adressWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Postleitzahl")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: zip
                text: ESAA.zip
                visible: meineDaten || ESAA.adressWanted
                inputMethodHints: Qt.ImhDigitsOnly
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Ort")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: location
                text: ESAA.location
                visible: meineDaten || ESAA.adressWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Handynummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: mobile
                text: ESAA.mobile
                visible: meineDaten || ESAA.mobileWanted
                inputMethodHints: Qt.ImhDialableCharactersOnly
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("E-Mail-Adresse")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: emailAdress
                text: ESAA.emailAdress
                visible: meineDaten || ESAA.emailWanted
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
                color: textColor
            }
            Repeater
            {
                model: ESAA.yesQuestionCount
                Column
                {
                    width: parent.width - 2 * ESAA.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    ESAAText
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
    CircleButton
    {
        id: sendButton
        anchors.margins: ESAA.spacing
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing * 2.5
        anchors.horizontalCenter: parent.horizontalCenter
        text: meineDaten ? "speichern" : "Daten<br>senden"
        belowCaption: meineDaten ? "" : "an: " + ESAA.facilityName
        onClicked:
        {
            ESAA.clearData2Send()
            if (meineDaten)
            {
                ESAA.fstname = fstname.text
                ESAA.surname = surname.text
                ESAA.street = street.text
                ESAA.housenumber = housenumber.text
                ESAA.zip = zip.text
                ESAA.location = location.text
                ESAA.emailAdress = emailAdress.text
                ESAA.mobile = mobile.text
                ESAA.saveData();
                ESAA.showMessage("Deine Kontaktdaten wurden gespeichert")
                waitAndClose.start()
                return
            }
            ESAA.lastVisitFstname = ""
            ESAA.lastVisitSurname = ""
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

            ESAA.lastVisitLocationContactMailAdress = ESAA.locationContactMailAdress
            ESAA.lastVisitColor = ESAA.color

            ESAA.addData2Send(qsTr("FacilityName"), ESAA.facilityName)
            if (fstname.visible)
            {
                if (fstname.text == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deinen Vornamen ein"))
                    theFlick.ensureVisible(fstname)
                    fstname.forceActiveFocus()
                    return;
                }
                ESAA.fstname = fstname.text
                ESAA.lastVisitFstname = fstname.text
                ESAA.addData2Send(qsTr("Vorname"), fstname.text)
            }
            if (surname.visible)
            {
                if (surname.text == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deinen Nachnamen ein"))
                    theFlick.ensureVisible(surname)
                    surname.forceActiveFocus()
                    return;
                }
                ESAA.surname = surname.text
                ESAA.lastVisitSurname = surname.text
                ESAA.addData2Send(qsTr("Nachname"), surname.text)
            }
            if (street.visible)
            {
                if (street.text == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deine Straße ein"))
                    theFlick.ensureVisible(street)
                    street.forceActiveFocus()
                    return;
                }
                ESAA.street = street.text
                ESAA.lastVisitStreet = street.text
                ESAA.addData2Send(qsTr("Straße"), street.text)
            }
            if (housenumber.visible)
            {
                if (housenumber.text == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deine Hausnummer ein"))
                    theFlick.ensureVisible(housenumber)
                    housenumber.forceActiveFocus()
                    return;
                }
                ESAA.housenumber = housenumber.text
                ESAA.lastVisitHousenumber = housenumber.text
                ESAA.addData2Send(qsTr("Hausnummer"), housenumber.text)
            }
            if (zip.visible)
            {
                if (zip.text == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deine Postleitzahl ein"))
                    theFlick.ensureVisible(zip)
                    zip.forceActiveFocus()
                    return;
                }
                ESAA.addData2Send(qsTr("Postleitzahl"), zip.text)
                ESAA.zip = zip.text
                ESAA.lastVisitZip = zip.text
            }
            if (location.visible)
            {
                if (location.text == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deinen Ort ein"))
                    theFlick.ensureVisible(location)
                    location.forceActiveFocus()
                    return;
                }
                ESAA.addData2Send(qsTr("Ort"), location.text)
                ESAA.location = location.text
                ESAA.lastVisitLocation = location.text
            }
            if (emailAdress.visible)
            {
                if (emailAdress.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deine E-Mail-Adresse ein"))
                    theFlick.ensureVisible(emailAdress)
                    emailAdress.forceActiveFocus()
                    return;
                }
                ESAA.emailAdress = emailAdress.displayText
                ESAA.lastVisitEmailAdress = emailAdress.displayText
                ESAA.addData2Send(qsTr("E-Mail-Adresse"), emailAdress.displayText)
            }
            if (mobile.visible)
            {
                if (mobile.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch deine Handynummer ein"))
                    theFlick.ensureVisible(mobile)
                    mobile.forceActiveFocus()
                    return;
                }
                ESAA.addData2Send(qsTr("Handynummer"), mobile.displayText)
                ESAA.mobile = mobile.displayText
                ESAA.lastVisitMobile = mobile.displayText
            }
            if (tableNumber.visible)
            {
                if (tableNumber.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch die Tischnummer ein"))
                    tableNumber.forceActiveFocus()
                    theFlick.ensureVisible(tableNumber)
                    return;
                }
                ESAA.addData2Send(qsTr("Tischnummer"), tableNumber.displayText)
                LastVisit.tableNumber = tableNumber.displayText
            }
            if (whoIsVisited.visible)
            {
                if (whoIsVisited.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch ein wen du besuchst"))
                    whoIsVisited.forceActiveFocus()
                    theFlick.ensureVisible(whoIsVisited)
                    return;
                }
                ESAA.addData2Send(qsTr("Besucht wurde"), whoIsVisited.displayText)
                LastVisit.whoIsVisited = whoIsVisited.displayText
            }
            if (station.visible)
            {
                if (station.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch die Station ein"))
                    station.forceActiveFocus()
                    theFlick.ensureVisible(station)
                    return;
                }
                ESAA.addData2Send(qsTr("Station"), station.displayText)
                LastVisit.station = station.displayText
            }
            if (room.visible)
            {
                if (room.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch die Raumnummer ein"))
                    room.forceActiveFocus()
                    theFlick.ensureVisible(room)
                    return;
                }
                ESAA.addData2Send(qsTr("Raumnummer"), room.displayText)
                LastVisit.room = room.displayText
            }
            if (block.visible)
            {
                if (block.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch die Blocknummer ein"))
                    block.forceActiveFocus()
                    theFlick.ensureVisible(block)
                    return;
                }
                ESAA.addData2Send(qsTr("Blocknummer"), block.displayText)
                LastVisit.block = block.displayText
            }
            if (seatNumber.visible)
            {
                if (seatNumber.displayText == "")
                {
                    ESAA.showMessage(qsTr("Bitte gib noch die Sitznummer ein"))
                    seatNumber.forceActiveFocus()
                    theFlick.ensureVisible(seatNumber)
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
    BackButton
    {
        visible: !ESAA.firstStart
        onClicked: {
            ESAA.ignoreQRCode()
            abort()
        }
    }
}
