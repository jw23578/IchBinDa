import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

Button
{
    width: ESAA.screenWidth / 4
    height: width
    id: control
    font.family: "Roboto-Regular"
    font.pixelSize: ESAA.fontButtonPixelsize * 0.8
    property string smallTopText: ""
    property alias alertAniRunning: alertAni.running
    property bool repeatAlertAni: false;
    property int markGlowRadius: 0
    property alias source: img.source
    property alias downSource: downImg.source
    property color buttonDownColor: ESAA.buttonDownColor
    property color buttonColor: ESAA.buttonColor
    property color buttonColor2: "#364995"
    property int verticalImageOffset: 0
    property double imageSizeFactor: 1
    property alias belowCaption: belowCaptionText.text
    property alias aboveCaption: aboveCaptionText.text
    contentItem: Item {
        ESAAText
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: control.height / 8
            text: control.smallTopText
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? control.buttonColor : "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.pixelSize: ESAA.fontTextPixelsize / 1.3
            font.family: "Roboto-Thin"

        }
        ESAAText
        {
            anchors.centerIn: parent
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? control.buttonColor : "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
    ESAAText
    {
        visible: text != ""
        id: belowCaptionText
        color: ESAA.buttonColor
        font.pixelSize: control.font.pixelSize * 1.5
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }
    ESAAText
    {
        visible: text != ""
        id: aboveCaptionText
        color: ESAA.buttonColor
        font.pixelSize: control.font.pixelSize * 1.5
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
    }

    background: Rectangle {
        id: background
        gradient: control.down ? null : theGradient
        Gradient {
            id: theGradient
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: control.buttonColor }
            GradientStop { position: 1.0; color: control.buttonColor2 }
        }

        color: control.down ? "white" : control.buttonColor
        opacity: enabled ? 1 : 0.3
        border.color:  control.buttonColor
        border.width: control.down ? 1 : 0
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
        onStopped: colorAni1.start()
    }

    ColorAnimation {
        property: "buttonColor"
        id: colorAni1
        from: control.buttonColor
        to: control.buttonDownColor
        duration: 100
        onStopped: colorAni2.start()
    }
    ColorAnimation {
        property: "buttonColor"
        id: colorAni2
        from: control.buttonDownColor
        to: control.buttonColor
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
    SequentialAnimation
    {
        id: alertAni
        running: false
        NumberAnimation
        {
            target: control
            property: "markGlowRadius"
            to: 21
            duration: 800
        }
        NumberAnimation
        {
            target: control
            property: "markGlowRadius"
            to: 0
            duration: 800
        }
        onStopped:
        {
            if (repeatAlertAni)
            {
                alertAni.start()
            }
        }
    }
    Glow {
        visible: control.down
        anchors.fill: background
        radius: 8
        samples: 17
        color: ESAA.lineInputBorderColor
        source: background
    }
    Glow {
        visible: parent.markGlowRadius > 0
        anchors.fill: background
        radius: parent.markGlowRadius
        samples: 17
        color: "orange" // ESAA.lineInputBorderColor
        source: background
    }
}
