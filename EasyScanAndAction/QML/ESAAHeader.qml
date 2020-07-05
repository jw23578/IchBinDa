import QtQuick 2.13

Rectangle
{
    gradient: Gradient
    {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: ESAA.headerColor }
        GradientStop { position: 1.0; color: Qt.lighter(ESAA.headerColor, 1.5)  }
    }

    color: ESAA.headerColor
    function animate()
    {
        textRowAni.start()
    }
    function initialAnimation()
    {
        textRow.visible = true
        initialTextRowAni.start()
    }

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
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -parent.width / 5
        height: parent.height
        spacing: parent.width / 4
        leftPadding: spacing

        ESAAText
        {
            text: "I"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "c"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "h"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: " "
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "b"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "i"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "n"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: " "
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "d"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "a"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
        ESAAText
        {
            text: "!"
            font.pixelSize: parent.height * 3 / 4
            color: ESAA.fontColor
        }
    }
}
