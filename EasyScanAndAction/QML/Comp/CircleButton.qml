import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

Button
{
    focusPolicy: Qt.NoFocus
    width: JW78Utils.screenWidth / 4
    height: width
    id: control
    font.family: "Roboto-Regular"
    font.pixelSize: JW78APP.fontButtonPixelsize * 0.8
    property string smallTopText: ""
    property alias alertAniRunning: alertAni.running
    property bool repeatAlertAni: false;
    property int markGlowRadius: 0
    property alias source: img.source
    property alias downSource: downImg.source
    property color buttonDownColor: JW78APP.buttonDownColor
    property color buttonFromColor: JW78APP.buttonFromColor
    property color buttonToColor: JW78APP.buttonToColor
    Behavior on buttonToColor {
        ColorAnimation {
            duration: JW78Utils.longAniDuration
        }
    }
    Behavior on buttonFromColor {
        ColorAnimation {
            duration: JW78Utils.longAniDuration
        }
    }


    property int verticalImageOffset: 0
    property double imageSizeFactor: 1
    property alias belowCaption: belowCaptionText.text
    property alias aboveCaption: aboveCaptionText.text
    property alias disabledText: disabledTextItem.text
    property alias imageRotation: img.rotation
    contentItem: Item {
        ESAAText
        {
            id: disabledTextItem
            anchors.centerIn: parent
            font: control.font
            visible: !enabled && text != ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        ESAAText
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: control.height / 8
            text: control.smallTopText
            opacity: enabled ? 1.0 : 0.3
            color:  control.down ? control.buttonFromColor : control.buttonDownColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.pixelSize: JW78APP.fontTextPixelsize / 1.3
            font.family: "Roboto-Thin"
        }
        ESAAText
        {
            anchors.centerIn: parent
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : disabledTextItem.visible ? 0 : 0.3
            color: control.down ? control.buttonFromColor : control.buttonDownColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
    ESAAText
    {
        visible: text != ""
        id: belowCaptionText
        color: JW78APP.buttonColor
        font.pixelSize: control.font.pixelSize * 1.3
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
        color: JW78APP.buttonColor
        font.pixelSize: control.font.pixelSize * 1.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
    }

    background: Item {
        id: backgroundItem
        Glow {
            visible: control.down
            anchors.fill: parent
            radius: 8
            samples: 17
            color: JW78APP.lineInputBorderColor
            source: background
        }

        Glow {
            visible: radius > 0
            anchors.fill: backgroundItem
            radius: control.markGlowRadius
            samples: 17
            color: "orange" // ESAA.lineInputBorderColor
            source: background
        }

        Rectangle {
            anchors.fill: parent
        id: background
        gradient: control.down ? null : theGradient
        Gradient {
            id: theGradient
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: control.buttonFromColor }
            GradientStop { position: 1.0; color: control.buttonToColor }
        }
        color: control.buttonDownColor
        border.color:  control.buttonFromColor
        border.width: control.down ? 1 : 0

        opacity: enabled ? 1 : 0.3
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
            rotation: img.rotation
            anchors.centerIn: parent
            anchors.verticalCenterOffset: verticalImageOffset
            height: parent.height * imageSizeFactor
            width: height
            fillMode: Image.PreserveAspectFit
            visible: source != "" && control.down
            mipmap: true
        }
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
        from: control.buttonFromColor
        to: control.buttonDownColor
        duration: 100
        onStopped: colorAni2.start()
    }
    ColorAnimation {
        property: "buttonColor"
        id: colorAni2
        from: control.buttonDownColor
        to: control.buttonFromColor
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
}
