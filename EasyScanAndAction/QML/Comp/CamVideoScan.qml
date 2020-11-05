import QtQuick 2.15
import QZXing 2.3
import QtMultimedia 5.15

Item
{
    id: cvs
    property bool scan: false
    property string targetFileName: ""
    function stop()
    {
        camera.stop()
        opacity = 0
        height = 0
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
    function captureToLocation(targetFileName)
    {
        camera.imageCapture.captureToLocation(targetFileName)
    }

    opacity: 0
    visible: opacity > 0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: 200
        }
    }

    signal tagFound(string tag);
    signal imageSaved(string filename)
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
            theCamera.searchAndLock()
        }
    }
    Camera
    {
        onErrorStringChanged: console.log("error: " + errorString)
        id: camera
        focus.focusMode: Camera.FocusMacro //  Camera.FocusContinuous
        focus.focusPointMode:  Camera.FocusPointAuto
        onCameraStatusChanged: if (cameraStatus == Camera.ActiveStatus) waitForSearchAndLock.start()
        imageCapture {
            onImageSaved: {
                console.log("Saved");
                cvs.imageSaved(cvs.targetFileName)
            }
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

    Item
    {
        id: scanneritem
        anchors.fill: parent
        Rectangle
        {
            clip: true
            radius: width / 15
            anchors.centerIn: parent
            width: parent.width * 9 / 10
            height: width
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
                //                layer.enabled: true
                //                layer.effect:
                //                    OpacityMask
                //                {
                //                    maskSource: the_rect
                //                }
                property double leftStartFaktor: 0.2
                property double topStartFaktor: 0.2
                property double widthFaktor: 1 - 2 * leftStartFaktor
                property double heightFaktor: 1 - 2 * topStartFaktor

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
                ESAAText
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
                ESAAText
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

}
