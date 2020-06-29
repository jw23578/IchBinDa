import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.1

Rectangle
{
    color: ESAA.color
    anchors.fill: parent
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
            Image
            {
                width: parent.width
                height: width
                source: ESAA.logoUrl
                fillMode: Image.PreserveAspectFit
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Vorname")
                width: parent.width
                focus: true
                id: fstname
                text: ESAA.fstname
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Nachname")
                width: parent.width
                id: surname
                text: ESAA.surname
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Straße")
                width: parent.width
                id: street
                text: ESAA.street
                visible: ESAA.adressWanted
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Hausnummer")
                width: parent.width
                id: housenumber
                text: ESAA.housenumber
                visible: ESAA.adressWanted
                inputMethodHints: Qt.ImhPreferNumbers
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Postleitzahl")
                width: parent.width
                id: zip
                text: ESAA.zip
                visible: ESAA.adressWanted
                inputMethodHints: Qt.ImhDigitsOnly
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Ort")
                width: parent.width
                id: location
                text: ESAA.location
                visible: ESAA.adressWanted
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("E-Mail-Adresse")
                width: parent.width
                id: emailAdress
                text: ESAA.emailAdress
                visible: ESAA.emailWanted
                inputMethodHints: Qt.ImhPreferLowercase
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Handynummer")
                width: parent.width
                id: mobile
                text: ESAA.mobile
                visible: ESAA.mobileWanted
            }
            Item
            {
                width: parent.width
                height: width / 5
            }
            Button
            {
                id: sendButton
                width: parent.width
                text: "Kontaktdaten senden"
                onClicked:
                {
                    if (fstname.visible)
                    {
                        if (fstname.text == "")
                        {
                            fstname.forceActiveFocus()
                            ESAA.showMessage(qsTr("Bitte gib noch deinen Vornamen ein"))
                            return;
                        }
                        ESAA.fstname = fstname.text
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
                    }
                    if (zip.visible)
                    {
                        if (zip.text == "")
                        {
                            zip.forceActiveFocus()
                            ESAA.showMessage(qsTr("Bitte gib noch deine Postleitzahl ein"))
                            return;
                        }
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
                    }
                    if (mobile.visible)
                    {
                        if (mobile.text == "")
                        {
                            mobile.forceActiveFocus()
                            ESAA.showMessage(qsTr("Bitte gib noch deine Handynummer ein"))
                            return;
                        }
                        ESAA.mobile = mobile.text
                    }
                    ESAA.sendContactData();
                    ESAA.showMessage("gleich wird gesendet")
                }
            }
            Item
            {
                width: parent.width
                height: width / 5
            }
            Button
            {
                width: parent.width
                text: "Scanner öffnen"
                onClicked:
                {
                    theFlick.contentY = 0
                    ESAA.scan()
                }
            }

            Item
            {
                width: parent.width
                height: width
            }
        }
    }
}
