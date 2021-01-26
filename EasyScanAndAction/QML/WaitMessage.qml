import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"
import "qrc:/foundation"

Background
{
    id: message
    anchors.fill: parent
    visible: opacity > 0
    opacity: 0
    Behavior on opacity {
        NumberAnimation
        {
            duration: 200
        }
    }

    Flickable
    {
        id: theFlick
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: parent.width / 20
        contentHeight: Math.max(messageText.contentHeight, parent.height)
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
        console.log("wait: " + mt)
        messageText.text = mt
        opacity = 1
    }
    function hide()
    {
        opacity = 0
    }
}
