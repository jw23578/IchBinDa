import QtQuick 2.0
import QtQuick.Controls 2.13

Item
{
    id: message
    anchors.fill: parent
    visible: false
    Rectangle
    {
        anchors.fill: parent
        color: "white"
    }
    Flickable
    {
        id: theFlick
        anchors.bottom: sendButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: parent.width / 20
        contentHeight: Math.max(messageText.contentHeight, sendButton.y)
        clip: true
        ESAAText
        {
            id: messageText
            anchors.centerIn: parent
            width: parent.width
            font.pixelSize: ESAA.fontMessageTextPixelsize
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.horizontalCenter
            color: ESAA.buttonColor
        }
    }

    function show(mt)
    {
        messageText.text = mt
        visible = true
    }
    ESAAButton
    {
        id: sendButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.width / 10
        text: "schließen"
        onClicked: message.visible = false
    }
}
