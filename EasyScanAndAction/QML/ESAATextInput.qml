import QtQuick 2.0

FocusScope
{
    property alias text: input.text
    property alias displayText: input.displayText
    property alias inputMethodHints: input.inputMethodHints
    property alias readOnly: input.readOnly
//    property alias contentHeight: input.contentHeight
    height: input.contentHeight + 10
    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        border.color: "black"
        border.width: input.readOnly ? 0 : 1
        radius: ESAA.radius
        color: input.readOnly ? "white" : input.activeFocus ? Qt.lighter(ESAA.fontColor2) : ESAA.fontColor2
        TextInput
        {
            id: input
            focus: true
            anchors.fill: parent
            anchors.margins: parent.border.width + 4
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto-Regular"
            clip: true
        }
    }
}

