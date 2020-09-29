import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Button
{
    width: height
    id: control
    font.pixelSize: ESAA.fontButtonPixelsize
    property alias source: img.source
    property color buttonColor: ESAA.buttonColor

    background: Rectangle {
        color: control.down ? ESAA.buttonDownColor : control.buttonColor
        opacity: enabled ? 0.8 : 0.3
        border.color: ESAA.buttonBorderColor
        border.width: 1
        radius: ESAA.radius
        Image
        {
            id: img
            anchors.centerIn: parent
            height: parent.height * 0.6
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
