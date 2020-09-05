import QtQuick 2.12
import QZXing 2.3
import QtMultimedia 5.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.0

ESAAPage
{
    caption: "QR-Code einlesen"
    property int changeCounter: 0
    Rectangle
    {
        id: removeMeLater
        anchors.fill: parent
        color: "white"
    }

    Timer
    {
        interval: 10000
        repeat: true
        running: true
        onTriggered: changeCounter += 1
    }

    id: scannerpage
    onShowing:
    {
        console.log("show scanner")
        if (!ESAA.isActiveVisit(ESAA.lastVisitDateTime, 1))
        {
            camera.stop()
            camera.start()
            camera.searchAndLock()
        }
        shareButton.rotate(400)
    }

    PauseAnimation {
        id: waitForSearchAndLock
        duration: 20
        onStopped: camera.searchAndLock()
    }

    onHiding:
    {
        camera.stop()
    }

    signal playBackClicked;
    signal basketClicked;
    signal questionVisitEnd;

    function decode(preview) {
        photoPreview.source = preview
        decoder.decodeImageQML(photoPreview);
    }

    NumberAnimation
    {
        id: animateOutputMargins
        to: 0
        target: output
        property: "anchors.margins"
    }

    QZXingFilter {
        id: zxingFilter
        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            tryHarder: true
            onTagFound: {
                console.log(tag)
                if (tag.length)
                {
                    ESAA.action(tag)
                }
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
    Camera
    {
        id: camera
        focus.focusMode: Camera.FocusContinuous
        focus.focusPointMode:  Camera.FocusPointAuto
        onCameraStatusChanged: if (cameraStatus == Camera.ActiveStatus) waitForSearchAndLock.start()
    }

    Item
    {
        anchors.top: parent.top
        id: scanneritem
        width: parent.width
        height: width
        Rectangle
        {
            clip: true
            radius: width / 15
            anchors.centerIn: parent
            width: parent.width * 9 / 10
            height: width
            id: the_rect
            VideoOutput
            {
                id: output
                autoOrientation: true
                source: camera
                anchors.fill: parent
                focus : visible // to receive focus and capture key events when visible
                filters: [ zxingFilter ]

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
                }
                Rectangle
                {
                    id: bottomRect
                    y: parent.height - height
                    height: parent.height - captureZone.y - captureZone.height
                    width: parent.width
                    opacity: 0.4
                    color: ESAA.backgroundTopColor
                }
                Rectangle
                {
                    id: leftRect
                    y: captureZone.y
                    height: captureZone.height
                    width: captureZone.x
                    opacity: 0.4
                    color: ESAA.backgroundTopColor
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
                }

                Item
                {
                    id: captureZone
                    x: output.contentRect.width * parent.leftStartFaktor + output.contentRect.x
                    y: output.contentRect.height * parent.topStartFaktor + output.contentRect.y
                    width: output.contentRect.width * parent.widthFaktor
                    height: output.contentRect.height * parent.heightFaktor
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
                    visible: !finishVisit.visible
                }
                ESAAText
                {
                    anchors.centerIn: textRectangle
                    id: fokusText
                    text: "Zum fokussieren tippen"
                    color: ESAA.textColor
                    visible: !finishVisit.visible
                }

                Rectangle
                {
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.8
                    visible: finishVisit.visible
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: camera.searchAndLock()
                }
                ESAAButton
                {
                    id: finishVisit
                    width: parent.width * 0.8
                    anchors.centerIn: parent
                    text: qsTr("Besuch beenden")
                    onClicked:
                    {
                        questionVisitEnd();
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: ESAA.isActiveVisit(ESAA.lastVisitDateTime, changeCounter);
                }

            }
        }
    }
    Item
    {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: scanneritem.bottom
        anchors.right: parent.right
        ESAAText
        {
            text: qsTr("Weiterempfehlen")
            anchors.bottom: shareButton.top
            anchors.bottomMargin: contentHeight / 8
            color: "black"
            font.pixelSize: ESAA.fontTextPixelsize * 1.5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        CircleButton
        {
            id: shareButton
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -height / 5
            onClicked: ESAA.recommend()
            source: "qrc:/images/share_weiss.svg"
            downSource: "qrc:/images/share_blau.svg"
        }
        ESAAButton
        {
            id: lastTransmissionbutton
            width: parent.width * 0.8
            anchors.top: shareButton.bottom
            anchors.topMargin: ESAA.spacing
            text: qsTr("Letzte Übertragung anzeigen")
            onClicked: ESAA.showLastTransmission()
            anchors.horizontalCenter: parent.horizontalCenter
            visible: finishVisit.visible
        }
    }
    Component.onCompleted: camera.stop()
}
