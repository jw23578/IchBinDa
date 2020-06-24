import QtQuick 2.0

FocusScope
{

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        border.color: "black"
        border.width: 1
        TextInput
        {
            focus: true
            anchors.fill: parent
            anchors.margins: parent.border.width
        }
    }
}

