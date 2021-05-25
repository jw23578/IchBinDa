import QtQuick 2.15
import "Comp"
import "qrc:/foundation"

Item
{
    id: splashscreen
    property color gradientFromColor: ESAA.buttonFromColor
    property bool minimized: false
    property alias headerText: headerCaption.text
    property color gradientToColor: minimized ? ESAA.buttonFromColor : ESAA.buttonToColor
    property alias showMenueButton: theBar.visible
    signal splashDone
    signal barClicked
    anchors.left: parent.left
    width: parent.width
    height: parent.height
    property int rectHeight: height
    property int rectWidth: width
    property url imageSource: ""
    property double headerImageSizeFactor: 1.0
    function setCaption(newCaption, newImageSource, newHeaderImageSizeFactor)
    {
        headerCaption2.text = newCaption
        showTextAni.start()
        imageSource = newImageSource
        headerImageSizeFactor = newHeaderImageSizeFactor
        headerImage.source = imageSource
        showImageAni.start()
    }
    SequentialAnimation
    {
        id: showImageAni

        ParallelAnimation
        {
            NumberAnimation
            {
                target: headerImage
                property: "width"
                to: IBDGlobals.headerHeight * 0.75
                duration: IDPGlobals.pageChangeDuration
            }
            NumberAnimation
            {
                target: headerImage
                property: "anchors.bottomMargin"
                to: IBDGlobals.headerHeight * 0.75
                duration: IDPGlobals.pageChangeDuration
                onStopped: headerImage.source = imageSource
                easing.type: Easing.OutQuad
            }
        }
        ParallelAnimation
        {
            NumberAnimation
            {
                target: headerImage
                property: "width"
                to: IBDGlobals.headerHeight * headerImageSizeFactor
                duration: IDPGlobals.pageChangeDuration
            }
            NumberAnimation
            {
                target: headerImage
                property: "anchors.bottomMargin"
                to: 0
                duration: IDPGlobals.pageChangeDuration
                easing.type: Easing.InQuad
            }
        }
    }

    SequentialAnimation
    {
        id: showTextAni

        PauseAnimation {
            duration: IDPGlobals.pageChangeDuration / 2
        }
        ParallelAnimation {
            NumberAnimation {
                target: headerCaption
                property: "width"
                to: 0
                duration: IDPGlobals.pageChangeDuration
            }
            NumberAnimation {
                target: headerCaption2
                property: "x"
                to: IBDGlobals.headerHeight // splashscreen.headerHeight
                duration: IDPGlobals.pageChangeDuration
            }
        }
        onStopped: {
            headerCaption.text = headerCaption2.text
            headerCaption.width = headerCaption.contentWidth
            headerCaption.x = IBDGlobals.headerHeight
            headerCaption2.x = splashscreen.width
        }
    }

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
        clip: true
        //        gradient: Gradient
        //        {
        //            orientation: Gradient.Horizontal
        //            GradientStop {position: 0.0; color: splashscreen.gradientFromColor}
        //            GradientStop {position: 1.0; color: splashscreen.gradientToColor}
        //        }
        IDPText
        {
            x: IBDGlobals.headerHeight
            anchors.bottom: parent.bottom
            id: headerCaption
            color: ESAA.textColor
            font.pixelSize: ESAA.fontTextPixelsize * 1.5
            clip: true
            font.bold: true
            opacity: 0.8
        }
        IDPText
        {
            x: parent.width
            anchors.bottom: parent.bottom
            id: headerCaption2
            color: ESAA.textColor
            font.pixelSize: ESAA.fontTextPixelsize * 1.5
            font.bold: true
            opacity: 0.8
        }
        Image
        {
            id: headerImage
            height: width / 1.5
            width: parent.height * headerImageSizeFactor
            anchors.horizontalCenterOffset: parent.width / 6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            mipmap: true
            fillMode: Image.PreserveAspectFit
        }

        Logo
        {
            id: logo
            y: (parent.height - height) / 2
            width: Math.min(parent.height, parent.width)
            height: width
            visible: parent.height != IBDGlobals.headerHeight || !JW78APP.loggedIn
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
            visible: parent.height == IBDGlobals.headerHeight && JW78APP.loggedIn
            width: height
            height: IBDGlobals.headerHeight
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
            if (height == IBDGlobals.headerHeight)
            {
                rotateProfileImage.start()
            }
        }

        function minimize()
        {
            splashscreen.minimized = true
            height = IBDGlobals.headerHeight
            logo.qrCodeOffset = parent.height / 10 / 8
            logo.claimImageX = parent.height / 10 / 8
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
        width: IBDGlobals.headerHeight
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
    Rectangle
    {
        id: theBar
        anchors.top: topRect.bottom
        anchors.topMargin: IBDGlobals.headerHeight / 4
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width / 4
        height: IDPGlobals.spacing / 1.5
        radius: height / 2
        color: "#EBEBF3"
        MouseArea
        {
            anchors.fill: parent
            anchors.margins: -IDPGlobals.spacing / 2
            onClicked: splashscreen.barClicked()
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
