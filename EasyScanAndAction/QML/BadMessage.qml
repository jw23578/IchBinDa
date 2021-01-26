import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"
import "qrc:/foundation"

Background
{
    id: message
    anchors.fill: parent
    visible: false
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
        IDPText
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
    IDPButtonCircle
    {
        id: sendButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing * 2.5
        text: "Schließen"
        onClicked: message.visible = false
    }
}
