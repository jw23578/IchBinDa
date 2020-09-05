import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import QtQuick.Window 2.15

Button
{
    width: ESAA.screenWidth / 4
    height: width
    id: control
    font.family: "Roboto-Regular"
    font.pixelSize: ESAA.fontButtonPixelsize * 0.8
    property alias source: img.source
    property alias downSource: downImg.source
    property color buttonColor: ESAA.buttonColor
    property int verticalImageOffset: 0
    property double imageSizeFactor: 1

    contentItem: ESAAText
    {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? ESAA.buttonColor : "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        id: background
        color: control.down ? "white" : control.buttonColor
        opacity: enabled ? 1 : 0.3
        border.color: ESAA.buttonColor
        border.width: 1
        radius: width / 2
        Image
        {
            id: img
            anchors.centerIn: parent
            anchors.verticalCenterOffset: verticalImageOffset
            height: parent.height * imageSizeFactor
            width: height
            fillMode: Image.PreserveAspectFit
            mipmap: true
            visible: source != "" && (!control.down || downImg.source != "")
        }
        Image
        {
            id: downImg
            anchors.centerIn: parent
            anchors.verticalCenterOffset: verticalImageOffset
            height: parent.height * imageSizeFactor
            width: height
            fillMode: Image.PreserveAspectFit
            visible: source != "" && control.down
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
    Glow {
        visible: control.down
        anchors.fill: background
        radius: 8
        samples: 17
        color: ESAA.lineInputBorderColor
        source: background
    }
}
