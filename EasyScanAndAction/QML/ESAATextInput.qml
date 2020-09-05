import QtQuick 2.15
import QtGraphicalEffects 1.15

FocusScope
{
    property alias text: input.text
    property alias displayText: input.displayText
    property alias inputMethodHints: input.inputMethodHints
    property alias readOnly: input.readOnly
    property alias color: input.color
//    property alias contentHeight: input.contentHeight
    height: input.contentHeight + ESAA.spacing
    property bool colorEdit: false
    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        border.color: ESAA.lineInputBorderColor
        border.width: 1
        radius: ESAA.radius
        color: input.readOnly ? "white" : input.activeFocus ? "white" : border.color
        TextInput
        {
            id: input
            focus: true
            anchors.fill: parent
            anchors.leftMargin: parent.border.width + 4
            anchors.topMargin: parent.border.width + 4
            anchors.bottomMargin: parent.border.width + 4
            anchors.rightMargin: parent.border.width + 4 - colorEdit ? colorRect.width : 0
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto-Regular"
            font.pixelSize: ESAA.fontInputPixelsize
            color: ESAA.buttonColor
            clip: true
            onDisplayTextChanged:
            {
                colorRect.color = displayText
            }
        }
        Rectangle
        {
            color: "black"
            id: colorRect
            height: parent.height
            radius: ESAA.radius
            width: height
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: colorEdit
            border.color: ESAA.lineInputBorderColor
            border.width: 1
        }
    }
    Glow {
        visible: input.activeFocus
        anchors.fill: rectangle
        radius: 8
        samples: 17
        color: ESAA.lineInputBorderColor
        source: rectangle
    }
}

