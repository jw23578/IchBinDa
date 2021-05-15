import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/foundation"

Switch {
    id: control
    text: qsTr("Switch")
    font.family: "Roboto-Regular"
    font.pixelSize: ESAA.fontTextPixelsize
    property alias fontColor: textElement.color

    contentItem: IDPText {
        id: textElement
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: IDPGlobals.defaultFontColorInput
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        leftPadding: control.indicator.width + control.spacing
    }
    indicator: Rectangle {
        id: indicatorRectangle
        implicitWidth: 48
        implicitHeight: 26
        x: 0
        y: parent.height / 2 - height / 2
        radius: height / 2
        color: control.checked ? fontColor : "transparent"
        border.color: fontColor
        Behavior on color {

            ColorAnimation {
                duration: IDPGlobals.fastAnimationDuration
            }
        }



        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: 26
            height: 26
            radius: 13
            color: control.down ? "#cccccc" : "#ffffff"
            border.color: fontColor
            Behavior on x {
                NumberAnimation {
                    duration: IDPGlobals.fastAnimationDuration
                }
            }
        }
    }
}
