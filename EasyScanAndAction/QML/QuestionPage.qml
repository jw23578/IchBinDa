import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.1

ESAAPage
{
    onShowing: theFlick.contentY = 0
    signal saveContactData
    signal abort
    property bool meineDaten: ESAA.locationName == "MeineDaten"
    property color textColor: meineDaten ? ESAA.fontColor : "black"
    Flickable
    {
        id: theFlick
        anchors.fill: parent
        contentHeight: dataColumn.height
        Column
        {
            id: dataColumn
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - parent.width / 10
            spacing: ESAA.spacing / 2
            topPadding: spacing
            Image
            {
                width: parent.width
                height: width
                source: ESAA.logoUrl
                fillMode: Image.PreserveAspectFit
                visible: !meineDaten
            }
            ESAAText
            {
                width: parent.width
                text: ESAA.locationName
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Vorname")
                width: parent.width
                focus: true
                id: fstname
                text: ESAA.fstname
                color: textColor
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Nachname")
                width: parent.width
                id: surname
                text: ESAA.surname
                color: textColor
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Straße")
                width: parent.width
                id: street
                text: ESAA.street
                visible: meineDaten || ESAA.adressWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Hausnummer")
                width: parent.width
                id: housenumber
                text: ESAA.housenumber
                visible: meineDaten || ESAA.adressWanted
                inputMethodHints: Qt.ImhPreferNumbers
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Postleitzahl")
                width: parent.width
                id: zip
                text: ESAA.zip
                visible: meineDaten || ESAA.adressWanted
                inputMethodHints: Qt.ImhDigitsOnly
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Ort")
                width: parent.width
                id: location
                text: ESAA.location
                visible: meineDaten || ESAA.adressWanted
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("E-Mail-Adresse")
                width: parent.width
                id: emailAdress
                text: ESAA.emailAdress
                visible: meineDaten || ESAA.emailWanted
                inputMethodHints: Qt.ImhPreferLowercase
                color: textColor
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Handynummer")
                width: parent.width
                id: mobile
                text: ESAA.mobile
                visible: meineDaten || ESAA.mobileWanted
                color: textColor
            }
            ESAAButton
            {
                id: sendButton
                width: parent.width
                text: meineDaten ? "Meine Daten speichern" : "Kontaktdaten senden an\n" + ESAA.locationContactMailAdress
                color: textColor
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
                    ESAA.showMessage("gleich wird gesendet")
                }
            }
            ESAAButton
            {
                id: abortButton
                width: parent.width
                text: "Abbrechen"
                onClicked: abort()
                color: textColor
            }

            Item
            {
                width: parent.width
                height: abortButton.height
            }
        }
    }
}
