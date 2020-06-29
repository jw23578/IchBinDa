import QtQuick 2.0
import QtQuick.Controls 2.13

Button
{
    id: control
    text: qsTr("Button")

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? "#17a81a" : "#21be2b"
        border.width: 1
        radius: 5
    }
}
