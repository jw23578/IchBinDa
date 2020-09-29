import QtQuick 2.15
import QtQuick.Controls 2.15

Switch {
    id: control
    text: qsTr("Switch")
    font.family: "Roboto-Regular"
    font.pixelSize: ESAA.fontTextPixelsize
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
