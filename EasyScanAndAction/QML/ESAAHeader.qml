import QtQuick 2.13

Rectangle
{
    id: header
    color: "#cccccc"
    function animate()
    {
        textRowAni.start()
    }
    function initialAnimation()
    {
        textRow.visible = true
        initialTextRowAni.start()
    }
    Rectangle
    {
        clip: true
        height: parent.height * 2
        y: - parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: ESAA.spacing / 2
        radius: ESAA.radius
        color: "steelblue"
        opacity: 0.8
        border.width: 1
        border.color: "#aaaaee"

        NumberAnimation
        {
            target: textRow
            id: initialTextRowAni
            property: "spacing"
            to: 0
            duration: 1000
            easing.type: Easing.Linear
        }
        SequentialAnimation
        {
            id: textRowAni
            NumberAnimation
            {
                target: textRow
                property: "spacing"
                to: 10
                duration: 200
            }
            NumberAnimation
            {
                target: textRow
                property: "spacing"
                to: 0
                duration: 200
            }
        }
        Row
        {
            visible: false
            id: textRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.horizontalCenterOffset: -header.width / 3.5
            height: parent.height / 2
            spacing: parent.width / 4
            leftPadding: spacing

            property color textColor: "white" // ESAA.fontColor

            ESAAText
            {
                text: "I"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "c"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "h"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: " "
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "b"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "i"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "n"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: " "
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "d"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "a"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
            ESAAText
            {
                text: "!"
                font.pixelSize: parent.height * 3 / 4
                color: parent.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    MouseArea
    {
        anchors.fill: parent
        pressAndHoldInterval: 10000
        onPressAndHold:
        {
            ESAA.showMessage("Die Einstellungen wurden zurückgesetzt")
            ESAA.reset()
        }
    }
}
