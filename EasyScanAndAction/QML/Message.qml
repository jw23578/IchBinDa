import QtQuick 2.0
import QtQuick.Controls 2.13

Item
{
    id: message
    anchors.fill: parent
    visible: false
    Image
    {
        anchors.fill: parent
        source: "qrc:/images/messageBackground.jpg"
        fillMode: Image.PreserveAspectCrop
        Rectangle
        {
            anchors.fill: parent
            color: "black"
            opacity: 0.8
        }
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
