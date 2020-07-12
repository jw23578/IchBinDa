import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Button
{
    width: parent.width * 3 / 4
    id: control
    text: qsTr("Button")
    font.pixelSize: ESAA.fontButtonPixelsize
    property alias source: img.source
    property alias color: textItem.color
    property color buttonColor: ESAA.buttonColor
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
        color: control.down ? ESAA.buttonDownColor : control.buttonColor
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 0.8 : 0.3
        border.color: ESAA.buttonBorderColor
        border.width: 1
        radius: ESAA.radius
        Image
        {
            id: img
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 0.05 * parent.height
            height: parent.height * 0.9
            width: height
            fillMode: Image.PreserveAspectFit
            visible: source != ""
            mipmap: true
        }
    }
    property int pauseDuration: 0
    PauseAnimation {
        id: pauseAni
        duration: pauseDuration
        onFinished: colorAni1.start()
    }

    ColorAnimation on buttonColor {
        id: colorAni1
        from: ESAA.buttonColor
        to: ESAA.buttonDownColor
        duration: 100
        onFinished: colorAni2.start()
    }
    ColorAnimation on buttonColor {
        id: colorAni2
        from: ESAA.buttonDownColor
        to: ESAA.buttonColor
        duration: 100
    }

    function blink(pause)
    {
        pauseDuration = pause
        pauseAni.start()
    }

    property int pauseDurationRotation: 0
    PauseAnimation {
        id: pauseAniRotation
        duration: pauseDurationRotation
        onFinished: rotationAnimation.start()
    }
    NumberAnimation
    {
        id: rotationAnimation
        target: img
        property: "rotation"
        to: 0
        duration: 1200
        easing.type: Easing.InOutQuint
    }

    function rotate(pause)
    {
        pauseDurationRotation = pause
        img.rotation = -720
        pauseAniRotation.start()
    }
}
