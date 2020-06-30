import QtQuick 2.0

Item
{
    anchors.fill: parent
    Rectangle
    {
        x: -parent.width / 2
        width: parent.width * 2
        height: parent.width / 2
        color: "red"
        rotation: 10
        antialiasing: true
    }
}
