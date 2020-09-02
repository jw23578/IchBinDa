import QtQuick 2.13

ESAAPage
{
    signal splashDone
    id: splashscreen
    opacity: 1
    y: 0
    Rectangle
    {
        anchors.fill: parent
        gradient: Gradient
        {
            orientation: Gradient.Horizontal
            GradientStop {position: 0.0; color: "#4581B3"}
            GradientStop {position: 1.0; color: "#364995"}
        }
    }

    property int qrCodeOffset: 0
    Behavior on qrCodeOffset {
        NumberAnimation
        {
            id: moveQRCode
        }
    }
    Image
    {
        id: qrCodeImage
        width: parent.width / 2
        opacity: 0.6
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: qrCodeOffset
        source: "qrc:/images/logoQR_1024x1024.png"
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }
    Image
    {
        id: claimImage
        width: qrCodeImage.width / 580.0 * 364.0
        source: "qrc:/images/logoClaim_1024x1024.png"
        mipmap: true
        fillMode: Image.PreserveAspectFit
        x: -width
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -height / 4
        Behavior on x {
            NumberAnimation {
                duration: 400
            }
        }
    }

    PauseAnimation {
        id: hidePause
        duration: 1000
        onFinished: splashDone()
    }

    PauseAnimation
    {
        id: pause
        duration: 20
        onFinished:
        {
            hidePause.start()
            qrCodeOffset = splashscreen.width / 8
            claimImage.x = parent.width / 8
            //            animation.start()
        }
    }
    function start()
    {
        pause.start()
    }
}
