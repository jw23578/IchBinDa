import QtQuick 2.0
import QtQuick.Controls 2.13

Button
{
    width: parent.width * 3 / 4
    id: control
    text: qsTr("Button")
    property alias color: textItem.color
    contentItem: ESAAText {
        id: textItem
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color:  ESAA.fontColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

    background: Rectangle {
        color: control.down ? ESAA.buttonDownColor : ESAA.buttonColor
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 0.8 : 0.3
        border.color: ESAA.buttonBorderColor
        border.width: 1
        radius: 5
    }
}
