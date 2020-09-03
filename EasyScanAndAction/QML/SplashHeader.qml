import QtQuick 2.13

Rectangle
{
    signal splashDone
    id: splashscreen
    opacity: 1
    y: 0
    x: 0
    width: parent.width
    height: parent.height
    property color gradientFromColor: "#4581B3"
    property color gradientToColor: "#364995"
    property int shrinkDuration: 200
    Behavior on gradientToColor {
        ColorAnimation {
            duration: shrinkDuration
        }
    }

    gradient: Gradient
    {
        orientation: Gradient.Horizontal
        GradientStop {position: 0.0; color: gradientFromColor}
        GradientStop {position: 1.0; color: gradientToColor}
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
            duration: shrinkDuration
            easing.type: Easing.OutCubic
        }
    }

    function minimize()
    {
        height = parent.height / 14
        gradientToColor = gradientFromColor
        logo.qrCodeOffset = parent.height / 10 / 8
        logo.claimImageX = parent.height / 10 / 8
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
