import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"
import "qrc:/foundation"

Background {
    id: yesnoquestion
    anchors.fill: parent
    visible: opacity > 0
    opacity: 0
    property var yescallbackFunction: null
    property var nocallbackFunction: null
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
        IDPText
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

    function show(mt, yescallback, nocallback)
    {
        yescallbackFunction = yescallback
        nocallbackFunction = nocallback
        messageText.text = mt
        yesnoquestion.opacity = 1
        yesnoquestion.forceActiveFocus()
        Qt.inputMethod.hide();
    }
    TwoCircleButtons
    {
        id: sendButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing * 2.5
        leftText: "Ja"
        onLeftClicked:
        {
            if (yescallbackFunction != null)
            {
                yescallbackFunction()
            }
            yesnoquestion.opacity = 0
        }
        rightText: "Nein"
        onRightClicked:
        {
            if (nocallbackFunction != null)
            {
                nocallbackFunction()
            }
            yesnoquestion.opacity = 0
        }
    }
}
