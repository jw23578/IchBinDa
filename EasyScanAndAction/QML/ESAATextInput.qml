import QtQuick 2.0

FocusScope
{
    property alias text: input.text
    property alias displayText: input.displayText
    property alias inputMethodHints: input.inputMethodHints
//    property alias contentHeight: input.contentHeight
    height: input.contentHeight + 10
    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        border.color: "black"
        border.width: 1
        radius: 5
        TextInput
        {
            id: input
            focus: true
            anchors.fill: parent
            anchors.margins: parent.border.width + 4
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto-Thin"
        }
    }
}

