import QtQuick 2.15
import QZXing 2.3
import QtMultimedia 5.15
import QtGraphicalEffects 1.0
import "qrc:/foundation"

Item
{
    id: cvs
    property bool scan: false
    property string targetFileName: ""
    function stop()
    {
        camera.stop()
    }
    Camera
    {
        id: camera
        onErrorStringChanged: console.log("IDPCamera Error: " + errorString)
        focus.focusMode: Camera.FocusMacro //  Camera.FocusContinuous
        focus.focusPointMode:  Camera.FocusPointAuto
        onCameraStatusChanged: if (cameraStatus == Camera.ActiveStatus) waitForSearchAndLock.start()
        imageCapture {
            onImageCaptured: {
                clipImage.source = ""
                clipImage.source = preview
                clipImage.grabToImage(function(result) {
                    result.saveToFile(cvs.targetFileName)
                    cvs.imageSavedCallback(cvs.targetFileName)
                })
            }
            onImageSaved: {
                JW78Utils.deleteFile(path)
            }
        }
    }

    property int fromX: 0
    property int fromY: 0
    property int fromWidth: 0
    property int fromHeight: 0
    property int fromRadius: 0
    function moveIn(fromX, fromY, fromWidth, fromHeight, fromRadius,
                    toX, toY, toWidth, toHeight, toRadius)
    {
        cvs.fromX = fromX
        cvs.fromY = fromY
        cvs.fromWidth = fromWidth
        cvs.fromHeight = fromHeight
        cvs.fromRadius = fromRadius
        xAni.from = fromX
        xAni.to = toX
        yAni.from = fromY
        yAni.to = toY
        widthAni.from = fromWidth
        widthAni.to = toWidth
        heightAni.from = fromHeight
        heightAni.to = toHeight
        radiusAni.from = fromRadius
        radiusAni.to = toRadius
        moveInAnimation.start()
    }

    function moveOut(toX, toY, toWidth, toHeight, toRadius)
    {
        xAniOut.to = toX
        yAniOut.to = toY
        widthAniOut.to = toWidth
        heightAniOut.to = toHeight
        radiusAniOut.to = toRadius
        moveOutAnimation.start()
    }

    ParallelAnimation
    {
        id: moveInAnimation
        property int aniDuration: IDPGlobals.slowAnimationDuration
        NumberAnimation
        {
            id: xAni
            target: cvs
            property: "x"
        }
        NumberAnimation
        {
            id: yAni
            target: cvs
            property: "y"
        }
        NumberAnimation
        {
            id: widthAni
            target: cvs
            property: "width"
        }
        NumberAnimation
        {
            id: heightAni
            target: cvs
            property: "height"
        }
        NumberAnimation
        {
            id: radiusAni
            target: the_rect
            property: "radius"
        }
        NumberAnimation
        {
            target: cvs
            property: "opacity"
            to: 1
        }
    }

    ParallelAnimation
    {
        id: moveOutAnimation
        property int aniDuration: IDPGlobals.slowAnimationDuration
        NumberAnimation
        {
            id: xAniOut
            target: cvs
            property: "x"
        }
        NumberAnimation
        {
            id: yAniOut
            target: cvs
            property: "y"
        }
        NumberAnimation
        {
            id: widthAniOut
            target: cvs
            property: "width"
        }
        NumberAnimation
        {
            id: heightAniOut
            target: cvs
            property: "height"
        }
        NumberAnimation
        {
            id: radiusAniOut
            target: the_rect
            property: "radius"
        }
        NumberAnimation
        {
            target: cvs
            property: "opacity"
            to: 0
        }
    }


    function start()
    {
        camera.start()
        opacity = 1
    }
    function searchAndLock()
    {
        camera.searchAndLock()
    }
    property var imageSavedCallback: null
    function captureToFile(targetFileName, imageSavedCallback)
    {
        cvs.imageSavedCallback = imageSavedCallback
        cvs.targetFileName = targetFileName
        camera.imageCapture.capture()
//        camera.imageCapture.captureToLocation(targetFileName)
    }
    Image
    {
        cache: false
        id: clipImage
        visible: false
        width: Math.min(sourceSize.width, sourceSize.height)
        height: width
        fillMode: Image.PreserveAspectCrop
    }

    opacity: 0
    visible: opacity > 0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    signal tagFound(string tag);
    NumberAnimation
    {
        id: animateOutputMargins
        to: 0
        target: output
        property: "anchors.margins"
    }
    PauseAnimation {
        id: waitForSearchAndLock
        duration: 20
        onStopped:
        {
            camera.searchAndLock()
        }
    }

    QZXingFilter {
        id: zxingFilter
        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            tryHarder: true
            onTagFound: {
                if (internetError.visible)
                {
                    console.log("due to internetconnectError QR-Code is not handled")
                    return
                }
                cvs.tagFound(tag)
            }
        }
        captureRect: {
            // setup bindings
            output.contentRect;
            output.sourceRect;
            if (output.orientation == 90 || output.orientation == 270)
            {
                return output.mapRectToSource(
                            output.mapNormalizedRectToItem(
                                Qt.rect(captureZone.topStartFaktor,
                                        captureZone.leftStartFaktor,
                                        captureZone.heightFaktor,
                                        captureZone.widthFaktor)));
            }

            return output.mapRectToSource(
                        output.mapNormalizedRectToItem(
                            Qt.rect(captureZone.leftStartFaktor,
                                    captureZone.topStartFaktor,
                                    captureZone.widthFaktor,
                                    captureZone.heightFaktor)));
        }
    }
    Timer
    {
        running: camera.cameraStatus == Camera.ActiveStatus
        interval: 2000
        repeat: true
        onTriggered: camera.searchAndLock()
    }

    Rectangle
    {
        clip: true
        radius: width / 15
        anchors.fill: parent
        id: the_rect
        color: "grey"
        VideoOutput
        {
            id: output
            autoOrientation: true
            source: camera
            anchors.fill: parent
            focus : visible // to receive focus and capture key events when visible
            filters: cvs.scan ? [ zxingFilter ] : null

            fillMode: VideoOutput.PreserveAspectCrop
            property double leftStartFaktor: 0.2
            property double topStartFaktor: 0.2
            property double widthFaktor: 1 - 2 * leftStartFaktor
            property double heightFaktor: 1 - 2 * topStartFaktor

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: the_rect
            }

            Rectangle
            {
                id: topRect
                height: captureZone.y
                width: parent.width
                opacity: 0.4
                color: ESAA.backgroundTopColor
                visible: cvs.scan
            }
            Rectangle
            {
                id: bottomRect
                y: parent.height - height
                height: parent.height - captureZone.y - captureZone.height
                width: parent.width
                opacity: 0.4
                color: ESAA.backgroundTopColor
                visible: cvs.scan
            }
            Rectangle
            {
                id: leftRect
                y: captureZone.y
                height: captureZone.height
                width: captureZone.x
                opacity: 0.4
                color: ESAA.backgroundTopColor
                visible: cvs.scan
            }
            Rectangle
            {
                id: rightRect
                y: captureZone.y
                height: captureZone.height
                x: parent.width - width
                width: parent.width - captureZone.x - captureZone.width
                opacity: 0.4
                color: ESAA.backgroundTopColor
                visible: cvs.scan
            }

            Item
            {
                id: captureZone
                x: output.contentRect.width * parent.leftStartFaktor + output.contentRect.x
                y: output.contentRect.height * parent.topStartFaktor + output.contentRect.y
                width: output.contentRect.width * parent.widthFaktor
                height: output.contentRect.height * parent.heightFaktor
                visible: cvs.scan
            }
            Rectangle
            {
                height: fokusText.contentHeight
                width: fokusText.contentWidth + ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                color: "black"
                opacity: 0.5
                id: textRectangle
                visible: cvs.scan
            }
            IDPText
            {
                anchors.centerIn: textRectangle
                id: fokusText
                text: "Zum Fokussieren tippen"
                color: ESAA.textColor
                visible: cvs.scan
            }
            MouseArea
            {
                enabled: cvs.scan
                anchors.fill: parent
                onClicked:
                {
                    camera.searchAndLock()
                }
            }
            Rectangle
            {
                id: internetError
                anchors.fill: parent
                color: "red"
                opacity: 0.3
                visible: cvs.scan && !InternetTester.internetConnected && camera.cameraStatus == Camera.ActiveStatus
            }
            IDPText
            {
                visible: cvs.scan && internetError.visible
                anchors.centerIn: parent
                width: parent.width * 2 / 3
                wrapMode: Text.WordWrap
                text: "Bitte kontrolliere und aktiviere die Internetverbindung"
                color: "white"
                font.pixelSize: ESAA.fontMessageTextPixelsize
            }
        }
    }
}
