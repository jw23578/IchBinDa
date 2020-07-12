import QtQuick 2.13
import QtGraphicalEffects 1.13

Image
{
    id: img
    source: "qrc:/images/inputBackground.jpg"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
    Rectangle
    {
        anchors.fill: parent
        color: "black" // ESAA.textBackgroundColor
        opacity: 0.85
    }
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource:
            Rectangle {
                width: img.width
                height: img.height
                radius: ESAA.radius * 3
        }
    }
}
