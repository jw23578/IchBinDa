import QtQuick 2.13
import QtQuick.Controls 2.13

Switch {
    id: control
    text: qsTr("Switch")
    property color fontColor: control.down ? "#17a81a" : "#21be2b"

    contentItem: Text {
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.fontColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing
        }
}
