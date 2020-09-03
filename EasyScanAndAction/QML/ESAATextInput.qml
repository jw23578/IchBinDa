import QtQuick 2.0

FocusScope
{
    property alias text: input.text
    property alias displayText: input.displayText
    property alias inputMethodHints: input.inputMethodHints
    property alias readOnly: input.readOnly
    property alias color: input.color
//    property alias contentHeight: input.contentHeight
    height: input.contentHeight + 10
    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        border.color: "#E9F0F8"
        border.width: input.readOnly ? 0 : 1
        radius: ESAA.radius
        color: input.readOnly ? "white" : input.activeFocus ? "white" : "#E9F0F8"
        TextInput
        {
            id: input
            focus: true
            anchors.fill: parent
            anchors.margins: parent.border.width + 4
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto-Regular"
            color: ESAA.buttonColor
            clip: true
        }
    }
}

