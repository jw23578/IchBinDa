import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.1

Item
{
    anchors.fill: parent
    Flickable
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: sendButton.top
        contentHeight: dataColumn.height
        Column
        {
            id: dataColumn
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - parent.width / 10
            height: parent.height * 2
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
        }
    }
    Button
    {
        id: sendButton
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: "Kontaktdaten senden"
        onClicked:
        {
            ESAA.fstname = fstname.text
            ESAA.surname = surname.text
            ESAA.sendContactData();
            ESAA.showMessage("gleich wird gesendet")
        }
    }
}
