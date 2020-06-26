import QtQuick 2.0
import QtQuick.Controls 2.13

Rectangle
{
    id: message
    anchors.fill: parent
    visible: false
    color: "green"
    Text
    {
        id: messageText
        anchors.centerIn: parent
    }
    function show(mt)
    {
        messageText.text = mt
        visible = true
    }
    Button
    {
        id: sendButton
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: "schließen"
        onClicked: message.visible = false
    }
}
