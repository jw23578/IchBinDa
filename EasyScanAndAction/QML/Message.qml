import QtQuick 2.0
import QtQuick.Controls 2.13

Background
{
    id: message
    anchors.fill: parent
    visible: opacity > 0
    opacity: 0
    Behavior on opacity {
        NumberAnimation {
            duration: 300
        }
    }

    ESAAFlickable
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
            parent: theFlick.contentItem
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
        message.opacity = 1
        message.forceActiveFocus()
        Qt.inputMethod.hide();
    }
    CircleButton
    {
        id: sendButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        text: "Schließen"
        onClicked: message.opacity = 0
    }
}
