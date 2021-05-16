import QtQuick 2.15
import "Comp"
import "qrc:/foundation"

Item
{
    id: splashscreen
    property int headerHeight: parent.height / 10
    property color gradientFromColor: ESAA.buttonFromColor
    property bool minimized: false
    property alias headerText: headerCaption.text
    property color gradientToColor: minimized ? ESAA.buttonFromColor : ESAA.buttonToColor
    signal splashDone
    signal helpClicked
    anchors.left: parent.left
    width: parent.width
    height: parent.height
    property int rectHeight: height
    property int rectWidth: width
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
    Rectangle
    {
        id: topRect
        width: parent.rectWidth
        height: parent.rectHeight
        opacity: 1
        color: ESAA.mainColor
//        gradient: Gradient
//        {
//            orientation: Gradient.Horizontal
//            GradientStop {position: 0.0; color: splashscreen.gradientFromColor}
//            GradientStop {position: 1.0; color: splashscreen.gradientToColor}
//        }
        IDPText
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
            visible: parent.height != splashscreen.headerHeight || !JW78APP.loggedIn
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
                JW78APP.reset()
            }
        }
        NumberAnimation
        {
            id: rotateProfileImage
            target: profileImage
            property: "rotation"
            from: 0
            to: 360
            duration: JW78Utils.longAniDuration
        }

        Connections
        {
            target: JW78APP
            function onLoggedInChanged() {
                rotateProfileImage.start()
            }
        }

        Item
        {
            id: profileItem
            visible: parent.height == splashscreen.headerHeight && JW78APP.loggedIn
            width: height
            height: splashscreen.headerHeight
            Image
            {
                id: profileImage
                mipmap: true
                source: "qrc:/images/user.svg"
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: parent.height * 0.9
            }
            MouseArea
            {
                z: 1
                anchors.fill: parent
                onClicked: JW78APP.profileIconClicked();
            }

        }

        onHeightChanged: {
            if (height == splashscreen.headerHeight)
            {
                rotateProfileImage.start()
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
            anchors.rightMargin: IDPGlobals.spacing
            anchors.verticalCenter: parent.verticalCenter
            width: splashscreen.headerHeight * 0.8
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
                onClicked: splashscreen.helpClicked()
            }
        }

        PauseAnimation {
            duration: 3000
            id: longWait
            onStopped: helpImage.opacity = 1
        }

        function minimize()
        {
            splashscreen.minimized = true
            height = splashscreen.headerHeight
            logo.qrCodeOffset = parent.height / 10 / 8
            logo.claimImageX = parent.height / 10 / 8
            longWait.start()
        }

        PauseAnimation {
            id: hidePause
            duration: 1000
            onFinished: {
                splashscreen.splashDone()
                topRect.minimize()
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
    }
    Canvas {
        id: bottomLeft
        width: splashscreen.headerHeight
        height: width
        anchors.top: topRect.bottom
        onPaint: {
            var ctx = getContext("2d");
            ctx.beginPath();
            ctx.moveTo(width, 0);
            ctx.arcTo(0, 0, 0, height, height);
            ctx.lineTo(0, 0);
            ctx.closePath();
            ctx.clip();
            ctx.fillStyle = ESAA.mainColor;
            ctx.fillRect(0, 0, width, height);
        }
    }    
    Canvas {
        id: bottomRight
        width: bottomLeft.width
        height: width
        anchors.top: topRect.bottom
        anchors.right: parent.right
        onPaint: {
            var ctx = getContext("2d");
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.arcTo(width, 0, width, height, height);
            ctx.lineTo(width, 0);
            ctx.closePath();
            ctx.clip();
            ctx.fillStyle = ESAA.mainColor;
            ctx.fillRect(0, 0, width, height);
        }
    }
    function start()
    {
        pause.start()
    }
    Behavior on y {
        NumberAnimation {
            duration: IDPGlobals.pageChangeDuration
        }
    }

    function moveDown()
    {
        y = parent.height
    }
    function moveUp()
    {
        y = 0
    }

    Component.onCompleted: start()
}
