import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.1

ESAAPage
{
    onShowing: theFlick.contentY = 0
    signal close
    signal abort
    property bool meineDaten: ESAA.locationName == "MeineDaten"
    property color textColor: ESAA.fontColor2
    Flickable
    {
        id: theFlick
        anchors.bottom: sendButton.top
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
            id: theColumn
            y: ESAA.spacing
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - parent.width / 10
            spacing: ESAA.spacing / 2
            topPadding: spacing
            Item
            {
                width: parent.width
                height: 1
            }
            Rectangle
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height / 10
                color: ESAA.color
            }

            Image
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
//                height: width
                source: ESAA.logoUrl
                fillMode: Image.PreserveAspectFit
                visible: !meineDaten
            }
            ESAAText
            {
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: ESAA.locationName
                color: textColor
                font.pixelSize: ESAA.fontTextPixelsize * 1.5
                font.bold: true
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
                inputMethodHints: Qt.ImhPreferNumbers
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
                caption: qsTr("E-Mail-Adresse")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: emailAdress
                text: ESAA.emailAdress
                visible: meineDaten || ESAA.emailWanted
                inputMethodHints: Qt.ImhEmailCharactersOnly
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
            Item
            {
                width: parent.width
                height: 1
            }
        }
    }
    ESAAButton
    {
        id: sendButton
        anchors.margins: ESAA.spacing
        anchors.bottom: abortButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: theColumn.width - ESAA.spacing
        text: meineDaten ? "Meine Daten speichern" : "Kontaktdaten senden an\n" + ESAA.locationContactMailAdress
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
                saveContactData();
                ESAA.showMessage("Deine Kontaktdaten wurden gespeichert")
                return
            }

            if (fstname.visible)
            {
                if (fstname.text == "")
                {
                    fstname.forceActiveFocus()
                    ESAA.showMessage(qsTr("Bitte gib noch deinen Vornamen ein"))
                    return;
                }
                ESAA.fstname = fstname.text
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
            }
            ESAA.sendContactData();
            close()
        }
    }
    ESAAButton
    {
        id: abortButton
        anchors.margins: ESAA.spacing
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: theColumn.width - ESAA.spacing
        text: "Abbrechen"
        onClicked: abort()
    }
}
