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
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Hausnummer")
                width: parent.width
                id: streetnumber
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Postleitzahl")
                width: parent.width
                id: zip
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Ort")
                width: parent.width
                id: location
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
                    ESAA.fstname = fstname.text
                    ESAA.surname = surname.text
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
