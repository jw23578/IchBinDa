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
            width: parent.width
            height: parent.height * 2
            Text {
                text: qsTr("Vorname")
            }
            ESAATextInput
            {
                width: parent.width
                height: 20
                focus: true
                id: fstname
            }

            Text {
                text: qsTr("Nachname")
            }
            ESAATextInput
            {
                width: parent.width
                height: 20
                id: surname
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
        onClicked: ESAA.showMessage("gleich wird gesendet")
    }
}
