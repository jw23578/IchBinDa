import QtQuick 2.15
import "Comp"

Rectangle
{
    signal splashDone
    signal helpClicked
    id: splashscreen
    opacity: 1
    y: 0
    x: 0
    width: parent.width
    height: parent.height
    property bool minimized: false
    property alias headerText: headerCaption.text
    property color gradientFromColor: ESAA.buttonFromColor
    property color gradientToColor: minimized ? ESAA.buttonFromColor : ESAA.buttonToColor
    Behavior on gradientToColor {
        ColorAnimation {
            duration: JW78Utils.longAniDuration
        }
    }
    Behavior on gradientFromColor {
        ColorAnimation {
            duration: JW78Utils.longAniDuration
        }
    }
    gradient: Gradient
    {
        orientation: Gradient.Horizontal
        GradientStop {position: 0.0; color: gradientFromColor}
        GradientStop {position: 1.0; color: gradientToColor}
    }
    ESAAText
    {
        anchors.centerIn: parent
        id: headerCaption
        color: ESAA.textColor
        font.pixelSize: ESAA.fontTextPixelsize * 0.8
    }

    Logo
    {
        id: logo
        y: (parent.height - height) / 2
        width: Math.min(parent.height, parent.width)
        height: width
    }
    Behavior on height {
        NumberAnimation
        {
            duration: JW78Utils.longAniDuration
            easing.type: Easing.OutCubic
        }
    }
    MouseArea
    {
        anchors.fill: parent
        pressAndHoldInterval: 5000
        onPressAndHold: {
            ESAA.reset()
        }
    }
    Image
    {
        property int changeCounter: 0
        Timer
        {
            interval: 10000
            repeat: true
            running: true
            onTriggered: helpImage.changeCounter += 1
        }
        id: helpImage
        anchors.right: parent.right
        anchors.rightMargin: (parent.parent.height / 16 - parent.parent.height / 20) / 2
        anchors.topMargin: (parent.parent.height / 16 - parent.parent.height / 20) / 2
        anchors.top: parent.top
        width: parent.parent.height / 20
        height: width
        source: "qrc:/images/help.svg"
        opacity: 0
        visible: !ESAA.isActiveVisit(helpImage.changeCounter)
        fillMode: Image.PreserveAspectFit
        mipmap: true
        Behavior on opacity {
            NumberAnimation
            {
                duration: JW78Utils.longAniDuration
            }
        }
        MouseArea
        {
            enabled: !ESAA.isActiveVisit(helpImage.changeCounter)
            anchors.fill: parent
            onClicked: helpClicked()
        }
    }

    PauseAnimation {
        duration: 3000
        id: longWait
        onStopped: helpImage.opacity = 1
    }

    function minimize()
    {
        minimized = true
        height = parent.height / 16
        logo.qrCodeOffset = parent.height / 10 / 8
        logo.claimImageX = parent.height / 10 / 8
        longWait.start()
    }

    PauseAnimation {
        id: hidePause
        duration: 1000
        onFinished: {
            splashDone()
            minimize()
        }
    }

    PauseAnimation
    {
        id: pause
        duration: 20
        onFinished:
        {
            hidePause.start()
            logo.qrCodeOpacity = 0.6
            logo.qrCodeOffset = splashscreen.width / 8
            logo.claimImageX = parent.width / 8
        }
    }
    function start()
    {
        pause.start()
    }
    Component.onCompleted: start()
}
