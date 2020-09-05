import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.1

ESAAPage
{
    onShowing: theFlick.contentY = 0
    signal saveMeineDaten;
    signal close
    signal abort
    onBackPressed:
    {
        abort()
    }
    property variant yesAnswers: []
    property bool meineDaten: ESAA.facilityName == "MeineDaten"
    property color textColor: ESAA.buttonColor // ESAA.fontColor2
    caption: ESAA.facilityName
    Rectangle
    {
        id: removeMeLater
        anchors.fill: parent
        color: "white"
    }
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
            Row
            {
                visible: !meineDaten
                property int w: parent.width * 6 / 10
                spacing: w / 10
                width: w + spacing
                anchors.horizontalCenter: parent.horizontalCenter
                height: w / 2
                Image
                {
                    width: parent.height
                    height: width
                    source: ESAA.logoUrl
                    fillMode: Image.PreserveAspectFit
                }
                Rectangle
                {
                    width: parent.height
                    height: width
                    color: ESAA.color
                    border.width: ESAA.color == "#ffffff" ? 1 : 0
                    border.color: ESAA.buttonBorderColor
                    radius: ESAA.radius
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
                inputMethodHints: Qt.ImhEmailCharactersOnly
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
        anchors.bottomMargin: height / 2
        anchors.horizontalCenter: parent.horizontalCenter
        text: meineDaten ? "speichern" : "Daten<br>senden"
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
            ESAA.lastVisitLocationContactMailAdress = ESAA.locationContactMailAdress
            ESAA.lastVisitLogoUrl = ESAA.logoUrl
            ESAA.lastVisitColor = ESAA.color

            if (fstname.visible)
            {
                if (fstname.text == "")
                {
                    fstname.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deinen Vornamen ein"))
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
                    surname.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deinen Nachnamen ein"))
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
                    street.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deine Straße ein"))
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
                    housenumber.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deine Hausnummer ein"))
                    return;
                }
                ESAA.housenumber = housenumber.text
                ESAA.lastVisitHousenumber = housenumber.text
                ESAA.addData2Send(qsTr("Hausnummer"), surname.text)
            }
            if (zip.visible)
            {
                if (zip.text == "")
                {
                    zip.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deine Postleitzahl ein"))
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
                    location.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deinen Ort ein"))
                    return;
                }
                ESAA.addData2Send(qsTr("Ort"), location.text)
                ESAA.location = location.text
                ESAA.lastVisitLocation = location.text
            }
            if (emailAdress.visible)
            {
                if (emailAdress.text == "")
                {
                    emailAdress.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deine E-Mail-Adresse ein"))
                    return;
                }
                ESAA.emailAdress = emailAdress.text
                ESAA.lastVisitEmailAdress = emailAdress.text
                ESAA.addData2Send(qsTr("E-Mail-Adresse"), emailAdress.text)
            }
            if (mobile.visible)
            {
                if (mobile.text == "")
                {
                    mobile.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deine Handynummer ein"))
                    return;
                }
                ESAA.addData2Send(qsTr("Handynummer"), mobile.text)
                ESAA.mobile = mobile.text
                ESAA.lastVisitMobile = mobile.text
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

            ESAA.sendContactData();            
            close()
        }
    }
    ESAAText
    {
        text: "an: " + ESAA.locationContactMailAdress
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing / 2
        color: ESAA.buttonColor
        font.pixelSize: ESAA.fontTextPixelsize
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !meineDaten
    }
    BackButton
    {
        onClicked: {
            ESAA.ignoreQRCode()
            abort()
        }
    }
}
